import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medshift/Controller/api_medicamentos_controller.dart';

class ApiMedicamentosSelectView extends StatelessWidget {
  const ApiMedicamentosSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Provider.of<ApiMedicamentosController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Medicamento (ANVISA)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: c.buscaController,
              decoration: const InputDecoration(
                labelText: 'Digite o nome do medicamento',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => c.buscar(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: c.buscar,
              child: const Text('Pesquisar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: c.carregando
                  ? const Center(child: CircularProgressIndicator())
                  : c.resultados.isEmpty
                      ? const Center(child: Text('Nenhum resultado'))
                      : ListView.builder(
                          itemCount: c.resultados.length,
                          itemBuilder: (context, index) {
                            final item = c.resultados[index] as Map<String, dynamic>;
                            final nome = item['nomeProduto'] ?? item['descricao'] ?? 'Sem nome';
                            final principio = item['principioAtivo'] ?? 'Não informado';

                            return Card(
                              child: ListTile(
                                title: Text(nome),
                                subtitle: Text('Princípio ativo: $principio'),
                                onTap: () {
                                  // Retorna o nome do medicamento selecionado
                                  Navigator.pop(context, nome);
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
