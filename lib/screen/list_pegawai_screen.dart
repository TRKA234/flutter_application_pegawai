import 'package:flutter/material.dart';
import '../models/pegawai_model.dart';
import '../services/pegawai_service.dart';
import 'add_pegawai_screen.dart';
//import 'edit_pegawai_screen.dart';
import 'detail_pegawai_screen.dart';

class ListPegawaiScreen extends StatefulWidget {
  const ListPegawaiScreen({super.key});

  @override
  State<ListPegawaiScreen> createState() => _ListPegawaiScreenState();
}

class _ListPegawaiScreenState extends State<ListPegawaiScreen> {
  final PegawaiService _service = PegawaiService();
  late Future<List<Pegawai>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchPegawaiList();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.fetchPegawaiList();
    });
    await _future;
  }

  void _delete(Pegawai p) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Pegawai'),
        content: Text('Yakin menghapus ${p.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _service.deletePegawai(p.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil dihapus')));
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pegawai')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Pegawai>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return const Center(child: Text('Belum ada data'));
            }
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = list[index];
                return ListTile(
                  title: Text(p.nama),
                  subtitle: Text('${p.jabatan} • Rp${p.gaji}'),
                  onTap: () async {
                    final changed = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPegawaiScreen(pegawai: p),
                      ),
                    );
                    if (changed == true) _refresh();
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _delete(p),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPegawaiScreen()),
          );
          if (created == true) _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
