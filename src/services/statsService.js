import { bookService } from './bookService';
import { memberService } from './memberService';
import { transactionService } from './transactionService';
import { getStorageData, STORAGE_KEYS } from './storage';

export const statsService = {
  getDashboardStats: () => {
    const books = bookService.getAllBooks();
    const members = memberService.getAllMembers();
    const transactions = transactionService.getAllTransactions();

    const totalBooks = books.reduce((acc, b) => acc + (b.stock || 0), 0);
    const totalTitles = books.length;
    const totalMembers = members.length;
    const activeMembers = members.filter((m) => m.status === 'Aktif').length;

    const activeLoans = transactions.filter((t) => t.status === 'Dipinjam');
    const overdueLoans = transactions.filter((t) => t.status === 'Terlambat');
    const returnedLoans = transactions.filter((t) => t.status === 'Kembali');

    const totalFinesCollected = returnedLoans.reduce((acc, t) => acc + (t.fineAmount || 0), 0);
    const potentialOverdueFines = overdueLoans.reduce((acc, t) => acc + (t.fineAmount || 0), 0);

    // Top 5 Most Borrowed Books
    const topBooks = [...books]
      .sort((a, b) => (b.borrowedCount || 0) - (a.borrowedCount || 0))
      .slice(0, 5);

    // Monthly circulation aggregation (Past 6 months mock/real)
    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    const currentMonth = new Date().getMonth();
    const monthlyData = [];

    for (let i = 5; i >= 0; i--) {
      const mIndex = (currentMonth - i + 12) % 12;
      monthlyData.push({
        month: monthNames[mIndex],
        pinjam: Math.floor(12 + Math.random() * 20) + (i === 0 ? transactions.length : 0),
        kembali: Math.floor(10 + Math.random() * 18) + (i === 0 ? returnedLoans.length : 0)
      });
    }

    return {
      totalTitles,
      totalBooks,
      totalMembers,
      activeMembers,
      activeLoansCount: activeLoans.length,
      overdueLoansCount: overdueLoans.length,
      totalTransactionsCount: transactions.length,
      totalFinesCollected,
      potentialOverdueFines,
      topBooks,
      monthlyData,
      recentTransactions: transactions.slice(0, 6)
    };
  },

  getMemberStats: (memberNisn) => {
    const transactions = transactionService.getAllTransactions().filter(
      (t) => t.memberNisn === memberNisn
    );

    const activeLoans = transactions.filter((t) => t.status === 'Dipinjam');
    const overdueLoans = transactions.filter((t) => t.status === 'Terlambat');
    const completedLoans = transactions.filter((t) => t.status === 'Kembali');

    const totalFines = transactions.reduce((acc, t) => acc + (t.fineAmount || 0), 0);

    return {
      totalBorrowed: transactions.length,
      activeLoans,
      overdueLoans,
      completedLoans,
      totalFines,
      recentActivity: transactions.slice(0, 5)
    };
  },

  exportToCSV: (data, filename = 'laporan_perpustakaan.csv') => {
    if (!data || !data.length) return;
    const headers = Object.keys(data[0]).join(',');
    const rows = data.map((obj) =>
      Object.values(obj)
        .map((val) => `"${String(val ?? '').replace(/"/g, '""')}"`)
        .join(',')
    );
    const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + [headers, ...rows].join('\n');
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', filename);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
};
