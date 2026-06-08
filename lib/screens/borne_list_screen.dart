import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import '../theme/app_theme.dart';

class BorneListScreen extends StatefulWidget {
  const BorneListScreen({super.key});

  @override
  State<BorneListScreen> createState() => _BorneListScreenState();
}

class _BorneListScreenState extends State<BorneListScreen>
    with SingleTickerProviderStateMixin {
  late final Map<String, List<Releve>> _bornes;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _bornes = buildSampleData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _totalReleves {
    return _bornes.values.fold(0, (total, releves) => total + releves.length);
  }

  int get _totalNonPayes {
    return _bornes.values
        .fold(0, (total, releves) => total + releves.countUnpaid);
  }

  Future<void> _openDetail(String nomBorne, List<Releve> releves) async {
    await Navigator.pushNamed(
      context,
      '/detail',
      arguments: {
        'nomBorne': nomBorne,
        'releves': releves,
        'tarifM3': kTarifM3,
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.systemGrouped,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildStatsBanner()),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 10),
            sliver: SliverToBoxAdapter(
              child: Text('Liste des bornes', style: AppText.title3),
            ),
          ),
          _buildBorneList(),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.teal,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 92,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ASUFOR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Gestion des bornes-fontaines',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        CupertinoButton(
          padding: const EdgeInsets.only(right: 8),
          onPressed: () => Navigator.pushNamed(context, '/apropos'),
          child: const Icon(
            CupertinoIcons.info_circle,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBanner() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Row(
        children: [
          _HeaderStatCard(
            icon: CupertinoIcons.drop_fill,
            label: 'Bornes actives',
            value: _bornes.length.toString(),
          ),
          const SizedBox(width: 10),
          _HeaderStatCard(
            icon: CupertinoIcons.doc_text_fill,
            label: 'Total releves',
            value: _totalReleves.toString(),
          ),
          const SizedBox(width: 10),
          _HeaderStatCard(
            icon: CupertinoIcons.exclamationmark_triangle_fill,
            label: 'Non payes',
            value: _totalNonPayes.toString(),
            alert: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBorneList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.separated(
        itemCount: _bornes.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final nomBorne = _bornes.keys.elementAt(index);
          final releves = _bornes[nomBorne] ?? <Releve>[];
          final delay = index * 0.08;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final rawT =
                  ((_controller.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);
              final t = Curves.easeOutCubic.transform(rawT);
              return Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, 18 * (1 - t)),
                  child: child,
                ),
              );
            },
            child: _StatCard(
              nomBorne: nomBorne,
              nombreReleves: releves.length,
              totalM3: releves.totalVolume,
              nombreNonPayes: releves.countUnpaid,
              onTap: () => _openDetail(nomBorne, releves),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool alert;

  const _HeaderStatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.alert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 98,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: alert ? AppColors.unpaidSubtle : Colors.white,
              size: 21,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String nomBorne;
  final int nombreReleves;
  final double totalM3;
  final int nombreNonPayes;
  final VoidCallback onTap;

  const _StatCard({
    required this.nomBorne,
    required this.nombreReleves,
    required this.totalM3,
    required this.nombreNonPayes,
    required this.onTap,
  });

  bool get _aJour => nombreNonPayes == 0;

  @override
  Widget build(BuildContext context) {
    final couleurEtat = _aJour ? AppColors.teal : AppColors.unpaid;

    return Material(
      color: AppColors.systemBackground,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.systemBackground,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border(left: BorderSide(color: couleurEtat, width: 5)),
            boxShadow: AppShadows.cardSmall,
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.tealSubtle,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  CupertinoIcons.drop_fill,
                  color: AppColors.teal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomBorne,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.headline,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$nombreReleves releve(s) - ${totalM3.toStringAsFixed(1)} m3 consommes',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.footnote,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _PaymentBadge(nombreNonPayes: nombreNonPayes),
              const SizedBox(width: 6),
              const Icon(
                CupertinoIcons.chevron_right,
                color: AppColors.labelTertiary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final int nombreNonPayes;

  const _PaymentBadge({required this.nombreNonPayes});

  @override
  Widget build(BuildContext context) {
    final estAJour = nombreNonPayes == 0;

    return Container(
      constraints: const BoxConstraints(minWidth: 58, maxWidth: 96),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: estAJour ? AppColors.tealSubtle : AppColors.unpaidSubtle,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        estAJour ? 'A jour' : '$nombreNonPayes impaye(s)',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: estAJour ? AppColors.teal : AppColors.unpaid,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
