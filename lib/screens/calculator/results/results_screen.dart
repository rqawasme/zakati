import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/zakat_calculator.dart';
import '../../../models/zakat_run.dart';
import '../../../providers/runs_provider.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

const _uuid = Uuid();

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(zakatProvider);
    final nisabThreshold =
        ZakatCalculator.goldNisabThreshold(state.goldPricePerOz);

    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Your Results'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Nisab Status Banner
            _NisabBanner(metNisab: state.metNisab),
            const SizedBox(height: 20),

            // 2. Zakat Due
            _ZakatDueCard(
              zakatDue: state.zakatDue,
              metNisab: state.metNisab,
            ),
            const SizedBox(height: 20),

            // 3. Breakdown
            _BreakdownCard(breakdown: state.breakdown),
            const SizedBox(height: 20),

            // 4. Summary Row
            _SummaryCard(
              totalZakatableWealth: state.totalZakatableWealth,
              nisabThreshold: nisabThreshold,
              zakatDue: state.zakatDue,
            ),
            const SizedBox(height: 20),

            // 5. Encouragement
            _EncouragementCard(),
            const SizedBox(height: 28),

            // 6. Action Buttons
            ElevatedButton(
              onPressed: () => _saveRun(context, ref),
              child: const Text('Save This Calculation'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ref.read(zakatProvider.notifier).reset();
                context.go('/calculator/madhab');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
              child: const Text('Start New Calculation'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.push('/runs'),
              child: const Text('View Past Runs'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _saveRun(BuildContext context, WidgetRef ref) async {
    final state = ref.read(zakatProvider);
    final run = ZakatRun.fromState(state, _uuid.v4());
    final notifier = ref.read(runsProvider.notifier);
    final saved = await notifier.saveRun(run);

    if (!context.mounted) return;

    if (!saved) {
      // At cap — prompt deletion of oldest
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Storage Full'),
          content: const Text(
              'You have reached the 30-run limit. Delete the oldest run to save this one?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete & Save'),
            ),
          ],
        ),
      );
      if (confirm == true) {
        await notifier.deleteOldestAndSave(run);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Calculation saved.')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calculation saved.')),
      );
    }
  }
}

// ── Nisab banner ──────────────────────────────────────────────────────────────

class _NisabBanner extends StatelessWidget {
  final bool metNisab;
  const _NisabBanner({required this.metNisab});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: metNisab ? AppColors.primaryLight : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: metNisab ? AppColors.primary : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Icon(
            metNisab ? Icons.check_circle : Icons.info_outline,
            color: metNisab ? AppColors.primary : AppColors.textSecondary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              metNisab
                  ? 'Alhamdulillah, your wealth meets the nisab threshold. Zakat is due.'
                  : 'Your wealth does not currently meet the nisab threshold. Zakat is not due at this time.',
              style: AppTextStyles.body.copyWith(
                color:
                    metNisab ? AppColors.primaryDark : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Zakat due ─────────────────────────────────────────────────────────────────

class _ZakatDueCard extends StatelessWidget {
  final double zakatDue;
  final bool metNisab;
  const _ZakatDueCard({required this.zakatDue, required this.metNisab});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Zakat Due', style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          Text(
            CurrencyFormatter.format(zakatDue),
            style: AppTextStyles.amountDisplay,
          ),
          const SizedBox(height: 6),
          Text(
            metNisab
                ? '2.5% of your total zakatable wealth'
                : 'Your wealth is below the nisab threshold',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Breakdown ─────────────────────────────────────────────────────────────────

class _BreakdownCard extends StatelessWidget {
  final Map<String, double> breakdown;
  const _BreakdownCard({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final positives =
        breakdown.entries.where((e) => e.value >= 0).toList();
    final deductions =
        breakdown.entries.where((e) => e.value < 0).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Breakdown by Category', style: AppTextStyles.headingSmall),
          const SizedBox(height: 16),

          // Assets
          ...positives.map((e) => _BreakdownRow(
                label: e.key,
                amount: e.value,
                isDeduction: false,
              )),

          if (deductions.isNotEmpty) ...[
            const Divider(height: 24),
            Text('Deductions',
                style: AppTextStyles.label
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            ...deductions.map((e) => _BreakdownRow(
                  label: e.key,
                  amount: e.value.abs(),
                  isDeduction: true,
                )),
          ],
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDeduction;

  const _BreakdownRow({
    required this.label,
    required this.amount,
    required this.isDeduction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary)),
          ),
          Text(
            '${isDeduction ? '−' : ''} ${CurrencyFormatter.format(amount)}',
            style: AppTextStyles.body.copyWith(
              color: isDeduction ? AppColors.error : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary ───────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final double totalZakatableWealth;
  final double nisabThreshold;
  final double zakatDue;

  const _SummaryCard({
    required this.totalZakatableWealth,
    required this.nisabThreshold,
    required this.zakatDue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Total Zakatable Wealth',
            value: CurrencyFormatter.format(totalZakatableWealth),
          ),
          const Divider(height: 20),
          _SummaryRow(
            label: 'Nisab Threshold Used (Gold)',
            value: CurrencyFormatter.format(nisabThreshold),
          ),
          const Divider(height: 20),
          _SummaryRow(
            label: 'Zakat Due',
            value: CurrencyFormatter.format(zakatDue),
            highlighted: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: highlighted
              ? AppTextStyles.body.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                )
              : AppTextStyles.body,
        ),
      ],
    );
  }
}

// ── Encouragement ─────────────────────────────────────────────────────────────

class _EncouragementCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: AppColors.accent, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JazakAllahu Khayran',
            style: AppTextStyles.headingSmall
                .copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: 8),
          Text(
            'May Allah accept your Zakat and bless your wealth. Zakat is an act of '
            'worship — it purifies your earnings and brings barakah to what remains. '
            'JazakAllahu khayran.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
