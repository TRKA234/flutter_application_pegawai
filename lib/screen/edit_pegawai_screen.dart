import 'package:flutter/material.dart';
import '../models/pegawai_model.dart';
import '../services/pegawai_service.dart';

class EditPegawaiScreen extends StatefulWidget {
  final Pegawai pegawai;
  const EditPegawaiScreen({super.key, required this.pegawai});

  @override
  State<EditPegawaiScreen> createState() => _EditPegawaiScreenState();
}

class _EditPegawaiScreenState extends State<EditPegawaiScreen> {
  late final TextEditingController namaController;
  late final TextEditingController jabatanController;
  late final TextEditingController gajiController;
  bool isLoading = false;
  final PegawaiService _service = PegawaiService();

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.pegawai.nama);
    jabatanController = TextEditingController(text: widget.pegawai.jabatan);
    gajiController = TextEditingController(
      text: widget.pegawai.gaji.toString(),
    );
  }

  Future<void> _submit() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    try {
      final Pegawai payload = Pegawai(
        id: widget.pegawai.id,
        nama: namaController.text,
        jabatan: jabatanController.text,
        gaji: int.tryParse(gajiController.text) ?? widget.pegawai.gaji,
      );
      await _service.updatePegawai(payload);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil memperbarui pegawai')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pegawai')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: jabatanController,
              decoration: const InputDecoration(
                labelText: 'Jabatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: gajiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Gaji',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _submit,
                child: isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                    : const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
