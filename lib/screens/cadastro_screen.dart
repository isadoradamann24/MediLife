import 'package:flutter/material.dart';

import '../models/remedio.dart';
import '../database/database.dart';
import 'detalhes_screen.dart';

class CadastroScreen extends StatefulWidget {
  // Se vier preenchido, a tela abre em modo de edição
  final Remedio? remedioEditar;

  const CadastroScreen({super.key, this.remedioEditar});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  // Controllers dos campos
  final TextEditingController nomeController = TextEditingController();

  final TextEditingController quantidadeController = TextEditingController();

  final TextEditingController horarioController = TextEditingController();

  final TextEditingController motivoController = TextEditingController();

  // Dias da semana
  final List<String> diasSemana = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo',
  ];

  // Abreviações dos dias
  final Map<String, String> abreviacoesDias = {
    'Segunda': 'SEG',
    'Terça': 'TER',
    'Quarta': 'QUA',
    'Quinta': 'QUI',
    'Sexta': 'SEX',
    'Sábado': 'SÁB',
    'Domingo': 'DOM',
  };

  // Dias selecionados
  final Set<String> diasSelecionados = {};

  // Controle do botão
  bool salvando = false;

  bool get editando => widget.remedioEditar != null;

  // Animação das frases
  int fraseAtual = 0;

  final List<String> frases = [
    "💙 Cuidar da saúde é cuidar da vida.",
    "💊 Não esqueça seu medicamento de hoje.",
    "😊 Pequenos cuidados fazem grande diferença.",
    "❤️ Sua saúde merece atenção todos os dias.",
  ];

  @override
  void initState() {
    super.initState();

    // Se estiver editando, pré-preenche os campos
    if (editando) {
      final r = widget.remedioEditar!;

      nomeController.text = r.nome;
      quantidadeController.text = r.quantidade.toString();
      horarioController.text = r.horario;
      motivoController.text = r.motivo;

      diasSelecionados.addAll(
        r.dias.split(',').map((d) => d.trim()).where((d) => d.isNotEmpty),
      );
    }

    // Animação da frase
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) return false;

      setState(() {
        fraseAtual = (fraseAtual + 1) % frases.length;
      });

      return true;
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    horarioController.dispose();
    motivoController.dispose();

    super.dispose();
  }

  Future<void> selecionarHorario() async {
    final TimeOfDay? horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horario != null) {
      setState(() {
        horarioController.text = horario.format(context);
      });
    }
  }

  Future<void> salvarRemedio() async {
    if (salvando) return;

    setState(() {
      salvando = true;
    });

    try {
      // Cria o objeto Remedio
      final Remedio remedio = Remedio(
        id: widget.remedioEditar?.id,

        nome: nomeController.text,

        quantidade: int.tryParse(quantidadeController.text) ?? 0,

        horario: horarioController.text,

        motivo: motivoController.text,

        dias: diasSelecionados.join(', '),
      );

      final DatabaseHandler banco = DatabaseHandler();

      if (editando) {
        await banco.updateRemedio(remedio);
      } else {
        await banco.insertRemedio(remedio);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editando
                ? 'Remédio atualizado com sucesso!'
                : 'Remédio salvo com sucesso!',
          ),
        ),
      );

      if (editando) {
        Navigator.pop(context, true);
      } else {
        // Cadastro novo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DetalhesScreen()),
        );
      }
    } catch (e) {
      print('Erro ao salvar remédio: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  Widget campo(
    String titulo,
    IconData icone,
    TextEditingController controller, {
    String? hint,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),

        const SizedBox(height: 15),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 245),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 90, 110),
        title: Text(editando ? 'Editar Remédio' : 'MedLife'),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 50),

            const Icon(Icons.medication, size: 85, color: Colors.teal),

            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Início"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text("Estatísticas"),
              onTap: () {
                Navigator.pushNamed(context, '/estatisticas');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.medication),
              title: const Text("Meus Remédios"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/detalhes');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.calculate,
                color: Color.fromARGB(255, 41, 40, 40),
              ),
              title: const Text("Calculadora de Dosagem"),
              onTap: () {
                Navigator.pushNamed(context, '/calculadora');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Login"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 430,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  editando ? Icons.edit_note : Icons.medication,
                  size: 80,
                  color: Colors.teal,
                ),

                const SizedBox(height: 10),

                Text(
                  editando ? 'Editar Remédio' : 'MedLife',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Animação da frase
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),

                  child: Text(
                    frases[fraseAtual],
                    key: ValueKey(frases[fraseAtual]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.teal,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Nome
                campo(
                  'Nome do Remédio',
                  Icons.medication,
                  nomeController,
                  hint: 'Ex: Paracetamol',
                ),

                // Quantidade
                campo(
                  'Quantidade',
                  Icons.numbers,
                  quantidadeController,
                  hint: 'Ex: 1',
                  keyboardType: TextInputType.number,
                ),

                // Horário
                campo(
                  'Horário',
                  Icons.access_time,
                  horarioController,
                  hint: 'Toque para escolher',
                  readOnly: true,
                  onTap: selecionarHorario,
                ),

                // Motivo
                campo(
                  'Motivo',
                  Icons.note,
                  motivoController,
                  hint: 'Ex: Dor de cabeça',
                ),

                const SizedBox(height: 5),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dias da semana',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  children: diasSemana.map((dia) {
                    final selecionado = diasSelecionados.contains(dia);

                    final abreviacoes = {
                      'Segunda': 'SEG',
                      'Terça': 'TER',
                      'Quarta': 'QUA',
                      'Quinta': 'QUI',
                      'Sexta': 'SEX',
                      'Sábado': 'SÁB',
                      'Domingo': 'DOM',
                    };

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: selecionado,
                          activeColor: const Color.fromARGB(255, 0, 90, 110),

                          onChanged: (bool? valor) {
                            setState(() {
                              if (valor == true) {
                                diasSelecionados.add(dia);
                              } else {
                                diasSelecionados.remove(dia);
                              }
                            });
                          },
                        ),

                        Text(
                          abreviacoes[dia]!,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 90, 110),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: salvando ? null : salvarRemedio,

                    child: salvando
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            editando ? 'ATUALIZAR REMÉDIO' : 'SALVAR REMÉDIO',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 34, 35, 36),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pushNamed(context, '/estatisticas');
                    },

                    icon: const Icon(Icons.analytics, color: Colors.white),

                    label: const Text(
                      "Ver Estatísticas",
                      style: TextStyle(color: Colors.white, fontSize: 17),
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
