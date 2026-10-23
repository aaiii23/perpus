import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final ValueChanged<UserModel> onRegisterSuccess;
  final VoidCallback onNavigateToLogin;

  const RegisterScreen({
    super.key,
    required this.onRegisterSuccess,
    required this.onNavigateToLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authService = AuthService();

  final _nisnController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _kelasController = TextEditingController(text: 'XII RPL 1');
  final _jurusanController = TextEditingController(text: 'Rekayasa Perangkat Lunak');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController(text: '0812-');

  bool _isLoading = false;

  @override
  void dispose() {
    _nisnController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
    _kelasController.dispose();
    _jurusanController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final nisn = _nisnController.text.trim();
    final username = _usernameController.text.trim();
    final name = _nameController.text.trim();
    final kelas = _kelasController.text.trim();
    final jurusan = _jurusanController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (nisn.isEmpty || username.isEmpty || name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi semua kolom bertanda wajib!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final newUser = await _authService.registerMember(
        username: username,
        password: password,
        name: name,
        nisn: nisn,
        kelas: kelas,
        jurusan: jurusan,
        email: email,
        phone: _phoneController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pendaftaran berhasil! Selamat datang, ${newUser.name}'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onRegisterSuccess(newUser);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Siswa Baru', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onNavigateToLogin,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.school_rounded, color: Color(0xFF4F46E5), size: 28),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Pendaftaran Anggota Siswa',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Khusus Siswa / Anggota SMK Terdaftar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // NISN & Username
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nisnController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'NISN Siswa *',
                              hintText: '006xxxxxxx',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username *',
                              hintText: 'username',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Full Name
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap Siswa *',
                        prefixIcon: Icon(Icons.badge_rounded, size: 20),
                        hintText: 'Sesuai rapor sekolah',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Kelas & Jurusan
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _kelasController,
                            decoration: const InputDecoration(
                              labelText: 'Kelas *',
                              hintText: 'XII RPL 1',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _jurusanController,
                            decoration: const InputDecoration(
                              labelText: 'Jurusan *',
                              hintText: 'RPL',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Siswa *',
                        prefixIcon: Icon(Icons.email_rounded, size: 20),
                        hintText: 'siswa@smk.sch.id',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Phone & Password
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'No. WhatsApp',
                              prefixIcon: Icon(Icons.phone_rounded, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password *',
                              prefixIcon: Icon(Icons.lock_rounded, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Daftar Sebagai Anggota'),
                    ),
                    const SizedBox(height: 16),

                    Center(
                      child: TextButton.icon(
                        onPressed: widget.onNavigateToLogin,
                        icon: const Icon(Icons.arrow_back_rounded, size: 16),
                        label: const Text('Kembali ke Halaman Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
