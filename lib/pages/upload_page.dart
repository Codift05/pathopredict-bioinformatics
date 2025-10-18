import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../services/api_service.dart';
import '../models/prediction_result.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _selectedFile;
  final _genesCtrl = TextEditingController();
  final _speciesCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _pickFile() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv', 'json', 'vcf']);
    if (res != null && res.files.isNotEmpty) {
      final path = res.files.first.path;
      if (path != null) setState(() => _selectedFile = File(path));
    }
  }

  Future<void> _upload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final genes = _genesCtrl.text.isNotEmpty ? _genesCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList() : null;
      final species = _speciesCtrl.text.isNotEmpty ? _speciesCtrl.text.trim() : null;
      final json = await ApiService.uploadGenes(file: _selectedFile, genes: genes, species: species);
      final result = PredictionResult.fromJson(json);
      if (mounted) {
        Navigator.pushNamed(context, '/result', arguments: result);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Firebase.apps.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Gen/Marker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${user?.email ?? user?.uid ?? '-'}'),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Pilih File (CSV/JSON/VCF)'),
                ),
                const SizedBox(width: 8),
                if (_selectedFile != null) Expanded(child: Text(_selectedFile!.path))
              ],
            ),
            const SizedBox(height: 12),
            const Text('Atau input manual (dipisah koma):'),
            TextField(
              controller: _genesCtrl,
              decoration: const InputDecoration(hintText: 'GENE1,GENE2,...'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _speciesCtrl,
              decoration: const InputDecoration(labelText: 'Species (opsional)'),
            ),
            const SizedBox(height: 16),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loading ? null : _upload,
              icon: const Icon(Icons.cloud_upload),
              label: _loading ? const CircularProgressIndicator() : const Text('Upload & Prediksi'),
            ),
          ],
        ),
      ),
    );
  }
}