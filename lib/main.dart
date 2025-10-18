import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/upload_page.dart';
import 'pages/result_page.dart';
import 'pages/history_page.dart';

// Komentar dalam Bahasa Indonesia
// Aplikasi PathoPredict: routing dasar + Firebase Auth

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase dengan fallback agar Web tidak blank bila opsi belum dikonfigurasi
  try {
    await Firebase.initializeApp(); // Untuk Web, butuh FirebaseOptions; akan tertangkap jika belum ada
  } catch (_) {
    // Fallback: lanjutkan tanpa Firebase (mode lokal)
  }
  runApp(const PathoPredictApp());
}

class PathoPredictApp extends StatelessWidget {
  const PathoPredictApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PathoPredict',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const _AuthGate(),
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/upload': (_) => const UploadPage(),
        '/result': (_) => const ResultPage(),
        '/history': (_) => const HistoryPage(),
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();
  @override
  Widget build(BuildContext context) {
    // Jika Firebase belum terinisialisasi (misal Web tanpa konfigurasi), langsung ke Home
    if (Firebase.apps.isEmpty) {
      return const HomePage();
    }
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
