import '../../../core/database/database_helper.dart';
import '../domain/record.dart';

class RecordDao {
  Future<int> insert(Record record) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert('records', record.toMap());
  }

  Future<List<Record>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('records', orderBy: 'recorded_at DESC');
    return maps.map(Record.fromMap).toList();
  }

  Future<List<Record>> getToday() async {
    final db = await DatabaseHelper.instance.database;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).toIso8601String();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();
    final maps = await db.query(
      'records',
      where: 'recorded_at BETWEEN ? AND ?',
      whereArgs: [start, end],
      orderBy: 'recorded_at DESC',
    );
    return maps.map(Record.fromMap).toList();
  }

  Future<void> update(Record record) async {
    final db = await DatabaseHelper.instance.database;
    await db.update('records', record.toMap(), where: 'id = ?', whereArgs: [record.id]);
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('records', where: 'id = ?', whereArgs: [id]);
  }
}
