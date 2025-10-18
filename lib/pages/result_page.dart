import 'package:flutter/material.dart';

import '../models/prediction_result.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final result = args is PredictionResult ? args : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Prediksi')),
      body: result == null
          ? const Center(child: Text('Tidak ada hasil.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Spesies: ${result.species}'),
                  const SizedBox(height: 8),
                  Text('Gen terdeteksi (${result.genesDetected.length}): ${result.genesDetected.join(', ')}'),
                  const SizedBox(height: 16),
                  const Text('Prediksi per antibiotik:'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: result.predictions.length,
                      itemBuilder: (context, idx) {
                        final p = result.predictions[idx];
                        return Card(
                          child: ListTile(
                            title: Text(p.antibiotic),
                            subtitle: Text('Label: ${p.label}\nProba sensitif: ${p.probaSensitive?.toStringAsFixed(3) ?? '-'} | Proba resisten: ${p.probaResistant?.toStringAsFixed(3) ?? '-'}'),
                            trailing: Text((p.proba ?? 0.0).toStringAsFixed(3)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Rekomendasi alternatif:'),
                  ...result.recommendations.map((r) => ListTile(
                        leading: const Icon(Icons.medical_services),
                        title: Text(r.antibiotic),
                        subtitle: Text('${r.reason} | proba sensitif: ${r.probaSensitive?.toStringAsFixed(3) ?? '-'}'),
                      )),
                ],
              ),
            ),
    );
  }
}