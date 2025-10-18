import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../services/api_service.dart';
import '../models/prediction_result.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    final user = Firebase.apps.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
    _future = ApiService.getHistory(user?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Prediksi')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada riwayat.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, idx) {
              final it = items[idx];
              final species = it['species'] ?? 'unknown';
              final genes = ((it['genes_detected'] ?? []) as List).map((e) => e.toString()).toList();
              final ts = it['timestamp'] ?? it['created_at'];
              final preds = ((it['predictions'] ?? []) as List).map((e) => e as Map<String, dynamic>).toList();
              return Card(
                child: ListTile(
                  title: Text('Spesies: $species'),
                  subtitle: Text('Gen: ${genes.join(', ')}\nPrediksi: ${preds.map((p) => p['antibiotic']).join(', ')}'),
                  trailing: Text(ts?.toString() ?? ''),
                  onTap: () {
                    final pr = PredictionResult.fromJson(it);
                    Navigator.pushNamed(context, '/result', arguments: pr);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}