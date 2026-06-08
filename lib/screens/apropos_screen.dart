import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AProposScreen extends StatelessWidget {
  const AProposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        foregroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        title: const Text(
          'À propos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E),
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back, color: Color(0xFF1C1C1E)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Logo Goutte d'eau
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF2BB5A0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  CupertinoIcons.drop_fill,
                  color: Color(0xFF2BB5A0),
                  size: 44,
                ),
              ),
              const SizedBox(height: 32),
              // Titre principal
              const Text(
                'ASUFOR',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Gestion des bornes-fontaines',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(height: 40),
              // Informations auteur
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Étudiant
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Étudiant',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8E8E93),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Cheikh Mouhamadou Habib Fall',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1C1E),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      color: const Color(0xFFF2F2F7),
                    ),
                    const SizedBox(height: 16),
                    // École
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'École',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8E8E93),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'ESMT Dakar — Licence 3',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1C1E),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      color: const Color(0xFFF2F2F7),
                    ),
                    const SizedBox(height: 16),
                    // Module
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Module',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8E8E93),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Développement Multiplateforme',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1C1E),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Source des données
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2BB5A0).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2BB5A0).withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Source des données',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tarif eau zone rurale Sénégal : 350 FCFA/m³',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C1C1E),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Source : PEPAM/ONAS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Collecté le 07 juin 2026',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Objectif de développement durable
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2BB5A0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: Color(0xFF2BB5A0),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ODD 6',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Eau propre et assainissement',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
