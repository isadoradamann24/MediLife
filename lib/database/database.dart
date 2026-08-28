import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/remedio.dart';


class DatabaseHandler {


  Future<Database> initializeDB() async {


    String path =
        await getDatabasesPath();



    return openDatabase(

      join(
        path,
        'medlife.db',
      ),



      onCreate:
      (database, version) async {



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







  // INSERIR UM ÚNICO REMÉDIO

  Future<int> insertRemedio(
      Remedio remedio
      ) async {


    final Database db =
        await initializeDB();



    return await db.insert(

      'remedios',

      remedio.toMap(),

    );


  }









  Future<List<Remedio>> retrieveRemedios() async {


    final Database db =
        await initializeDB();




    final List<Map<String,Object?>> resultado =
        await db.query(

          'remedios',

          orderBy:
          'id DESC',

        );




    return resultado
        .map(

          (map)=>
              Remedio.fromMap(map),

    )
        .toList();


  }









  Future<Remedio?> retrieveRemedioById(
      int id
      ) async {


    final Database db =
        await initializeDB();




    final resultado =
        await db.query(

          'remedios',

          where:
          'id = ?',


          whereArgs:
          [
            id
          ],


        );




    if(resultado.isNotEmpty){


      return Remedio.fromMap(
          resultado.first
      );


    }



    return null;


  }









  Future<int> updateRemedio(

      int id,

      Map<String,Object?> remedio,

      ) async {


    final Database db =
        await initializeDB();




    return await db.update(

      'remedios',

      remedio,


      where:
      'id = ?',


      whereArgs:
      [
        id
      ],


    );


  }









  Future<void> deleteRemedio(
      int id
      ) async {


    final Database db =
        await initializeDB();




    await db.delete(

      'remedios',


      where:
      'id = ?',


      whereArgs:
      [
        id
      ],

    );


  }



}