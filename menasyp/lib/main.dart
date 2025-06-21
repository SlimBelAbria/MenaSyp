import 'package:flutter/material.dart';
import 'package:menasyp/services/auth_service_gs.dart';
import 'package:menasyp/services/auth_wrapper.dart';
import 'package:menasyp/services/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}