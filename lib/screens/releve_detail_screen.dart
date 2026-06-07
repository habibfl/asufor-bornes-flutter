import 'package:flutter/material.dart';

class RelevelDetailScreen extends StatefulWidget {
  const RelevelDetailScreen({super.key});

  @override
  State<RelevelDetailScreen> createState() => _RelevelDetailScreenState();
}

class _RelevelDetailScreenState extends State<RelevelDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: const Center(child: Text('Écran 2 - à construire')),
    );
  }
}