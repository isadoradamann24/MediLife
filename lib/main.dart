import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/registro_screen.dart';
import 'screens/inicio_screen.dart';
import 'screens/detalhes_screen.dart';

String emailCadastrado = '';
String senhaCadastrada = '';

void main() {

  runApp(
    MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'MedLife',

      initialRoute: '/login',

//navegação
      routes: {

        '/login': (context) =>  LoginScreen(),

        '/registro': (context) => RegistroScreen(),

        '/': (context) => InicioScreen(),

        '/detalhes': (context) => DetalhesScreen(),
      },
    ),
  );
}