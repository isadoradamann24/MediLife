import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BuscarRemedio extends StatefulWidget {
  const BuscarRemedio({super.key});

  @override
  State<BuscarRemedio> createState() => _BuscarRemedio();
}

class _BuscarRemedio extends State<BuscarRemedio> {
  final TextEditingController nomeController = TextEditingController();

  bool carregando = false;
  String? erro;

  // Dados do resultado
  String? principioAtivo;
  String? indicacoes;
  String? setId;

  final Color corPrincipal = const Color.fromARGB(255, 0, 90, 110);

  // Nomes comuns no Brasil -> nome usado na base da FDA (amplie à vontade)
  static const Map<String, String> _traducaoNomes = {
    'paracetamol': 'acetaminophen',
    'dipirona': 'metamizole',
    'ibuprofeno': 'ibuprofen',
    'amoxicilina': 'amoxicillin',
    'omeprazol': 'omeprazole',
    'losartana': 'losartan',
    'dexametasona': 'dexamethasone',
    'azitromicina': 'azithromycin',
    'cetirizina': 'cetirizine',
    'loratadina': 'loratadine',
    'metformina': 'metformin',
    'sinvastatina': 'simvastatin',
    'diclofenaco': 'diclofenac',
    'aas': 'aspirin',
  };

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  /// Consulta a openFDA e devolve o primeiro resultado (ou null).
  Future<Map<String, dynamic>?> _consultar(String search) async {
    final uri = Uri.https('api.fda.gov', '/drug/label.json', {
      'search': search,
      'limit': '1',
    });

    final resposta = await http.get(uri).timeout(const Duration(seconds: 15));
    if (resposta.statusCode != 200) return null; // 404 = sem resultados

    final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
    final results = dados['results'] as List?;
    if (results == null || results.isEmpty) return null;

    return results.first as Map<String, dynamic>;
  }

  // ---------- Helpers de leitura do JSON ----------

  String? _primeiro(dynamic v) {
    if (v is List && v.isNotEmpty) return v.first.toString();
    if (v is String && v.isNotEmpty) return v;
    return null;
  }

  String _capitalizar(String t) {
    final s = t.toLowerCase();
    return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
  }

  String _resumir(String texto, {int max = 700}) {
    final limpo = texto.replaceAll(RegExp(r'\s+'), ' ').trim();
    return limpo.length <= max ? limpo : '${limpo.substring(0, max)}...';
  }

  // ---------- Busca ----------

  Future<void> buscarRemedio() async {
    final nome = nomeController.text.trim();
    if (nome.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() {
      carregando = true;
      erro = null;
      principioAtivo = null;
      indicacoes = null;
      setId = null;
    });

    final termo = (_traducaoNomes[nome.toLowerCase()] ?? nome).toUpperCase();

    try {
      // 1ª tentativa: correspondência exata; 2ª: busca mais flexível
      final item = await _consultar(
            'openfda.generic_name.exact:"$termo" OR openfda.brand_name.exact:"$termo"',
          ) ??
          await _consultar(
            'openfda.generic_name:"$termo" OR openfda.brand_name:"$termo"',
          );

      if (!mounted) return;

      if (item == null) {
        setState(() => erro = 'Nenhum resultado para "$nome".');
        return;
      }

      final generico = _primeiro(item['openfda']?['generic_name']);
      final indicacao = _primeiro(item['indications_and_usage']);
      final id = _primeiro(item['set_id']) ??
          _primeiro(item['openfda']?['spl_set_id']);

      setState(() {
        principioAtivo = generico != null ? _capitalizar(generico) : null;
        indicacoes = indicacao != null ? _resumir(indicacao) : null;
        setId = id;
        if (principioAtivo == null && indicacoes == null && setId == null) {
          erro = 'Resultado sem informações para "$nome".';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => erro = 'Falha de conexão. Tente novamente.');
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  // ---------- Bula (DailyMed) ----------

  Future<void> _abrirBula() async {
    if (setId == null) return;

    final uri = Uri.https(
      'dailymed.nlm.nih.gov',
      '/dailymed/lookup.cfm',
      {'setid': setId!},
    );

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir a bula.')),
      );
    }
  }

  // ---------- Widgets ----------

  Widget _buildResultado() {
    if (carregando) return const Center(child: CircularProgressIndicator());

    if (erro != null) {
      return Column(
        children: [
          const Icon(Icons.error_outline, size: 45, color: Colors.redAccent),
          const SizedBox(height: 10),
          Text(erro!, textAlign: TextAlign.center),
        ],
      );
    }

    if (principioAtivo == null && indicacoes == null && setId == null) {
      return Text(
        'O resultado aparecerá aqui após a pesquisa.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (principioAtivo != null) ...[
          Text(
            'Princípio ativo',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 2),
          Text(
            principioAtivo!,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ],
        if (indicacoes != null) ...[
          Text(
            'Indicações',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: corPrincipal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            indicacoes!,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 4),
          Text(
            'Texto original em inglês (FDA).',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (setId != null)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: corPrincipal,
                side: BorderSide(color: corPrincipal),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _abrirBula,
              icon: const Icon(Icons.description_outlined),
              label: const Text('Ver bula completa'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 245),
      appBar: AppBar(
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
        title: const Text('Buscar Remédios'),
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
                Icon(Icons.search, size: 80, color: corPrincipal),
                const SizedBox(height: 10),
                const Text(
                  'Buscar Medicamento',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: nomeController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => buscarRemedio(),
                  decoration: InputDecoration(
                    hintText: 'Ex: Paracetamol',
                    prefixIcon: Icon(Icons.medication, color: corPrincipal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: corPrincipal, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 250, 250),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.teal.shade100),
                  ),
                  child: _buildResultado(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corPrincipal,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: carregando ? null : buscarRemedio,
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: const Text(
                      'BUSCAR',
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