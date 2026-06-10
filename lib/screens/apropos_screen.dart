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
        title: const Text('À propos',
            style: TextStyle(color: kLabel, fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Logo
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(CupertinoIcons.drop_fill, color: kTeal, size: 38),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text('ASUFOR',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: kLabel, letterSpacing: -0.5)),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text('Gestion des bornes-fontaines',
                  style: TextStyle(fontSize: 14, color: kSublabel)),
            ),
            const SizedBox(height: 32),

            // Infos étudiant
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoLigne(label: 'Étudiant', value: 'Cheikh Mouhamadou Habib Fall'),
                  const SizedBox(height: 12),
                  const Divider(color: kBackground, thickness: 1.5, height: 0),
                  const SizedBox(height: 12),
                  _InfoLigne(label: 'École', value: 'ESMT Dakar — Licence 3'),
                  const SizedBox(height: 12),
                  const Divider(color: kBackground, thickness: 1.5, height: 0),
                  const SizedBox(height: 12),
                  _InfoLigne(label: 'Module', value: 'Développement Multiplateforme'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Source des données
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7F5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2BB5A0).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Source des données',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kLabel)),
                  SizedBox(height: 10),
                  Text('Tarif eau zone rurale Sénégal : 350 FCFA/m³',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kLabel)),
                  SizedBox(height: 4),
                  Text('Source : OFOR / Ministère de l\'Hydraulique',
                      style: TextStyle(fontSize: 13, color: kSublabel)),
                  SizedBox(height: 2),
                  Text('9,5% des ménages ruraux utilisent les bornes-fontaines — ANSD RGPH-5',
                      style: TextStyle(fontSize: 12, color: kSublabel)),
                  SizedBox(height: 2),
                  Text('Collecté le 07 juin 2026',
                      style: TextStyle(fontSize: 13, color: kSublabel)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ODD 6
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: const _InfoLigne(
                label: 'Objectif de développement durable',
                value: 'ODD 6 — Eau propre et assainissement',
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InfoLigne extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLigne({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: kSublabel, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 15, color: kLabel, fontWeight: FontWeight.w600, letterSpacing: -0.2)),
      ],
    );
  }
}