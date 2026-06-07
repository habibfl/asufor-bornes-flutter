import 'package:flutter/material.dart';
import '../models/releve.dart';

class BorneListScreen extends StatefulWidget {
  const BorneListScreen({super.key});

  @override
  State<BorneListScreen> createState() => _BorneListScreenState();
}

class _BorneListScreenState extends State<BorneListScreen> {
  static const double tarifM3 = 350.0;

  final Map<String, List<Releve>> bornes = {
    'Borne Centrale': [
      Releve(borne: 'Borne Centrale', indexCourant: 1280, indexPrecedent: 1242, date: DateTime(2026, 5, 8), paye: true),
      Releve(borne: 'Borne Centrale', indexCourant: 1326, indexPrecedent: 1280, date: DateTime(2026, 6, 1), paye: false),
    ],
    'Borne Quartier Nord': [
      Releve(borne: 'Borne Quartier Nord', indexCourant: 895, indexPrecedent: 850, date: DateTime(2026, 5, 18), paye: true),
    ],
    'Borne Marché': [
      Releve(borne: 'Borne Marché', indexCourant: 2140, indexPrecedent: 2075, date: DateTime(2026, 5, 25), paye: false),
      Releve(borne: 'Borne Marché', indexCourant: 2198, indexPrecedent: 2140, date: DateTime(2026, 6, 3), paye: false),
    ],
  };

  double totalConsommation(String nomBorne) {
    return bornes[nomBorne]!.fold(0.0, (sum, r) => sum + r.consommation());
  }

  double totalAPayer(String nomBorne) {
    return bornes[nomBorne]!.fold(0.0, (sum, r) => sum + r.montantAPayer(tarifM3));
  }

  int nonPayes(String nomBorne) {
    return bornes[nomBorne]!.where((r) => !r.paye).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BB5A0),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ASUFOR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Gestion des bornes-fontaines', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/apropos'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Bannière stats
          Container(
            color: const Color(0xFF2BB5A0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Row(
              children: [
                _StatCard(
                  label: 'Bornes actives',
                  valeur: '${bornes.length}',
                  icone: Icons.water_drop,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Total relevés',
                  valeur: '${bornes.values.fold(0, (s, l) => s + l.length)}',
                  icone: Icons.receipt_long,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Non payés',
                  valeur: '${bornes.keys.fold(0, (s, k) => s + nonPayes(k))}',
                  icone: Icons.warning_amber,
                  rouge: true,
                ),
              ],
            ),
          ),

          // Titre
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Liste des bornes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
              ),
            ),
          ),

          // Liste
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: bornes.keys.length,
              itemBuilder: (context, index) {
                final nomBorne = bornes.keys.elementAt(index);
                final releves = bornes[nomBorne]!;
                final nbNonPaye = nonPayes(nomBorne);

                return GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: {
                        'nomBorne': nomBorne,
                        'releves': releves,
                        'tarifM3': tarifM3,
                      },
                    );
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                          color: nbNonPaye > 0 ? Colors.orange : const Color(0xFF2BB5A0),
                          width: 4,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2BB5A0).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.water_drop, color: Color(0xFF2BB5A0), size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nomBorne,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${releves.length} relevé(s) · ${totalConsommation(nomBorne).toStringAsFixed(1)} m³',
                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          if (nbNonPaye > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$nbNonPaye impayé(s)',
                                style: TextStyle(fontSize: 12, color: Colors.orange.shade800, fontWeight: FontWeight.w600),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'À jour',
                                style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w600),
                              ),
                            ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget réutilisable StatelessWidget
class _StatCard extends StatelessWidget {
  final String label;
  final String valeur;
  final IconData icone;
  final bool rouge;

  const _StatCard({
    required this.label,
    required this.valeur,
    required this.icone,
    this.rouge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, color: rouge ? Colors.orange.shade200 : Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              valeur,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}