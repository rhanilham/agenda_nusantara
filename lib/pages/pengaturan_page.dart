import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final _passwordSaatIniController = TextEditingController();
  final _passwordBaruController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordSaatIniController.dispose();
    _passwordBaruController.dispose();
    super.dispose();
  }

  Future<void> _simpanPassword() async {
    final passwordSaatIni = _passwordSaatIniController.text.trim();
    final passwordBaru = _passwordBaruController.text.trim();

    if (passwordSaatIni.isEmpty || passwordBaru.isEmpty) {
      _showSnackbar('Semua field harus diisi', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('password') ?? 'user';

    if (passwordSaatIni != savedPassword) {
      setState(() => _isLoading = false);
      _showSnackbar('Password saat ini salah', Colors.red);
      return;
    }

    await prefs.setString('password', passwordBaru);

    setState(() => _isLoading = false);
    _passwordSaatIniController.clear();
    _passwordBaruController.clear();

    _showSnackbar('Password berhasil diubah', Colors.teal);
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
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
          'Pengaturan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section ganti password
            const Text(
              'GANTI PASSWORD',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Password saat ini
            const Text(
              'PASSWORD SAAT INI',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordSaatIniController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '••••',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Password baru
            const Text(
              'PASSWORD BARU',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordBaruController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '••••••••',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol simpan password
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _simpanPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SIMPAN PASSWORD',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),

            // Section developer
            const Text(
              'DEVELOPER',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Foto developer (gunakan avatar default)
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.teal.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 36,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Rhanilham Fadlillatul Ramadhan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'NIM: 2241720161',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'DEVELOPER APLIKASI',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}