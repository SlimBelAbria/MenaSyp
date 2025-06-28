import 'package:flutter/material.dart';
import 'package:menasyp/screens/home_screen.dart';
import 'package:menasyp/screens/login_screen.dart';
import 'package:menasyp/screens/splash_screen.dart';
import 'package:menasyp/services/auth_service_gs.dart';
import 'package:menasyp/services/user_provider.dart';
import 'package:provider/provider.dart';
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for both minimum delay and auth check
    final authService = Provider.of<AuthService>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final results = await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      authService.isLoggedIn(),
    ]);

    final isLoggedIn = results[1] as bool;

    if (isLoggedIn) {
      await userProvider.loadCurrentUser();
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: OnBoardScreen()),
    );
  }
}