import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/registro_screen.dart';
import 'screens/inicio_screen.dart';
import 'screens/detalhes_screen.dart';
import 'screens/estatisticas_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/calculadora_screen.dart';


String emailCadastrado = '';
String senhaCadastrada = '';

void main() {
  runApp(const MedLifeApp());
}

class MedLifeApp extends StatelessWidget {
  const MedLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedLife',

      initialRoute: '/login',

      routes: {
        '/login': (context) => LoginScreen(),
        '/registro': (context) => RegistroScreen(),
        '/': (context) => InicioScreen(),
        '/detalhes': (context) => DetalhesScreen(),
        '/estatisticas': (context) => EstatisticasScreen(),
        '/cadastro': (context) => CadastroRemedioScreen(),
        '/calculadora': (context) => CalculadoraScreen(),


      },
    );
  }
}