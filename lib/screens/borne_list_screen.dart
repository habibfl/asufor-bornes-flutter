import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/releve.dart';
import '../main.dart';

class BorneListScreen extends StatefulWidget {
  const BorneListScreen({super.key});

  @override
  State<BorneListScreen> createState() => _BorneListScreenState();
}

class _BorneListScreenState extends State<BorneListScreen> {
  final Map<String, List<Releve>> _bornes = {
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

  int get _totalReleves => _bornes.values.fold(0, (s, l) => s + l.length);
  int get _totalNonPayes => _bornes.values.fold(0, (s, l) => s + l.where((r) => !r.paye).length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: kTeal,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            expandedHeight: 88,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ASUFOR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                Text('Gestion des bornes-fontaines', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            actions: [
              CupertinoButton(
                padding: const EdgeInsets.only(right: 12),
                onPressed: () => Navigator.pushNamed(context, '/apropos'),
                child: const Icon(CupertinoIcons.info_circle, color: Colors.white, size: 22),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: kTeal,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              child: Row(
                children: [
                  _StatBadge(icon: CupertinoIcons.drop_fill, label: 'Bornes', value: '${_bornes.length}'),
                  const SizedBox(width: 10),
                  _StatBadge(icon: CupertinoIcons.doc_text, label: 'Relevés', value: '$_totalReleves'),
                  const SizedBox(width: 10),
                  _StatBadge(icon: CupertinoIcons.exclamationmark_triangle, label: 'Impayés', value: '$_totalNonPayes', alert: true),
                ],
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 22, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text('Liste des bornes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kLabel, letterSpacing: -0.3)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: _bornes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final nom = _bornes.keys.elementAt(index);
                final releves = _bornes[nom]!;
                final nonPayes = releves.where((r) => !r.paye).length;
                final totalM3 = releves.fold(0.0, (s, r) => s + r.consommation());

                return _BorneCard(
                  nom: nom,
                  nombreReleves: releves.length,
                  totalM3: totalM3,
                  nonPayes: nonPayes,
                  onTap: () async {
                    await Navigator.pushNamed(context, '/detail',
                        arguments: {'nomBorne': nom, 'releves': releves, 'tarifM3': kTarifM3});
                    setState(() {});
                  },
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool alert;

  const _StatBadge({required this.icon, required this.label, required this.value, this.alert = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: alert ? const Color(0xFFFFCC80) : Colors.white, size: 20),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _BorneCard extends StatelessWidget {
  final String nom;
  final int nombreReleves;
  final double totalM3;
  final int nonPayes;
  final VoidCallback onTap;

  const _BorneCard({
    required this.nom,
    required this.nombreReleves,
    required this.totalM3,
    required this.nonPayes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final aJour = nonPayes == 0;

    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: aJour ? kTeal : kOrange, width: 4)),
            boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(CupertinoIcons.drop_fill, color: kTeal, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nom, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kLabel, letterSpacing: -0.2)),
                    const SizedBox(height: 4),
                    Text('$nombreReleves relevé(s) · ${totalM3.toStringAsFixed(1)} m³',
                        style: const TextStyle(fontSize: 13, color: kSublabel)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: aJour ? const Color(0xFFE8F7F5) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  aJour ? 'À jour' : '$nonPayes impayé(s)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: aJour ? kTeal : kOrange),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(CupertinoIcons.chevron_right, size: 14, color: kSublabel),
            ],
          ),
        ),
      ),
    );
  }
}