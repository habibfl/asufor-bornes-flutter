import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class AProposScreen extends StatelessWidget {
  const AProposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: kLabel),
        title: const Text('À propos', style: TextStyle(color: kLabel, fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7F5),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(CupertinoIcons.drop_fill, color: kTeal, size: 40),
            ),
            const SizedBox(height: 20),
            const Text('ASUFOR', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: kLabel, letterSpacing: -0.5)),
            const SizedBox(height: 6),
            const Text('Gestion des bornes-fontaines', style: TextStyle(fontSize: 15, color: kSublabel)),
            const SizedBox(height: 32),
            _InfoCard(items: const [
              _InfoRow(label: 'Étudiant', value: 'Cheikh Mouhamadou Habib Fall'),
              _InfoRow(label: 'École', value: 'ESMT Dakar — Licence 3'),
              _InfoRow(label: 'Module', value: 'Développement Multiplateforme'),
            ]),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7F5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2BB5A0).withOpacity(0.2)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Source des données', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kLabel)),
                  SizedBox(height: 10),
                  Text('Tarif eau zone rurale Sénégal : 350 FCFA/m³', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kLabel)),
                  SizedBox(height: 4),
                  Text('Source : PEPAM/ONAS', style: TextStyle(fontSize: 13, color: kSublabel)),
                  SizedBox(height: 2),
                  Text('Collecté le 07 juin 2026', style: TextStyle(fontSize: 13, color: kSublabel)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(color: const Color(0xFFE8F7F5), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(CupertinoIcons.checkmark_circle_fill, color: kTeal, size: 28),
                  ),
                  const SizedBox(height: 10),
                  const Text('ODD 6', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kLabel)),
                  const SizedBox(height: 4),
                  const Text('Eau propre et assainissement', style: TextStyle(fontSize: 12, color: kSublabel)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> items;
  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final last = e.key == items.length - 1;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e.value.label, style: const TextStyle(fontSize: 12, color: kSublabel, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(e.value.value, style: const TextStyle(fontSize: 15, color: kLabel, fontWeight: FontWeight.w600, letterSpacing: -0.2)),
              if (!last) ...[
                const SizedBox(height: 12),
                const Divider(color: kBackground, thickness: 1.5, height: 0),
                const SizedBox(height: 12),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
}