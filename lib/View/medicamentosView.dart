import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../AppState.dart';
import 'tela_compartilhadaView.dart';

class MedicamentosView extends StatefulWidget {
  const MedicamentosView({super.key});

  @override
  State<MedicamentosView> createState() => _MedicamentosViewState();
}

class _MedicamentosViewState extends State<MedicamentosView> {
  final _nomeCtl = TextEditingController();
  final _doseCtl = TextEditingController();
  final _horarioCtl = TextEditingController();
  final _obsCtl = TextEditingController();
  final int _idpaciente = -1; 

  @override
  void dispose() {
    _nomeCtl.dispose();
    _doseCtl.dispose();
    _horarioCtl.dispose();
    _obsCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);



    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos'),
        
        actions: [buildPopupMenu(context)], 
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                const Text('Adicionar medicamento', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(controller: _nomeCtl, decoration: const InputDecoration(labelText: 'Nome')),
                const SizedBox(height: 8),
                TextField(controller: _doseCtl, decoration: const InputDecoration(labelText: 'Dose')),
                const SizedBox(height: 8),
                TextField(controller: _horarioCtl, decoration: const InputDecoration(labelText: 'Horário')),
                const SizedBox(height: 8),
                TextField(controller: _obsCtl, decoration: const InputDecoration(labelText: 'Observação')),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_nomeCtl.text.trim().isEmpty) return;
                    
                    
                    state.addMedicamento(
                      _idpaciente, 
                      _nomeCtl.text.trim(), 
                      _doseCtl.text.trim(), 
                      _horarioCtl.text.trim(), 
                      _obsCtl.text.trim(),
                    );
                    
                    
                    _nomeCtl.clear(); 
                    _doseCtl.clear(); 
                    _horarioCtl.clear(); 
                    _obsCtl.clear();
                  },
                  child: const SizedBox(
                    width: double.infinity, 
                    child: Center(child: Text('Salvar medicamento'))
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedBuilder(
              animation: state,
              builder: (context, _) {
                final meds = state.medicamentos;
                if (meds.isEmpty) return const Center(child: Text('Nenhum medicamento cadastrado.'));
                
                return ListView.separated(
                  itemCount: meds.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final m = meds[i];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(m.nome),
                        subtitle: Text('${m.dose} • ${m.horario}\n${m.observacao}'),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}