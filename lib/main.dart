import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';

String emailCadastrado = '';
String senhaCadastrada = '';

void main() {

  runApp(

    MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'MedLife',

      initialRoute: '/login',

      routes: {

        '/login': (context) => LoginScreen(),

        '/register': (context) => RegisterScreen(),

        '/': (context) => HomeScreen(),

        '/details': (context) => DetailsScreen(),
      },
    ),
  );
}