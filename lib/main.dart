import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'services/storage_service.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/petugas/petugas_main_screen.dart';
import 'screens/anggota/anggota_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().init();
  runApp(const PerpusApp());
}

class PerpusApp extends StatefulWidget {
  const PerpusApp({super.key});

  @override
  State<PerpusApp> createState() => _PerpusAppState();
}

class _PerpusAppState extends State<PerpusApp> {
  final _storage = StorageService();
  final _auth = AuthService();

  late bool _isDarkMode;
  UserModel? _currentUser;
  String _authView = 'login'; // 'login' | 'register'

  @override
  void initState() {
    super.initState();
    _isDarkMode = _storage.isDarkMode;
    _currentUser = _storage.currentUser;
  }

  void _toggleTheme() async {
    final next = !_isDarkMode;
    await _storage.setDarkMode(next);
    setState(() {
      _isDarkMode = next;
    });
  }

  void _handleLoginSuccess(UserModel user) {
    setState(() {
      _currentUser = user;
    });
  }

  void _handleLogout() async {
    await _auth.logout();
    setState(() {
      _currentUser = null;
      _authView = 'login';
    });
  }

  void _handleDataChanged() {
    setState(() {
      _currentUser = _storage.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMPERPUS Digital - UKK RPL',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    if (_currentUser == null) {
      if (_authView == 'login') {
        return LoginScreen(
          onLoginSuccess: _handleLoginSuccess,
          onNavigateToRegister: () => setState(() => _authView = 'register'),
          onThemeToggled: _toggleTheme,
        );
      } else {
        return RegisterScreen(
          onRegisterSuccess: _handleLoginSuccess,
          onNavigateToLogin: () => setState(() => _authView = 'login'),
        );
      }
    }

    if (_currentUser!.role == 'petugas') {
      return PetugasMainScreen(
        currentUser: _currentUser!,
        onThemeToggled: _toggleTheme,
        onLoggedOut: _handleLogout,
        onDataChanged: _handleDataChanged,
      );
    } else {
      return AnggotaMainScreen(
        currentUser: _currentUser!,
        onThemeToggled: _toggleTheme,
        onLoggedOut: _handleLogout,
        onDataChanged: _handleDataChanged,
      );
    }
  }
}
