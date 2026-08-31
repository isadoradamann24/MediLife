import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database.dart';
import '../models/remedio.dart';
import 'cadastro_screen.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({super.key});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  final DatabaseHandler banco = DatabaseHandler();

  List<Remedio> remedios = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarRemedios();
  }

  // Busca os remédios salvos no banco
  Future<void> carregarRemedios() async {
    try {
      final lista = await banco.retrieveRemedios();

      if (!mounted) return;

      setState(() {
        remedios = lista;
        carregando = false;
      });

      // Mantém a flag possuiRemedio sincronizada com o banco
      await _atualizarPossuiRemedio(lista.isNotEmpty);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar os remédios: $e'),
        ),
      );
    }
  }

  // Atualiza a flag usada pelo Drawer para exibir/ocultar "Meus Remédios"
  Future<void> _atualizarPossuiRemedio(bool possui) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('possuiRemedio', possui);
  }

  // Exclui um remédio
  Future<void> excluir(int id) async {
    try {
      await banco.deleteRemedio(id);

      await carregarRemedios();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Remédio excluído com sucesso!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir o remédio: $e'),
        ),
      );
    }
  }

  // Confirmação antes de excluir
  Future<void> confirmarExclusao(Remedio remedio) async {
    if (remedio.id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir remédio'),

          content: Text(
            'Deseja realmente excluir o remédio "${remedio.nome}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await excluir(remedio.id!);
    }
  }

  //Editar medicamento
  Future<void> editarMedicamento(Remedio remedio) async {
    final atualizou = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroScreen(remedioEditar: remedio),
      ),
    );

    if (atualizou == true) {
      await carregarRemedios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 245),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 90, 110),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Início',
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          },
        ),

        title: const Text(
          'Meus Remédios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: carregarRemedios,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : remedios.isEmpty
              ? _semRemedios()
              : RefreshIndicator(
                  onRefresh: carregarRemedios,

                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),

                    itemCount: remedios.length,

                    itemBuilder: (context, index) {
                      final remedio = remedios[index];

                      return _cardRemedio(remedio);
                    },
                  ),
                ),
    );
  }

  // Card de cada remédio
  Widget _cardRemedio(Remedio remedio) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),

      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Nome
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Icon(
                  Icons.medication,
                  size: 30,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    remedio.nome,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Informações em tabela, geradas a partir do model Remedio
            _tabelaInformacoes(remedio),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 4),

            // Botões
            Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                IconButton(
                  onPressed: () {
                    editarMedicamento(remedio);
                  },

                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),

                  tooltip: 'Editar',
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: () {
                    confirmarExclusao(remedio);
                  },

                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),

                  tooltip: 'Excluir',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Tabela com as informações dos remédios
  Widget _tabelaInformacoes(Remedio remedio) {
    final List<_LinhaInfo> linhas = [
      _LinhaInfo( 
        icone: Icons.numbers,
        titulo: 'Quantidade',
        valor: '${remedio.quantidade}',
      ),
      _LinhaInfo(
        icone: Icons.access_time,
        titulo: 'Horário',
        valor: remedio.horario,
      ),
      _LinhaInfo(
        icone: Icons.note,
        titulo: 'Motivo',
        valor: remedio.motivo.isEmpty ? 'Não informado' : remedio.motivo,
      ),
      _LinhaInfo(
        icone: Icons.calendar_month,
        titulo: 'Dias',
        valor: remedio.dias,
      ),
    ];

    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,

      children: linhas.map((linha) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(linha.icone, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${linha.titulo}:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(linha.valor),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Quando não existem remédios
  Widget _semRemedios() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              Icons.medication_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              'Nenhum remédio cadastrado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Cadastre um remédio para que ele apareça aqui.',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Voltar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinhaInfo {
  final IconData icone;
  final String titulo;
  final String valor;

  _LinhaInfo({
    required this.icone,
    required this.titulo,
    required this.valor,
  });
}