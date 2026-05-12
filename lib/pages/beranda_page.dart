import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import 'tambah_tugas_page.dart';
import 'daftar_tugas_page.dart';
import 'pengaturan_page.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int _tugasSelesai = 0;
  int _tugasBelumSelesai = 0;
  List<Map<String, dynamic>> _grafikData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final selesai = await DatabaseHelper.instance.countSelesai();
    final belum = await DatabaseHelper.instance.countBelumSelesai();
    final grafik = await DatabaseHelper.instance.getTugasSelesaiPerHari();
    setState(() {
      _tugasSelesai = selesai;
      _tugasBelumSelesai = belum;
      _grafikData = grafik;
    });
  }

  String _getNamaHari(String tanggal) {
    final date = DateTime.parse(tanggal);
    return DateFormat('EEE', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Beranda',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sapaan
              const Text(
                'Halo, User! 👋',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Kartu statistik
              Row(
                children: [
                  _buildStatCard(
                    label: 'TUGAS SELESAI',
                    value: _tugasSelesai.toString(),
                    color: Colors.teal,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    label: 'BELUM SELESAI',
                    value: _tugasBelumSelesai.toString(),
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Grafik
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TUGAS SELESAI / HARI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _grafikData.isEmpty
                        ? const Center(
                            child: Text(
                              'Belum ada data',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _grafikData.map((item) {
                                final jumlah = item['jumlah'] as int;
                                final maxJumlah = _grafikData
                                    .map((e) => e['jumlah'] as int)
                                    .reduce((a, b) => a > b ? a : b);
                                final tinggi =
                                    (jumlah / maxJumlah) * 50;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      jumlah.toString(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 28,
                                      height: tinggi,
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _getNamaHari(item['tanggal']),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4 tombol navigasi
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildNavButton(
                    icon: Icons.add_circle,
                    label: 'Tambah Tugas Penting',
                    color: Colors.red,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TambahTugasPage(kategori: 'penting'),
                        ),
                      );
                      _loadData();
                    },
                  ),
                  _buildNavButton(
                    icon: Icons.add_circle,
                    label: 'Tambah Tugas Biasa',
                    color: Colors.green,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TambahTugasPage(kategori: 'biasa'),
                        ),
                      );
                      _loadData();
                    },
                  ),
                  _buildNavButton(
                    icon: Icons.list_alt,
                    label: 'Daftar Tugas',
                    color: Colors.teal,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DaftarTugasPage()),
                      );
                      _loadData();
                    },
                  ),
                  _buildNavButton(
                    icon: Icons.settings,
                    label: 'Pengaturan',
                    color: Colors.blueGrey,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PengaturanPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}