import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../theme/app_theme.dart';

class ReleveDetailScreen extends StatefulWidget {
  const ReleveDetailScreen({super.key});

  @override
  State<ReleveDetailScreen> createState() => _ReleveDetailScreenState();
}

class _ReleveDetailScreenState extends State<ReleveDetailScreen>
    with TickerProviderStateMixin {
  late List<Releve> _releves;
  late String _nomBorne;
  late double _tarifM3;
  bool _initialized = false;

  late AnimationController _statsController;
  late AnimationController _listController;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _statsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    Future.delayed(const Duration(milliseconds: 120), () {
      _statsController.forward();
      _listController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _fabController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      _nomBorne = args?['nomBorne'] ?? 'Borne';
      _releves = List<Releve>.from(args?['releves'] ?? []);
      _tarifM3 = (args?['tarifM3'] ?? 350.0).toDouble();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _statsController.dispose();
    _listController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _confirmDelete(int index) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Supprimer ce relevé ?'),
        content: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            'Cette action est irréversible. Le relevé sera définitivement supprimé.',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _releves.removeAt(index));
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasReleves = _releves.isNotEmpty;
    return Scaffold(
      backgroundColor: AppColors.systemGrouped,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            sliver: SliverToBoxAdapter(child: _buildStatsRow()),
          ),
          if (hasReleves) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Relevés', style: AppText.title3),
                    Text(
                      '${_releves.length} entrée${_releves.length > 1 ? 's' : ''}',
                      style: AppText.footnote,
                    ),
                  ],
                ),
              ),
            ),
            _buildReleveList(),
          ] else ...[
            SliverToBoxAdapter(
              child: _buildEmptyState(),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.elasticOut,
        ),
        child: _buildFAB(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.systemGrouped,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 4),
            Icon(
              CupertinoIcons.back,
              color: AppColors.teal,
              size: 22,
            ),
          ],
        ),
      ),
      title: Text(
        _nomBorne,
        style: AppText.headline.copyWith(color: AppColors.label),
      ),
      centerTitle: true,
    );
  }

  Widget _buildStatsRow() {
    return AnimatedBuilder(
      animation: _statsController,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_statsController.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - t)),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: CupertinoIcons.drop_fill,
              label: 'Volume total',
              value: _releves.totalVolume.toStringAsFixed(1),
              unit: 'm³',
              color: AppColors.teal,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: CupertinoIcons.money_dollar_circle_fill,
              label: 'Montant total',
              value: _formatAmount(_releves.totalFCFA),
              unit: 'FCFA',
              color: const Color(0xFF30D158),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: CupertinoIcons.doc_text_fill,
              label: 'Relevés',
              value: _releves.length.toString(),
              unit: '',
              color: const Color(0xFF0A84FF),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    }
    return amount.toStringAsFixed(0);
  }

  Widget _buildReleveList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _releves.length) return null;
            final releve = _releves[index];
            final delay = index * 0.08;

            return AnimatedBuilder(
              animation: _listController,
              builder: (context, child) {
                final rawT = ((_listController.value - delay) / (1.0 - delay))
                    .clamp(0.0, 1.0);
                final t = Curves.easeOutCubic.transform(rawT);
                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - t)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReleveCard(
                  releve: releve,
                  tarifM3: _tarifM3,
                  onDelete: () => _confirmDelete(index),
                  onTogglePay: () {
                    setState(() => releve.paye = !releve.paye);
                  },
                ),
              ),
            );
          },
          childCount: _releves.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.tealSubtle,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: const Icon(
              CupertinoIcons.doc_text,
              color: AppColors.teal,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Aucun relevé', style: AppText.title3),
          const SizedBox(height: 8),
          const Text(
            'Appuyez sur + pour ajouter\nle premier relevé de cette borne.',
            textAlign: TextAlign.center,
            style: AppText.subheadline,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/formulaire',
        arguments: {
          'nomBorne': _nomBorne,
          'releves': _releves,
          'tarifM3': _tarifM3,
        },
      ).then((_) => setState(() {})),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.teal, AppColors.tealDark],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.floatingButton,
        ),
        child: const Icon(
          CupertinoIcons.plus,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

// ─── StatCard ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.systemBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.cardSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.label,
                  letterSpacing: -0.3,
                  height: 1.0,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelSecondary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 3),
          Text(label, style: AppText.caption2),
        ],
      ),
    );
  }
}

// ─── ReleveCard ───────────────────────────────────────────────────────────────

class _ReleveCard extends StatelessWidget {
  final Releve releve;
  final double tarifM3;
  final VoidCallback onDelete;
  final VoidCallback onTogglePay;

  const _ReleveCard({
    required this.releve,
    required this.tarifM3,
    required this.onDelete,
    required this.onTogglePay,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy', 'fr_FR').format(releve.date);
    final consomm = releve.consommation();
    final montant = releve.montantAPayer(tarifM3);
    final badge = releve.paye ? BadgeData.paye() : BadgeData.impaye();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.systemBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.cardSmall,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dateStr, style: AppText.headline),
                            const SizedBox(height: 4),
                            _buildBadge(badge),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            CupertinoIcons.trash,
                            color: AppColors.danger,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildDivider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildDataPair(
                        label: 'Index préc.',
                        value: releve.indexPrecedent.toStringAsFixed(1),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        CupertinoIcons.arrow_right,
                        color: AppColors.labelQuaternary,
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      _buildDataPair(
                        label: 'Index cour.',
                        value: releve.indexCourant.toStringAsFixed(1),
                      ),
                      const Spacer(),
                      _buildDataPair(
                        label: 'Consommation',
                        value: '${consomm.toStringAsFixed(1)} m³',
                        valueColor: AppColors.teal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildMontantFooter(montant),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BadgeData badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badge.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        badge.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: badge.color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: AppColors.systemGrouped);
  }

  Widget _buildDataPair({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.caption2),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.label,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMontantFooter(double montant) {
    return Container(
      color: releve.paye ? AppColors.tealFaint : AppColors.unpaidSubtle,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                releve.paye
                    ? CupertinoIcons.checkmark_circle_fill
                    : CupertinoIcons.clock_fill,
                color: releve.paye ? AppColors.teal : AppColors.unpaid,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                releve.paye ? 'Paiement reçu' : 'En attente de paiement',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: releve.paye ? AppColors.teal : AppColors.unpaid,
                ),
              ),
            ],
          ),
          Text(
            '${montant.toStringAsFixed(0)} FCFA',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: releve.paye ? AppColors.teal : AppColors.unpaid,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
