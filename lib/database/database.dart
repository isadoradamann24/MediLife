import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/remedio.dart';

class DatabaseHandler {

  //Iniciar/criar banco de dados 
  Future<Database> initializeDB() async {
    final String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'remedios.db'),

      version: 1,

      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE remedios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            quantidade INTEGER NOT NULL,
            horario TEXT NOT NULL,
            motivo TEXT NOT NULL,
            dias TEXT NOT NULL
          )
        ''');
      },
    );
  }

  //Inserir na tabela
  Future<int> insertRemedio(Remedio remedio) async {
    final Database db = await initializeDB();

    final int id = await db.insert(
      'remedios',
      remedio.toMap(),
    );

    return id;
  }

  //Editar remédios
  Future<int> updateRemedio(Remedio remedio) async {
    final Database db = await initializeDB();

    final int linhasAfetadas = await db.update(
      'remedios',
      remedio.toMap(),
      where: 'id = ?',
      whereArgs: [remedio.id],
    );

    return linhasAfetadas;
  }

  //Mostrar os remédios
  Future<List<Remedio>> retrieveRemedios() async {
    final Database db = await initializeDB();

    final List<Map<String, dynamic>> resultado =
        await db.query(
      'remedios',
      orderBy: 'id DESC',
    );

    return resultado
        .map((map) => Remedio.fromMap(map))
        .toList();
  }
  
  //Deletar os remédios
  Future<void> deleteRemedio(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      'remedios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}