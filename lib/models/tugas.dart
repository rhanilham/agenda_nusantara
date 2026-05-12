class Tugas {
  int? id;
  String judul;
  String deskripsi;
  String tanggalJatuhTempo;
  String kategori; // 'penting' atau 'biasa'
  int selesai; // 0 = belum, 1 = selesai
  String? tanggalSelesai; // untuk grafik di beranda

  Tugas({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggalJatuhTempo,
    required this.kategori,
    this.selesai = 0,
    this.tanggalSelesai,
  });

  // Mengubah objek Tugas menjadi Map (untuk disimpan ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal_jatuh_tempo': tanggalJatuhTempo,
      'kategori': kategori,
      'selesai': selesai,
      'tanggal_selesai': tanggalSelesai,
    };
  }

  // Mengubah Map dari SQLite menjadi objek Tugas
  factory Tugas.fromMap(Map<String, dynamic> map) {
    return Tugas(
      id: map['id'],
      judul: map['judul'],
      deskripsi: map['deskripsi'],
      tanggalJatuhTempo: map['tanggal_jatuh_tempo'],
      kategori: map['kategori'],
      selesai: map['selesai'],
      tanggalSelesai: map['tanggal_selesai'],
    );
  }
}