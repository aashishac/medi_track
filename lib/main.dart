import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/core/network/connectivity_provider.dart';
import 'package:meditrack/core/theme/app_theme.dart';
import 'package:meditrack/features/auth/presentation/pages/login_page.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/features/home/presentation/pages/tab_page.dart';
import 'package:meditrack/features/home/presentation/providers/user_provider.dart';
import 'package:meditrack/features/patient/presentation/providers/patient_provider.dart';
import 'package:meditrack/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage((message) async {});
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PatientProvider()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(
          create: (context) => UserProvider()..fetchDoctorData(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..loadProfileImage(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medi Track',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      home: AuthWrapper(),
    );
  }
}

// wrapper to navigate user based on their login state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return StreamBuilder(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        // 1. if the stream is still trying to connect ot firebase
        if (snapshot.connectionState == .waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. if the snapshot has  data, the user is logged in
        if (snapshot.hasData) {
          return const TabPage();
        }

        // 3. otherwise, the user is logged out
        return const LoginPage();
      },
    );
  }
}
