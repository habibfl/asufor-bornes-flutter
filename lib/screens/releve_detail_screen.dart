import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/releve.dart';
import '../main.dart';

class RelevelDetailScreen extends StatefulWidget {
  const RelevelDetailScreen({super.key});

  @override
  State<RelevelDetailScreen> createState() => _RelevelDetailScreenState();
}

class _RelevelDetailScreenState extends State<RelevelDetailScreen> {
  late String _nomBorne;
  late List<Releve> _releves;
  late double _tarifM3;
  bool _init = false;

  static const List<String> _mois = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];

  String _date(DateTime d) => '${d.day.toString().padLeft(2, '0')} ${_mois[d.month - 1]} ${d.year}';

  double get _totalM3 => _releves.fold(0.0, (s, r) => s + r.consommation());
  double get _totalFCFA => _releves.fold(0.0, (s, r) => s + r.montantAPayer(_tarifM3));

  void _supprimer(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Supprimer le relevé', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: const Text('Cette action est irréversible.', style: TextStyle(color: kSublabel)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler', style: TextStyle(color: kSublabel))),
          TextButton(
            onPressed: () {
              setState(() => _releves.removeAt(index));
              Navigator.pop(ctx);
            },
            child: const Text('Supprimer', style: TextStyle(color: kDanger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_init) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      _nomBorne = args['nomBorne'];
      _releves = args['releves'];
      _tarifM3 = args['tarifM3'];
      _init = true;
    }

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: kLabel),
        title: Text(_nomBorne, style: const TextStyle(color: kLabel, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
        centerTitle: false,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x3D2BB5A0), blurRadius: 16, offset: Offset(0, 6))],
        ),
        child: FloatingActionButton(
          backgroundColor: kTeal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onPressed: () async {
            await Navigator.pushNamed(context, '/formulaire',
                arguments: {'nomBorne': _nomBorne, 'releves': _releves, 'tarifM3': _tarifM3});
            setState(() {});
          },
          child: const Icon(Icons.add, color: Colors.white, size: 26),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  _MiniStat(label: 'Volume total', value: '${_totalM3.toStringAsFixed(1)} m³'),
                  const SizedBox(width: 10),
                  _MiniStat(label: 'Total FCFA', value: '${_totalFCFA.toStringAsFixed(0)} F', accent: true),
                  const SizedBox(width: 10),
                  _MiniStat(label: 'Relevés', value: '${_releves.length}'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: _releves.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Text('Aucun relevé', style: TextStyle(color: kSublabel, fontSize: 16)),
                      ),
                    ),
                  )
                : SliverList.separated(
                    itemCount: _releves.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _ReleveCard(releve: _releves[i], tarifM3: _tarifM3, formatDate: _date, onDelete: () => _supprimer(i)),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool accent;

  const _MiniStat({required this.label, required this.value, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: kSublabel, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: accent ? kTeal : kLabel, letterSpacing: -0.2),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ReleveCard extends StatelessWidget {
  final Releve releve;
  final double tarifM3;
  final String Function(DateTime) formatDate;
  final VoidCallback onDelete;

  const _ReleveCard({required this.releve, required this.tarifM3, required this.formatDate, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatDate(releve.date), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kLabel, letterSpacing: -0.3)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: releve.paye ? const Color(0xFFE8F7F5) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  releve.paye ? 'PAYÉ' : 'IMPAYÉ',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: releve.paye ? kTeal : kOrange, letterSpacing: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: kBackground, thickness: 1.5, height: 0),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(CupertinoIcons.speedometer, size: 16, color: kSublabel),
              const SizedBox(width: 6),
              const Text('Index : ', style: TextStyle(fontSize: 14, color: kSublabel, fontWeight: FontWeight.w500)),
              Text('${releve.indexPrecedent} → ${releve.indexCourant}',
                  style: const TextStyle(fontSize: 14, color: kLabel, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(CupertinoIcons.drop, size: 16, color: kTeal),
              const SizedBox(width: 6),
              Text('${releve.consommation().toStringAsFixed(1)} m³',
                  style: const TextStyle(fontSize: 14, color: kLabel, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('${releve.montantAPayer(tarifM3).toStringAsFixed(0)} FCFA',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: kLabel, letterSpacing: -0.3)),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 32,
              onPressed: onDelete,
              child: const Icon(CupertinoIcons.trash, color: kDanger, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}