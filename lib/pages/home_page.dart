import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Firebase.apps.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PathoPredict - Home'),
        actions: [
          if (Firebase.apps.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Keluar',
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
              },
            )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Halo, ${user?.email ?? user?.uid ?? 'Pengguna'}'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/upload'),
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Gen/Marker (CSV/JSON/VCF)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/history'),
              icon: const Icon(Icons.history),
              label: const Text('Riwayat Prediksi'),
            ),
          ],
        ),
      ),
    );
  }
}