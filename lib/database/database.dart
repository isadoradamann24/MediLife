import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/remedio.dart';

class DatabaseHandler {

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'medlife.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''
          CREATE TABLE remedios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            quantidade INTEGER NOT NULL,
            horario TEXT NOT NULL,
            motivo TEXT,
            dias TEXT NOT NULL,
            tomou INTEGER NOT NULL
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertRemedio(List<Remedio> remedios) async {
    int result = 0;
    final Database db = await initializeDB();

    for (var remedio in remedios) {
      result = await db.insert(
        'remedios',
        remedio.toMap(),
      );
    }

    return result;
  }

  Future<List<Remedio>> retrieveRemedios() async {
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult =
        await db.query(
          'remedios',
          orderBy: 'id DESC',
        );

    return queryResult
        .map((e) => Remedio.fromMap(e))
        .toList();
  }

  Future<Remedio?> retrieveRemedioById(int id) async {
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult =
        await db.query(
          'remedios',
          where: 'id = ?',
          whereArgs: [id],
        );

    if (queryResult.isNotEmpty) {
      return Remedio.fromMap(queryResult.first);
    }

    return null;
  }

  Future<int> updateRemedio(
    int id,
    Map<String, Object?> remedio,
  ) async {
    final Database db = await initializeDB();

    return await db.update(
      'remedios',
      remedio,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteRemedio(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      'remedios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}