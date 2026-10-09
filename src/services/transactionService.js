import { STORAGE_KEYS, getStorageData, setStorageData, logActivity } from './storage';
import { authService } from './authService';

export const transactionService = {
  getAllTransactions: () => {
    // Dynamically calculate latest overdue status and fine for all active transactions
    const rawList = getStorageData(STORAGE_KEYS.TRANSACTIONS) || [];
    const settings = getStorageData(STORAGE_KEYS.SETTINGS) || {};
    const finePerDay = settings.finePerDay || 1000;
    const todayStr = new Date().toISOString().split('T')[0];

    return rawList.map((tx) => {
      if (tx.status === 'Kembali') {
        return tx;
      }
      
      // If still active, check if due date passed
      const dueDate = new Date(tx.dueDate);
      const today = new Date(todayStr);
      const diffTime = today.getTime() - dueDate.getTime();
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

      if (diffDays > 0) {
        return {
          ...tx,
          status: 'Terlambat',
          daysLate: diffDays,
          fineAmount: diffDays * finePerDay
        };
      } else {
        return {
          ...tx,
          status: 'Dipinjam',
          daysLate: 0,
          fineAmount: 0
        };
      }
    });
  },

  borrowBook: ({ memberId, bookId, notes, customDays }) => {
    const members = getStorageData(STORAGE_KEYS.MEMBERS) || [];
    const books = getStorageData(STORAGE_KEYS.BOOKS) || [];
    const transactions = getStorageData(STORAGE_KEYS.TRANSACTIONS) || [];
    const settings = getStorageData(STORAGE_KEYS.SETTINGS) || {};

    const member = members.find((m) => m.id === memberId);
    if (!member) {
      throw new Error('Data anggota tidak ditemukan!');
    }
    if (member.status !== 'Aktif') {
      throw new Error('Status keanggotaan tidak aktif. Tidak dapat meminjam buku!');
    }

    // Check active loan limit
    const activeLoans = transactions.filter(
      (t) => t.memberId === memberId && (t.status === 'Dipinjam' || t.status === 'Terlambat')
    );
    const maxLimit = settings.maxBorrowLimit || 3;
    if (activeLoans.length >= maxLimit) {
      throw new Error(`Anggota telah mencapai batas maksimal peminjaman (${maxLimit} buku aktif)!`);
    }

    // Check if member has unreturned overdue books
    const hasOverdue = activeLoans.some((t) => {
      const due = new Date(t.dueDate);
      const today = new Date();
      return today > due;
    });
    if (hasOverdue) {
      throw new Error('Anggota memiliki buku yang terlambat dikembalikan. Harap kembalikan buku terlebih dahulu!');
    }

    const book = books.find((b) => b.id === bookId);
    if (!book) {
      throw new Error('Data buku tidak ditemukan!');
    }
    if (book.availableStock <= 0) {
      throw new Error('Stok buku saat ini sedang habis / tidak tersedia!');
    }

    // Reduce stock and increment borrow count
    book.availableStock -= 1;
    book.borrowedCount = (book.borrowedCount || 0) + 1;

    const loanDays = customDays || settings.loanDurationDays || 7;
    const borrowDate = new Date();
    const dueDate = new Date();
    dueDate.setDate(borrowDate.getDate() + loanDays);

    const currentUser = authService.getCurrentUser();
    const txId = `TRX-${borrowDate.getFullYear()}-${String(transactions.length + 1).padStart(3, '0')}`;

    const newTx = {
      id: txId,
      memberId: member.id,
      memberName: member.name,
      memberNisn: member.nisn,
      bookId: book.id,
      bookTitle: book.title,
      bookIsbn: book.isbn,
      borrowDate: borrowDate.toISOString().split('T')[0],
      dueDate: dueDate.toISOString().split('T')[0],
      returnDate: null,
      status: 'Dipinjam',
      fineAmount: 0,
      officerName: currentUser?.name || 'Petugas Perpustakaan',
      notes: notes || 'Peminjaman Reguler Perpustakaan'
    };

    setStorageData(STORAGE_KEYS.BOOKS, books);
    setStorageData(STORAGE_KEYS.TRANSACTIONS, [newTx, ...transactions]);

    logActivity(
      currentUser,
      'BORROW_BOOK',
      `Peminjaman buku "${book.title}" oleh ${member.name} (Tempo: ${newTx.dueDate})`
    );

    return newTx;
  },

  returnBook: (transactionId, notes) => {
    const transactions = getStorageData(STORAGE_KEYS.TRANSACTIONS) || [];
    const books = getStorageData(STORAGE_KEYS.BOOKS) || [];
    const settings = getStorageData(STORAGE_KEYS.SETTINGS) || {};
    const finePerDay = settings.finePerDay || 1000;

    const txIndex = transactions.findIndex((t) => t.id === transactionId);
    if (txIndex === -1) {
      throw new Error('Transaksi peminjaman tidak ditemukan!');
    }

    const tx = transactions[txIndex];
    if (tx.status === 'Kembali') {
      throw new Error('Buku ini sudah dikembalikan sebelumnya!');
    }

    // Calculate fine
    const todayStr = new Date().toISOString().split('T')[0];
    const dueDate = new Date(tx.dueDate);
    const returnDate = new Date(todayStr);
    const diffTime = returnDate.getTime() - dueDate.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    let fine = 0;
    let daysLate = 0;
    if (diffDays > 0) {
      daysLate = diffDays;
      fine = daysLate * finePerDay;
    }

    // Restore book stock
    const bookIndex = books.findIndex((b) => b.id === tx.bookId);
    if (bookIndex !== -1) {
      books[bookIndex].availableStock = Math.min(books[bookIndex].stock, books[bookIndex].availableStock + 1);
      setStorageData(STORAGE_KEYS.BOOKS, books);
    }

    const currentUser = authService.getCurrentUser();
    const updatedTx = {
      ...tx,
      returnDate: todayStr,
      status: 'Kembali',
      fineAmount: fine,
      daysLate: daysLate,
      returnOfficer: currentUser?.name || 'Petugas',
      notes: notes ? `${tx.notes || ''} | Ket. Kembali: ${notes}` : tx.notes
    };

    transactions[txIndex] = updatedTx;
    setStorageData(STORAGE_KEYS.TRANSACTIONS, transactions);

    logActivity(
      currentUser,
      'RETURN_BOOK',
      `Pengembalian buku "${tx.bookTitle}" oleh ${tx.memberName}. Denda: Rp ${fine.toLocaleString('id-ID')}`
    );

    return updatedTx;
  },

  extendLoan: (transactionId, extraDays = 7) => {
    const transactions = getStorageData(STORAGE_KEYS.TRANSACTIONS) || [];
    const txIndex = transactions.findIndex((t) => t.id === transactionId);
    if (txIndex === -1) {
      throw new Error('Transaksi peminjaman tidak ditemukan!');
    }

    const tx = transactions[txIndex];
    if (tx.status === 'Kembali') {
      throw new Error('Peminjaman sudah selesai, tidak bisa diperpanjang!');
    }

    const currentDue = new Date(tx.dueDate);
    currentDue.setDate(currentDue.getDate() + extraDays);
    const newDueDate = currentDue.toISOString().split('T')[0];

    const updatedTx = {
      ...tx,
      dueDate: newDueDate,
      notes: `${tx.notes || ''} (Diperpanjang +${extraDays} hari)`
    };

    transactions[txIndex] = updatedTx;
    setStorageData(STORAGE_KEYS.TRANSACTIONS, transactions);

    logActivity(
      authService.getCurrentUser(),
      'EXTEND_LOAN',
      `Perpanjangan pinjam "${tx.bookTitle}" sampai ${newDueDate}`
    );

    return updatedTx;
  }
};
