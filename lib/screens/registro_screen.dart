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
      backgroundColor: const Color.fromARGB(255, 235, 245, 245),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.medication, size: 80),

              const SizedBox(height: 20),

              TextField(
                controller: nomeController,
                decoration: const InputDecoration(hintText: "Nome"),
              ),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Email"),
              ),

              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: const InputDecoration(hintText: "Senha"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  emailCadastrado = emailController.text;
                  senhaCadastrada = senhaController.text;

                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}