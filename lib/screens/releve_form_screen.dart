import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../theme/app_theme.dart';

class ReleveFormScreen extends StatefulWidget {
  const ReleveFormScreen({super.key});

  @override
  State<ReleveFormScreen> createState() => _ReleveFormScreenState();
}

class _ReleveFormScreenState extends State<ReleveFormScreen>
    with SingleTickerProviderStateMixin {
  late List<Releve> _releves;
  late String _nomBorne;
  late double _tarifM3;
  bool _initialized = false;

  final _indexPrecCtrl = TextEditingController();
  final _indexCourCtrl = TextEditingController();
  final _precFocus = FocusNode();
  final _courFocus = FocusNode();

  DateTime _selectedDate = DateTime.now();
  bool _estPaye = false;
  String? _errorMessage;

  late AnimationController _errorController;
  late Animation<double> _errorAnimation;

  @override
  void initState() {
    super.initState();
    _errorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _errorAnimation = CurvedAnimation(
      parent: _errorController,
      curve: Curves.easeOutCubic,
    );
    _precFocus.addListener(() => setState(() {}));
    _courFocus.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      _nomBorne = args?['nomBorne'] ?? 'Borne';
      _releves = args?['releves'] ?? [];
      _tarifM3 = (args?['tarifM3'] ?? 350.0).toDouble();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _indexPrecCtrl.dispose();
    _indexCourCtrl.dispose();
    _precFocus.dispose();
    _courFocus.dispose();
    _errorController.dispose();
    super.dispose();
  }

  void _showDatePicker() {
    FocusScope.of(context).unfocus();
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: AppColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 4,
              width: 36,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.separator,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(color: AppColors.danger),
                    ),
                  ),
                  const Text(
                    'Sélectionner une date',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.label,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Confirmer',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: _selectedDate,
                mode: CupertinoDatePickerMode.date,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (d) => setState(() => _selectedDate = d),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setError(String msg) {
    setState(() {
      _errorMessage = msg;
    });
    _errorController.forward(from: 0);
  }

  void _clearError() {
    setState(() {});
    _errorController.reverse();
  }

  void _validateAndSave() {
    FocusScope.of(context).unfocus();
    final precText = _indexPrecCtrl.text.trim();
    final courText = _indexCourCtrl.text.trim();

    if (precText.isEmpty || courText.isEmpty) {
      _setError('Veuillez remplir les deux champs d\'index');
      return;
    }

    final prec = double.tryParse(precText.replaceAll(',', '.'));
    final cour = double.tryParse(courText.replaceAll(',', '.'));

    if (prec == null || cour == null) {
      _setError('Les index doivent être des valeurs numériques');
      return;
    }

    if (cour <= prec) {
      _setError('L\'index courant doit être supérieur à l\'index précédent');
      return;
    }

    _clearError();

    final newReleve = Releve(
      id: 'R-${DateTime.now().millisecondsSinceEpoch}',
      borne: _nomBorne,
      indexCourant: cour,
      indexPrecedent: prec,
      date: _selectedDate,
      paye: _estPaye,
    );

    _releves.insert(0, newReleve);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.systemGrouped,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildErrorBanner(),
              _buildSection(
                label: 'BORNE',
                child: _buildBorneField(),
              ),
              const SizedBox(height: 16),
              _buildSection(
                label: 'INDEX (m³)',
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _indexPrecCtrl,
                      focusNode: _precFocus,
                      placeholder: 'Index précédent',
                      suffix: 'm³',
                      icon: CupertinoIcons.arrow_down_circle,
                    ),
                    _buildInternalDivider(),
                    _buildTextField(
                      controller: _indexCourCtrl,
                      focusNode: _courFocus,
                      placeholder: 'Index courant',
                      suffix: 'm³',
                      icon: CupertinoIcons.arrow_up_circle,
                      iconColor: AppColors.teal,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                label: 'DATE DE RELEVÉ',
                child: _buildDateRow(),
              ),
              const SizedBox(height: 16),
              _buildSection(
                label: 'STATUT',
                child: _buildSwitchRow(),
              ),
              const SizedBox(height: 32),
              _buildPreviewCard(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.systemGrouped,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
        child:
            const Icon(CupertinoIcons.xmark, color: AppColors.label, size: 20),
      ),
      title: const Text(
        'Nouveau relevé',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.label,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildErrorBanner() {
    return SizeTransition(
      sizeFactor: _errorAnimation,
      axisAlignment: -1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.danger.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_triangle_fill,
                color: AppColors.danger,
                size: 16,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _errorMessage ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.labelSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.systemBackground,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.cardSmall,
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ],
    );
  }

  Widget _buildBorneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.tealSubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              CupertinoIcons.drop_fill,
              color: AppColors.teal,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _nomBorne,
              style: AppText.body.copyWith(color: AppColors.label),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryGrouped,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Verrouillé',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.labelSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String placeholder,
    required String suffix,
    required IconData icon,
    Color? iconColor,
  }) {
    final isFocused = focusNode.hasFocus;
    final color = iconColor ?? AppColors.labelSecondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isFocused
            ? AppColors.teal.withValues(alpha: 0.03)
            : Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              focusNode: focusNode,
              placeholder: placeholder,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const BoxDecoration(),
              padding: EdgeInsets.zero,
              style: AppText.body.copyWith(color: AppColors.label),
              placeholderStyle: AppText.body.copyWith(
                color: AppColors.labelQuaternary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.systemGrouped,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              suffix,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.labelSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternalDivider() {
    return Container(
      height: 1,
      color: AppColors.systemGrouped,
      margin: const EdgeInsets.only(left: 46),
    );
  }

  Widget _buildDateRow() {
    final formatted = DateFormat('dd MMMM yyyy', 'fr_FR').format(_selectedDate);
    return GestureDetector(
      onTap: _showDatePicker,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFF375F).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.calendar,
                color: Color(0xFFFF375F),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                formatted,
                style: AppText.body.copyWith(color: AppColors.label),
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.labelQuaternary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _estPaye
                  ? AppColors.success.withValues(alpha: 0.12)
                  : AppColors.unpaid.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _estPaye
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.clock_fill,
              color: _estPaye ? AppColors.success : AppColors.unpaid,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Relevé payé',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.label,
                  ),
                ),
                Text(
                  _estPaye ? 'Paiement confirmé' : 'En attente de règlement',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.labelSecondary,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: _estPaye,
            activeTrackColor: AppColors.teal,
            onChanged: (v) => setState(() => _estPaye = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    final precText = _indexPrecCtrl.text.replaceAll(',', '.');
    final courText = _indexCourCtrl.text.replaceAll(',', '.');
    final prec = double.tryParse(precText);
    final cour = double.tryParse(courText);
    final valid = prec != null && cour != null && cour > prec;
    final consomm = valid ? (cour - prec) : 0.0;
    final montant = consomm * _tarifM3;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: valid
              ? [AppColors.teal, AppColors.tealDark]
              : [AppColors.secondaryGrouped, AppColors.secondaryGrouped],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: valid ? AppShadows.floatingButton : [],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aperçu du relevé',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: valid
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppColors.labelTertiary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  valid ? '${consomm.toStringAsFixed(1)} m³' : '-- m³',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: valid ? Colors.white : AppColors.labelQuaternary,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valid
                      ? '${montant.toStringAsFixed(0)} FCFA'
                      : 'Renseignez les index',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valid
                        ? Colors.white.withValues(alpha: 0.85)
                        : AppColors.labelQuaternary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            valid ? CupertinoIcons.drop_fill : CupertinoIcons.drop,
            color: valid
                ? Colors.white.withValues(alpha: 0.4)
                : AppColors.labelQuaternary,
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _validateAndSave,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.teal, AppColors.tealDark],
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.floatingButton,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.checkmark_alt, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Enregistrer le relevé',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
