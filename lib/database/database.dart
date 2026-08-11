import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "medlife.db";
  static const _databaseVersion = 1;

  static const tableRemedios = "remedios";

  static const columnId = "id";
  static const columnNome = "nome";
  static const columnQuantidade = "quantidade";
  static const columnHorario = "horario";
  static const columnMotivo = "motivo";
  static const columnDias = "dias";
  static const columnTomou = "tomou";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = join(
      directory.path,
      _databaseName,
    );

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE $tableRemedios (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNome TEXT NOT NULL,
        $columnQuantidade INTEGER NOT NULL,
        $columnHorario TEXT NOT NULL,
        $columnMotivo TEXT,
        $columnDias TEXT NOT NULL,
        $columnTomou INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // INSERIR REMÉDIO
  Future<int> inserirRemedio(
    Map<String, dynamic> remedio,
  ) async {
    final db = await database;

    return await db.insert(
      tableRemedios,
      remedio,
    );
  }

  // BUSCAR TODOS OS REMÉDIOS
  Future<List<Map<String, dynamic>>> buscarRemedios() async {
    final db = await database;

    return await db.query(
      tableRemedios,
      orderBy: "$columnId DESC",
    );
  }

  // BUSCAR UM REMÉDIO PELO ID
  Future<Map<String, dynamic>?> buscarRemedioPorId(
    int id,
  ) async {
    final db = await database;

    final resultado = await db.query(
      tableRemedios,
      where: "$columnId = ?",
      whereArgs: [id],
    );

    if (resultado.isNotEmpty) {
      return resultado.first;
    }

    return null;
  }

  // ATUALIZAR REMÉDIO
  Future<int> atualizarRemedio(
    int id,
    Map<String, dynamic> remedio,
  ) async {
    final db = await database;

    return await db.update(
      tableRemedios,
      remedio,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }

  // EXCLUIR REMÉDIO
  Future<int> excluirRemedio(
    int id,
  ) async {
    final db = await database;

    return await db.delete(
      tableRemedios,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }
}