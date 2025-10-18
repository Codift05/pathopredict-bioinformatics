import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../config.dart';

// Komentar dalam Bahasa Indonesia
// ApiService: memanggil backend Flask untuk upload genes dan mengambil history
class ApiService {
  static String get _base => AppConfig.baseUrl;

  // Upload file CSV/JSON/VCF atau payload JSON berisi list gen
  static Future<Map<String, dynamic>> uploadGenes({
    File? file,
    List<String>? genes,
    String? species,
  }) async {
    final user = Firebase.apps.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
    final headers = <String, String>{
      'X-User-Id': user?.uid ?? '',
    };

    if (file != null && await file.exists()) {
      final uri = Uri.parse('$_base/upload_genes');
      final req = http.MultipartRequest('POST', uri);
      req.headers.addAll(headers);
      req.files.add(await http.MultipartFile.fromPath('file', file.path));
      if (species != null) {
        req.fields['species'] = species;
      }
      final resp = await req.send();
      final body = await resp.stream.bytesToString();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return json.decode(body) as Map<String, dynamic>;
      }
      throw Exception('Gagal upload: ${resp.statusCode} $body');
    }

    // Fallback: kirim JSON sederhana
    final uri = Uri.parse('$_base/upload_genes');
    final payload = {
      if (genes != null) 'genes': genes,
      if (species != null) 'species': species,
    };
    final resp = await http.post(uri,
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: json.encode(payload));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Gagal upload: ${resp.statusCode} ${resp.body}');
  }

  // Ambil history dari backend (Firestore)
  static Future<List<Map<String, dynamic>>> getHistory(String userId) async {
    final uri = Uri.parse('$_base/history/$userId');
    final resp = await http.get(uri);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = json.decode(resp.body) as Map<String, dynamic>;
      final items = (data['items'] as List?) ?? [];
      return items.map((e) => e as Map<String, dynamic>).toList();
    }
    throw Exception('Gagal mengambil history: ${resp.statusCode} ${resp.body}');
  }
}