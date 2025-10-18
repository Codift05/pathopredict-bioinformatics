# PathoPredict

Aplikasi Flutter untuk mengunggah file/gambar dan menerima hasil prediksi dari backend machine learning. Menyediakan autentikasi, riwayat prediksi, serta tampilan hasil.

## Fitur
- Login dan logout
- Unggah file/gambar untuk diproses
- Hasil prediksi dengan detail
- Riwayat prediksi sebelumnya

## Teknologi
- Flutter & Dart
- Firebase Auth/Firestore (opsional sesuai konfigurasi)
- Backend ML (Python/REST, dikelola terpisah)

## Memulai
`ash
git clone https://github.com/Codift05/pathopredict-bioinformatics.git
cd pathopredict-bioinformatics
flutter pub get
`

### Konfigurasi
- Sesuaikan endpoint backend pada file lib/config.dart.
- Pastikan backend aktif dan dapat diakses dari perangkat/ emulator.

### Menjalankan Aplikasi
`ash
# Android
flutter run

# Web
flutter run -d chrome

# Windows (desktop)
flutter run -d windows
`

### Build
`ash
# Android APK
flutter build apk

# Web
flutter build web
`

## Struktur Proyek (ringkas)
- lib/ sumber kode Flutter (pages, services, models)
- ackend/ utilitas backend (service disediakan terpisah)
- ml/ skrip ML seperti 	rain_model.py
- ndroid/, ios/, web/, windows/, macos/ berkas platform

## Catatan Repo
- Artefak build dan cache besar diabaikan oleh .gitignore.
- Untuk aset besar permanen, pertimbangkan Git LFS.

## Kontribusi
Pull request dan issue sangat diterima. Mohon sertakan deskripsi yang jelas.


