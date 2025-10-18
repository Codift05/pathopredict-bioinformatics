// Widget test untuk PathoPredict
import 'package:flutter_test/flutter_test.dart';

import 'package:pathopredict/main.dart';

void main() {
  testWidgets('Home tampil dan memuat aksi', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const PathoPredictApp());

    // Pastikan judul AppBar Home tampil
    expect(find.text('PathoPredict - Home'), findsOneWidget);

    // Tombol aksi utama tersedia
    expect(find.text('Upload Gen/Marker (CSV/JSON/VCF)'), findsOneWidget);
    expect(find.text('Riwayat Prediksi'), findsOneWidget);
  });

  testWidgets('Navigasi ke halaman Upload bekerja',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PathoPredictApp());

    // Tap tombol Upload
    await tester.tap(find.text('Upload Gen/Marker (CSV/JSON/VCF)'));
    await tester.pumpAndSettle();

    // Verifikasi halaman Upload muncul
    expect(find.text('Upload Gen/Marker'), findsOneWidget);
  });
}
