import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/releve.dart';
import '../main.dart';

class ReleveFormScreen extends StatefulWidget {
  const ReleveFormScreen({super.key});

  @override
  State<ReleveFormScreen> createState() => _ReleveFormScreenState();
}

class _ReleveFormScreenState extends State<ReleveFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _indexCourantCtrl = TextEditingController();
  final _indexPrecedentCtrl = TextEditingController();

  late String _nomBorne;
  late List<Releve> _releves;
  late double _tarifM3;
  bool _init = false;
  bool _paye = false;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _indexCourantCtrl.dispose();
    _indexPrecedentCtrl.dispose();
    super.dispose();
  }

  void _choisirDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: kTeal),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _enregistrer() {
    if (!_formKey.currentState!.validate()) return;

    final courant = double.parse(_indexCourantCtrl.text.trim());
    final precedent = double.parse(_indexPrecedentCtrl.text.trim());

    _releves.add(Releve(
      borne: _nomBorne,
      indexCourant: courant,
      indexPrecedent: precedent,
      date: _date,
      paye: _paye,
    ));

    Navigator.pop(context);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

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
        title: const Text('Nouveau relevé',
            style: TextStyle(color: kLabel, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Borne non modifiable
            _SectionLabel('Borne'),
            _InfoTile(_nomBorne),
            const SizedBox(height: 20),

            // Index courant
            _SectionLabel('Index courant (m³)'),
            _ChampTexte(
              controller: _indexCourantCtrl,
              hint: 'ex: 1326.0',
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Champ obligatoire';
                if (double.tryParse(v.trim()) == null) return 'Nombre invalide';
                final prec = double.tryParse(_indexPrecedentCtrl.text.trim());
                if (prec != null && double.parse(v.trim()) <= prec) return 'Doit être supérieur à l\'index précédent';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Index précédent
            _SectionLabel('Index précédent (m³)'),
            _ChampTexte(
              controller: _indexPrecedentCtrl,
              hint: 'ex: 1280.0',
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Champ obligatoire';
                if (double.tryParse(v.trim()) == null) return 'Nombre invalide';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date
            _SectionLabel('Date du relevé'),
            GestureDetector(
              onTap: _choisirDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.calendar, color: kTeal, size: 20),
                    const SizedBox(width: 10),
                    Text(_formatDate(_date), style: const TextStyle(fontSize: 15, color: kLabel, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    const Icon(CupertinoIcons.chevron_right, size: 14, color: kSublabel),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Statut payé
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.checkmark_seal, color: kTeal, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('Payé', style: TextStyle(fontSize: 15, color: kLabel, fontWeight: FontWeight.w500))),
                  Switch.adaptive(
                    value: _paye,
                    activeColor: kTeal,
                    onChanged: (v) => setState(() => _paye = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Bouton enregistrer
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _enregistrer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Enregistrer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kSublabel, letterSpacing: 0.2)),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String text;
  const _InfoTile(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 15, color: kTeal, fontWeight: FontWeight.w600)),
    );
  }
}

class _ChampTexte extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;

  const _ChampTexte({required this.controller, required this.hint, required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      style: const TextStyle(fontSize: 15, color: kLabel, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kSublabel, fontSize: 15),
        filled: true,
        fillColor: kCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kTeal, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kDanger)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kDanger)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}