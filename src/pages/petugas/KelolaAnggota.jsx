import React, { useState } from 'react';
import {
  UserPlus,
  Search,
  Edit2,
  Trash2,
  CreditCard,
  Phone,
  Mail,
  CheckCircle2,
  XCircle,
  GraduationCap
} from 'lucide-react';
import { memberService } from '../../services/memberService';
import { Modal } from '../../components/Modal';
import { ConfirmDialog } from '../../components/ConfirmDialog';
import { PrintReceiptModal } from '../../components/PrintReceiptModal';

export const KelolaAnggota = ({ showToast }) => {
  const [members, setMembers] = useState(memberService.getAllMembers());
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedClass, setSelectedClass] = useState('Semua');

  // Modal States
  const [isAddEditOpen, setIsAddEditOpen] = useState(false);
  const [editingMember, setEditingMember] = useState(null);
  const [deleteTargetId, setDeleteTargetId] = useState(null);
  const [printingMember, setPrintingMember] = useState(null);

  // Form State
  const initialForm = {
    nisn: '',
    name: '',
    gender: 'Laki-laki',
    kelas: 'XII RPL 1',
    jurusan: 'Rekayasa Perangkat Lunak',
    email: '',
    phone: '',
    address: '',
    status: 'Aktif'
  };
  const [formData, setFormData] = useState(initialForm);

  const refreshMembers = () => {
    setMembers(memberService.getAllMembers());
  };

  const filteredMembers = members.filter((member) => {
    const matchesSearch =
      member.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      member.nisn.includes(searchQuery) ||
      member.kelas.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesClass = selectedClass === 'Semua' || member.kelas === selectedClass;
    return matchesSearch && matchesClass;
  });

  const classList = ['Semua', ...new Set(members.map((m) => m.kelas))];

  const handleOpenAdd = () => {
    setEditingMember(null);
    setFormData(initialForm);
    setIsAddEditOpen(true);
  };

  const handleOpenEdit = (member) => {
    setEditingMember(member);
    setFormData({
      nisn: member.nisn,
      name: member.name,
      gender: member.gender,
      kelas: member.kelas,
      jurusan: member.jurusan,
      email: member.email,
      phone: member.phone,
      address: member.address,
      status: member.status
    });
    setIsAddEditOpen(true);
  };

  const handleFormSubmit = (e) => {
    e.preventDefault();
    try {
      if (editingMember) {
        memberService.updateMember(editingMember.id, formData);
        showToast({ type: 'success', message: `Data anggota ${formData.name} berhasil diperbarui!` });
      } else {
        memberService.createMember(formData);
        showToast({ type: 'success', message: `Anggota baru ${formData.name} berhasil ditambahkan!` });
      }
      setIsAddEditOpen(false);
      refreshMembers();
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    }
  };

  const handleDeleteConfirm = () => {
    if (!deleteTargetId) return;
    try {
      memberService.deleteMember(deleteTargetId);
      showToast({ type: 'success', message: 'Data anggota berhasil dihapus!' });
      refreshMembers();
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    } finally {
      setDeleteTargetId(null);
    }
  };

  return (
    <div className="space-y-6 animate-fade-in">
      {/* Header & Action */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
        <div>
          <h2 className="text-xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            Kelola Data Anggota (Siswa)
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
            Manajemen pendaftaran siswa, NISN, status keanggotaan, dan pencetakan kartu perpustakaan
          </p>
        </div>
        <button
          type="button"
          onClick={handleOpenAdd}
          className="inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs sm:text-sm rounded-xl shadow-md shadow-indigo-600/20 transition"
        >
          <UserPlus className="w-4 h-4" /> Tambah Anggota Baru
        </button>
      </div>

      {/* Filter & Search Bar */}
      <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3">
        <div className="relative flex-1">
          <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            placeholder="Cari nama siswa, NISN, atau kelas..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-10 pr-4 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 text-slate-900 dark:text-white"
          />
        </div>

        <select
          value={selectedClass}
          onChange={(e) => setSelectedClass(e.target.value)}
          className="px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-medium text-slate-700 dark:text-slate-300 focus:outline-none"
        >
          {classList.map((cls) => (
            <option key={cls} value={cls}>
              Kelas: {cls}
            </option>
          ))}
        </select>
      </div>

      {/* Member Table */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs sm:text-sm">
            <thead className="bg-slate-50 dark:bg-slate-800/60 border-b border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400">
              <tr>
                <th className="py-3.5 px-4 font-semibold">Profil & NISN</th>
                <th className="py-3.5 px-4 font-semibold">Kelas & Jurusan</th>
                <th className="py-3.5 px-4 font-semibold">Kontak</th>
                <th className="py-3.5 px-4 font-semibold text-center">Status</th>
                <th className="py-3.5 px-4 font-semibold text-right">Aksi</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800/60">
              {filteredMembers.map((member) => (
                <tr key={member.id} className="hover:bg-slate-50/80 dark:hover:bg-slate-800/40 transition">
                  <td className="py-3 px-4">
                    <div className="flex items-center gap-3">
                      <img
                        src={member.avatar || 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150'}
                        alt={member.name}
                        className="w-10 h-10 rounded-full object-cover border border-slate-200 dark:border-slate-700 flex-shrink-0"
                      />
                      <div>
                        <div className="font-bold text-slate-900 dark:text-white">{member.name}</div>
                        <div className="font-mono text-[11px] text-slate-400">NISN: {member.nisn}</div>
                        <div className="text-[10px] text-slate-500 dark:text-slate-400">
                          Gabung: {member.joinedDate}
                        </div>
                      </div>
                    </div>
                  </td>
                  <td className="py-3 px-4">
                    <div className="font-semibold text-slate-800 dark:text-slate-200">{member.kelas}</div>
                    <div className="text-xs text-indigo-600 dark:text-indigo-400">{member.jurusan}</div>
                  </td>
                  <td className="py-3 px-4">
                    <div className="flex items-center gap-1.5 text-xs text-slate-600 dark:text-slate-300">
                      <Phone className="w-3.5 h-3.5 text-slate-400" /> {member.phone}
                    </div>
                    <div className="flex items-center gap-1.5 text-xs text-slate-400 mt-0.5">
                      <Mail className="w-3.5 h-3.5 text-slate-400" /> {member.email}
                    </div>
                  </td>
                  <td className="py-3 px-4 text-center">
                    <span
                      className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold ${
                        member.status === 'Aktif'
                          ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300'
                          : 'bg-slate-100 text-slate-600'
                      }`}
                    >
                      {member.status === 'Aktif' ? (
                        <CheckCircle2 className="w-3 h-3 text-emerald-500" />
                      ) : (
                        <XCircle className="w-3 h-3 text-slate-400" />
                      )}
                      {member.status}
                    </span>
                  </td>
                  <td className="py-3 px-4 text-right">
                    <div className="flex items-center justify-end gap-1.5">
                      <button
                        type="button"
                        onClick={() => setPrintingMember(member)}
                        className="p-1.5 text-indigo-600 hover:bg-indigo-50 dark:hover:bg-slate-800 rounded-lg transition"
                        title="Cetak Kartu Anggota Digital"
                      >
                        <CreditCard className="w-4 h-4" />
                      </button>
                      <button
                        type="button"
                        onClick={() => handleOpenEdit(member)}
                        className="p-1.5 text-slate-500 hover:text-amber-600 hover:bg-amber-50 dark:hover:bg-slate-800 rounded-lg transition"
                        title="Edit Data"
                      >
                        <Edit2 className="w-4 h-4" />
                      </button>
                      <button
                        type="button"
                        onClick={() => setDeleteTargetId(member.id)}
                        className="p-1.5 text-slate-500 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-slate-800 rounded-lg transition"
                        title="Hapus Anggota"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add / Edit Member Modal */}
      <Modal
        isOpen={isAddEditOpen}
        onClose={() => setIsAddEditOpen(false)}
        title={editingMember ? 'Edit Data Anggota' : 'Pendaftaran Anggota Siswa Baru'}
        subtitle="Data identitas siswa perpustakaan sekolah"
      >
        <form onSubmit={handleFormSubmit} className="space-y-4">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                NISN Siswa *
              </label>
              <input
                type="text"
                required
                maxLength={10}
                placeholder="Contoh: 0061234567"
                value={formData.nisn}
                onChange={(e) => setFormData({ ...formData, nisn: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 font-mono"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Nama Lengkap Siswa *
              </label>
              <input
                type="text"
                required
                placeholder="Nama lengkap sesuai data sekolah"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Jenis Kelamin
              </label>
              <select
                value={formData.gender}
                onChange={(e) => setFormData({ ...formData, gender: e.target.value })}
                className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              >
                <option value="Laki-laki">Laki-laki</option>
                <option value="Perempuan">Perempuan</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Kelas *
              </label>
              <input
                type="text"
                required
                placeholder="Contoh: XII RPL 1"
                value={formData.kelas}
                onChange={(e) => setFormData({ ...formData, kelas: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Jurusan / Keahlian *
              </label>
              <input
                type="text"
                required
                placeholder="Contoh: Rekayasa Perangkat Lunak"
                value={formData.jurusan}
                onChange={(e) => setFormData({ ...formData, jurusan: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Nomor WhatsApp / HP
              </label>
              <input
                type="text"
                placeholder="0812-xxxx-xxxx"
                value={formData.phone}
                onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Status Keanggotaan
              </label>
              <select
                value={formData.status}
                onChange={(e) => setFormData({ ...formData, status: e.target.value })}
                className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              >
                <option value="Aktif">Aktif</option>
                <option value="Nonaktif">Nonaktif</option>
              </select>
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Alamat Domisili
            </label>
            <textarea
              rows={2}
              placeholder="Alamat tempat tinggal siswa..."
              value={formData.address}
              onChange={(e) => setFormData({ ...formData, address: e.target.value })}
              className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
            />
          </div>

          <div className="flex items-center justify-end gap-3 pt-4 border-t border-slate-100 dark:border-slate-800">
            <button
              type="button"
              onClick={() => setIsAddEditOpen(false)}
              className="px-4 py-2 text-xs font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition"
            >
              Batal
            </button>
            <button
              type="submit"
              className="px-5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold rounded-xl shadow-md transition"
            >
              {editingMember ? 'Simpan Data Anggota' : 'Daftarkan Anggota'}
            </button>
          </div>
        </form>
      </Modal>

      {/* Print Member Card Modal */}
      {printingMember && (
        <PrintReceiptModal
          isOpen={!!printingMember}
          onClose={() => setPrintingMember(null)}
          data={printingMember}
          type="member_card"
        />
      )}

      {/* Delete Confirmation */}
      <ConfirmDialog
        isOpen={!!deleteTargetId}
        onClose={() => setDeleteTargetId(null)}
        onConfirm={handleDeleteConfirm}
        title="Hapus Data Anggota"
        message="Apakah Anda yakin ingin menghapus data siswa ini dari keanggotaan perpustakaan?"
        confirmText="Ya, Hapus Anggota"
        type="danger"
      />
    </div>
  );
};
