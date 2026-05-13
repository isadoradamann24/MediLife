import 'package:flutter/material.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {

  TextEditingController emailController =
      TextEditingController();

  TextEditingController senhaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Padding(

          padding: EdgeInsets.all(30),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Icon(
                Icons.medication,
                size: 120,
                color: Colors.purple,
              ),

              SizedBox(height: 20),

              Text(

                'MedLife',

                style: TextStyle(

                  fontSize: 35,

                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 40),

              TextField(

                controller: emailController,

                decoration: InputDecoration(

                  labelText: 'E-mail',
                ),
              ),

              SizedBox(height: 20),

              TextField(

                controller: senhaController,

                obscureText: true,

                decoration: InputDecoration(

                  labelText: 'Senha',
                ),
              ),

              SizedBox(height: 30),

              ElevatedButton(

                onPressed: () {

                  if (emailController.text ==
                          emailCadastrado &&
                      senhaController.text ==
                          senhaCadastrada) {

                    Navigator.pushNamed(
                      context,
                      '/',
                    );
                  }

                  else {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      SnackBar(

                        content: Text(
                          'Cadastro não encontrado',
                        ),
                      ),
                    );
                  }
                },

                child: Text('Entrar'),
              ),

              SizedBox(height: 15),

              TextButton(

                onPressed: () {

                  Navigator.pushNamed(
                    context,
                    '/register',
                  );
                },

                child: Text('Criar Conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}