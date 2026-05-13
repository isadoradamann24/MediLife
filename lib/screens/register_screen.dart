import 'package:flutter/material.dart';

import '../main.dart';

class RegisterScreen extends StatelessWidget {

  TextEditingController nomeController =
      TextEditingController();

  TextEditingController emailController =
      TextEditingController();

  TextEditingController senhaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Cadastro'),
      ),

      body: Padding(

        padding: EdgeInsets.all(30),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            TextField(

              controller: nomeController,

              decoration: InputDecoration(
                labelText: 'Nome',
              ),
            ),

            SizedBox(height: 20),

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

                emailCadastrado =
                    emailController.text;

                senhaCadastrada =
                    senhaController.text;

                Navigator.pushNamed(
                  context,
                  '/login',
                );
              },

              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}