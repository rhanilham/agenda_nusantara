import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/tugas.dart';

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({super.key});

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage> {
  List<Tugas> _daftarTugas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTugas();
  }

  Future<void> _loadTugas() async {
    final data = await DatabaseHelper.instance.getAllTugas();
    setState(() {
      _daftarTugas = data;
      _isLoading = false;
    });
  }

  Future<void> _toggleSelesai(Tugas tugas) async {
    final newStatus = tugas.selesai == 1 ? 0 : 1;
    await DatabaseHelper.instance.updateStatusSelesai(tugas.id!, newStatus);
    _loadTugas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _daftarTugas.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Belum ada tugas',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _daftarTugas.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final tugas = _daftarTugas[index];
                    final isPenting = tugas.kategori == 'penting';
                    final arrowColor =
                        isPenting ? Colors.red : Colors.green;
                    final isSelesai = tugas.selesai == 1;
                    final tanggal = DateFormat('dd MMM yyyy').format(
                        DateTime.parse(tugas.tanggalJatuhTempo));

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      leading: GestureDetector(
                        onTap: () => _toggleSelesai(tugas),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelesai
                                  ? Colors.teal
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            color: isSelesai ? Colors.teal : Colors.white,
                          ),
                          child: isSelesai
                              ? const Icon(Icons.check,
                                  size: 18, color: Colors.white)
                              : null,
                        ),
                      ),
                      title: Text(
                        tugas.judul,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          decoration: isSelesai
                              ? TextDecoration.lineThrough
                              : null,
                          color: isSelesai ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '$tanggal · ${isPenting ? "Penting" : "Biasa"}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelesai
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: arrowColor,
                      ),
                      onTap: () => _toggleSelesai(tugas),
                    );
                  },
                ),
    );
  }
}