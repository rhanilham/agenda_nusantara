import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tugas.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('agenda_nusantara.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tugas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        deskripsi TEXT NOT NULL,
        tanggal_jatuh_tempo TEXT NOT NULL,
        kategori TEXT NOT NULL,
        selesai INTEGER NOT NULL DEFAULT 0,
        tanggal_selesai TEXT
      )
    ''');
  }

  // Tambah tugas baru
  Future<int> insertTugas(Tugas tugas) async {
    final db = await instance.database;
    return await db.insert('tugas', tugas.toMap());
  }

  // Ambil semua tugas
  Future<List<Tugas>> getAllTugas() async {
    final db = await instance.database;
    final result = await db.query('tugas', orderBy: 'tanggal_jatuh_tempo ASC');
    return result.map((map) => Tugas.fromMap(map)).toList();
  }

  // Update status selesai
  Future<int> updateStatusSelesai(int id, int selesai) async {
    final db = await instance.database;
    return await db.update(
      'tugas',
      {
        'selesai': selesai,
        'tanggal_selesai': selesai == 1
            ? DateTime.now().toIso8601String().substring(0, 10)
            : null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Hitung tugas selesai
  Future<int> countSelesai() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM tugas WHERE selesai = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Hitung tugas belum selesai
  Future<int> countBelumSelesai() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM tugas WHERE selesai = 0');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Ambil jumlah tugas selesai per hari (untuk grafik)
  Future<List<Map<String, dynamic>>> getTugasSelesaiPerHari() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT tanggal_selesai as tanggal, COUNT(*) as jumlah
      FROM tugas
      WHERE selesai = 1 AND tanggal_selesai IS NOT NULL
      GROUP BY tanggal_selesai
      ORDER BY tanggal_selesai ASC
    ''');
  }
}