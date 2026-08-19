import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/remedio.dart';


class DatabaseHandler {


  // ----------------------------------------------------------
  // CRIAR / INICIALIZAR BANCO
  // ----------------------------------------------------------

  Future<Database> initializeDB() async {

    String path = await getDatabasesPath();


    return openDatabase(

      join(
        path,
        "medlife.db",
      ),


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
          '''

        );


      },


      version: 1,


    );


  }






  // ----------------------------------------------------------
  // INSERIR REMÉDIO
  // ----------------------------------------------------------

  Future<int> inserirRemedio(
      Remedio remedio
      ) async {


    int resultado = 0;



    final Database db =
        await initializeDB();




    resultado = await db.insert(

      "remedios",

      remedio.toMap(),

    );



    return resultado;


  }








  // ----------------------------------------------------------
  // BUSCAR TODOS OS REMÉDIOS
  // ----------------------------------------------------------

  Future<List<Remedio>> buscarRemedios() async {


    final Database db =
        await initializeDB();




    final List<Map<String, Object?>> resultado =

        await db.query(

          "remedios",

          orderBy: "id DESC",

        );




    return resultado

        .map(

          (e) => Remedio.fromMap(e),

        )

        .toList();


  }









  // ----------------------------------------------------------
  // BUSCAR UM REMÉDIO PELO ID
  // ----------------------------------------------------------

  Future<Remedio?> buscarRemedioPorId(
      int id
      ) async {


    final Database db =
        await initializeDB();




    final resultado = await db.query(

      "remedios",

      where: "id = ?",

      whereArgs: [

        id

      ],

    );




    if(resultado.isNotEmpty){


      return Remedio.fromMap(

        resultado.first,

      );


    }



    return null;


  }

  // ----------------------------------------------------------
  // ATUALIZAR REMÉDIO
  // ----------------------------------------------------------

  Future<int> atualizarRemedio(

      int id,

      Map<String, Object?> remedio,

      ) async {


    final Database db =
        await initializeDB();




    return await db.update(

      "remedios",

      remedio,

      where: "id = ?",


      whereArgs: [

        id

      ],


    );


  }
  // ----------------------------------------------------------
  // EXCLUIR REMÉDIO
  // ----------------------------------------------------------

  Future<void> excluirRemedio(

      int id

      ) async {



    final Database db =
        await initializeDB();




    await db.delete(

      "remedios",

      where: "id = ?",


      whereArgs: [

        id

      ],


    );


  }



}