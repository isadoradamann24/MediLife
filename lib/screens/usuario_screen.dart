import 'package:flutter/material.dart';
import '../main.dart';

class CadastroUsuarioScreen extends StatelessWidget {
  CadastroUsuarioScreen({super.key});

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController nascimentoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 245),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(35),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                const Icon(
                  Icons.person_add_alt_1,
                  size: 90,
                  color: Color.fromARGB(255, 0, 100, 120),
                ),

                const SizedBox(height: 15),

                const Text(
                  "MedLife",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 90, 110),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Criar Conta",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                // Nome
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Nome Completo",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(
                    hintText: "Digite seu nome completo",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Data de nascimento
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Data de Nascimento",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: nascimentoController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintText: "dd/mm/aaaa",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Telefone
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Telefone",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "(47) 99999-9999",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Email
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Digite seu email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Senha
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Senha",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Digite sua senha",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirmar senha
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Confirmar Senha",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: confirmarSenhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirme sua senha",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    onPressed: () {

                      if (nomeController.text.isEmpty ||
                          nascimentoController.text.isEmpty ||
                          telefoneController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          senhaController.text.isEmpty ||
                          confirmarSenhaController.text.isEmpty) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Preencha todos os campos."),
                          ),
                        );
                        return;
                      }

                      if (senhaController.text !=
                          confirmarSenhaController.text) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("As senhas não coincidem."),
                          ),
                        );
                        return;
                      }

                      emailCadastrado = emailController.text;
                      senhaCadastrada = senhaController.text;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Usuário cadastrado com sucesso!"),
                        ),
                      );

                      Navigator.pushReplacementNamed(context, '/login');
                    },

                    child: const Text(
                      "Cadastrar",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text(
                    "Já possui uma conta? Entrar",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 100, 120),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}