import React from 'react';
import { CheckCircle2, AlertCircle, Info, X } from 'lucide-react';

export const Toast = ({ toast, onClose }) => {
  if (!toast) return null;

  const bgStyles = {
    success: 'bg-emerald-500/95 text-white border-emerald-400',
    error: 'bg-rose-500/95 text-white border-rose-400',
    info: 'bg-indigo-600/95 text-white border-indigo-400',
    warning: 'bg-amber-500/95 text-white border-amber-400'
  };

  const icons = {
    success: <CheckCircle2 className="w-5 h-5 flex-shrink-0" />,
    error: <AlertCircle className="w-5 h-5 flex-shrink-0" />,
    info: <Info className="w-5 h-5 flex-shrink-0" />,
    warning: <AlertCircle className="w-5 h-5 flex-shrink-0" />
  };

  return (
    <div className="fixed bottom-5 right-5 z-50 animate-fade-in no-print">
      <div
        className={`flex items-center gap-3 px-4 py-3 rounded-xl shadow-xl backdrop-blur-md border ${
          bgStyles[toast.type || 'info']
        }`}
        style={{ minWidth: '280px', maxWidth: '420px' }}
      >
        {icons[toast.type || 'info']}
        <div className="flex-1 text-sm font-medium leading-snug">{toast.message}</div>
        <button
          onClick={onClose}
          className="p-1 hover:bg-white/20 rounded-lg transition"
          aria-label="Tutup"
        >
          <X className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
};
