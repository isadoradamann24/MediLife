import 'package:flutter/material.dart';

import '../main.dart';

class RegistroScreen extends StatelessWidget {

  RegistroScreen({super.key});

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Color.fromARGB(255, 235, 245, 245),

      body: Center(child: Container(

          width: 420,
          padding: EdgeInsets.all(35),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
              ),
            ],
          ),

          child: Column(mainAxisSize: MainAxisSize.min,

            children: [Icon(Icons.medication,

                size: 100,
                color:Color.fromARGB(255, 0, 100, 120),
              ),

              SizedBox(height: 15),

              Text('Criar Conta',

                style: TextStyle(
                  fontSize: 34,
                  fontWeight:FontWeight.bold,
                  color:Color.fromARGB(255, 0, 90, 110),
                ),
              ),

              SizedBox(height: 35),
//input
              TextField(controller: nomeController,

                decoration: InputDecoration(

                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(15),
                  ),

                  hintText:'Digite seu nome',
                ),
              ),

              SizedBox(height: 20),
//navegação
              TextField(controller : emailController,

                decoration: InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(15),
                  ),

                  hintText:'Digite seu email',
                ),
              ),

              SizedBox(height: 20),
//navegação
              TextField(controller:senhaController,

                obscureText: true,

                decoration: InputDecoration(

                  border:OutlineInputBorder(

                    borderRadius:BorderRadius.circular(15),
                  ),

                  hintText:'Digite sua senha',
                ),
              ),

              SizedBox(height: 30),

              SizedBox(

                width: double.infinity,
//input
                child: ElevatedButton(

                  style:ElevatedButton.styleFrom(

                    backgroundColor:Colors.black,
                    padding:EdgeInsets.all(16),
                    shape:RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(15),
                    ),
                  ),

//navegação
                  onPressed: () {

                    emailCadastrado = emailController.text;

                    senhaCadastrada = senhaController.text;

                    Navigator.pushNamed(context,'/login');
                  },

                  child: Text('Cadastrar',

                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}