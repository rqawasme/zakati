import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/zakat_run.dart';
import '../../providers/runs_provider.dart';
import '../../widgets/shared/zakati_app_bar.dart';

class RunDetailScreen extends ConsumerWidget {
  final String runId;
  const RunDetailScreen({super.key, required this.runId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final run = ref.read(runsProvider.notifier).findById(runId);

    if (run == null) {
      return Scaffold(
        appBar: const ZakatiAppBar(title: 'Run Detail'),
        body: const Center(child: Text('Calculation not found.')),
      );
    }

    final sym = run.currencySymbol;

    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Saved Calculation'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saved record banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(color: AppColors.accent, width: 3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.archive_outlined,
                      color: AppColors.accent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Saved on ${DateFormat('MMMM d, yyyy').format(run.createdAt)}  ·  ${run.currency}',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.accent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _NisabBanner(metNisab: run.metNisab),
            const SizedBox(height: 20),

            _ZakatDueCard(run: run, sym: sym),
            const SizedBox(height: 20),

            _BreakdownCard(run: run, sym: sym),
            const SizedBox(height: 20),

            _SummaryCard(run: run, sym: sym),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

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
            color: metNisab ? AppColors.primary : AppColors.divider),
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
                color: metNisab
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZakatDueCard extends StatelessWidget {
  final ZakatRun run;
  final String sym;
  const _ZakatDueCard({required this.run, required this.sym});

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
            CurrencyFormatter.format(run.zakatDue, symbol: sym),
            style: AppTextStyles.amountDisplay,
          ),
          const SizedBox(height: 6),
          Text(
            run.metNisab
                ? '2.5% of your total zakatable wealth'
                : 'Below nisab threshold',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final ZakatRun run;
  final String sym;
  const _BreakdownCard({required this.run, required this.sym});

  @override
  Widget build(BuildContext context) {
    final positives =
        run.breakdown.entries.where((e) => e.value >= 0).toList();
    final deductions =
        run.breakdown.entries.where((e) => e.value < 0).toList();

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
          Text('Breakdown', style: AppTextStyles.headingSmall),
          const SizedBox(height: 16),
          ...positives.map((e) =>
              _Row(label: e.key, amount: e.value, isDeduction: false, sym: sym)),
          if (deductions.isNotEmpty) ...[
            const Divider(height: 24),
            Text('Deductions',
                style: AppTextStyles.label
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            ...deductions.map((e) => _Row(
                label: e.key,
                amount: e.value.abs(),
                isDeduction: true,
                sym: sym)),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDeduction;
  final String sym;
  const _Row(
      {required this.label,
      required this.amount,
      required this.isDeduction,
      required this.sym});

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
                      .copyWith(color: AppColors.textSecondary))),
          Text(
            '${isDeduction ? '−' : ''} ${CurrencyFormatter.format(amount, symbol: sym)}',
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

class _SummaryCard extends StatelessWidget {
  final ZakatRun run;
  final String sym;
  const _SummaryCard({required this.run, required this.sym});

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
            value: CurrencyFormatter.format(run.totalZakatableWealth,
                symbol: sym),
          ),
          const Divider(height: 20),
          _SummaryRow(
            label: 'Nisab Threshold (Gold)',
            value: CurrencyFormatter.format(run.goldNisabThreshold,
                symbol: sym),
          ),
          const Divider(height: 20),
          _SummaryRow(
            label: 'Zakat Due',
            value: CurrencyFormatter.format(run.zakatDue, symbol: sym),
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
  const _SummaryRow(
      {required this.label, required this.value, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.body.copyWith(
                fontWeight:
                    highlighted ? FontWeight.w600 : FontWeight.w400)),
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
