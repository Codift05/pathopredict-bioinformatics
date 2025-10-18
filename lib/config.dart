import 'package:flutter/foundation.dart';

// Konfigurasi aplikasi Flutter
// Base URL menyesuaikan platform agar Android emulator bisa mengakses host (10.0.2.2)
class AppConfig {
  static String get baseUrl {
    const port = 5000;
    if (kIsWeb) return 'http://localhost:$port';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:$port';
    return 'http://localhost:$port';
  }
}