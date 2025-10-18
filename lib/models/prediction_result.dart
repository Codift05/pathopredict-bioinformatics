// Model hasil prediksi dari backend
class PredictionItem {
  final String antibiotic;
  final String label;
  final double? probaSensitive;
  final double? probaResistant;
  final double? proba;

  PredictionItem({
    required this.antibiotic,
    required this.label,
    this.probaSensitive,
    this.probaResistant,
    this.proba,
  });

  factory PredictionItem.fromJson(Map<String, dynamic> j) => PredictionItem(
        antibiotic: j['antibiotic'] ?? '-',
        label: j['label'] ?? '-',
        probaSensitive: (j['proba_sensitive'] is num) ? (j['proba_sensitive'] as num).toDouble() : null,
        probaResistant: (j['proba_resistant'] is num) ? (j['proba_resistant'] as num).toDouble() : null,
        proba: (j['proba'] is num) ? (j['proba'] as num).toDouble() : null,
      );
}

class RecommendationItem {
  final String antibiotic;
  final String reason;
  final double? probaSensitive;

  RecommendationItem({required this.antibiotic, required this.reason, this.probaSensitive});

  factory RecommendationItem.fromJson(Map<String, dynamic> j) => RecommendationItem(
        antibiotic: j['antibiotic'] ?? '-',
        reason: j['reason'] ?? '-',
        probaSensitive: (j['proba_sensitive'] is num) ? (j['proba_sensitive'] as num).toDouble() : null,
      );
}

class PredictionResult {
  final String species;
  final List<String> genesDetected;
  final List<PredictionItem> predictions;
  final List<RecommendationItem> recommendations;

  PredictionResult({
    required this.species,
    required this.genesDetected,
    required this.predictions,
    required this.recommendations,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> j) => PredictionResult(
        species: j['species'] ?? 'unknown',
        genesDetected: ((j['genes_detected'] ?? []) as List).map((e) => e.toString()).toList(),
        predictions: ((j['predictions'] ?? []) as List)
            .map((e) => PredictionItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        recommendations: ((j['recommendations'] ?? []) as List)
            .map((e) => RecommendationItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}