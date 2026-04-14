import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/zakat_calculator.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

class NisabScreen extends ConsumerWidget {
  const NisabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.read(zakatProvider);
    final computed = ZakatCalculator.compute(s);

    // Persist results after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(zakatProvider.notifier).setResults(
            totalZakatableWealth: computed.totalZakatableWealth,
            zakatDue: computed.zakatDue,
            metNisab: computed.metNisab,
            nisabUsed: computed.nisabUsed,
            breakdown: computed.breakdown,
          );
    });

    final sym = s.currencySymbol;
    final unit = s.weightUnit;
    final isOz = unit == 'oz';
    const troy = ZakatCalculator.troyOzToGrams;

    // TODO: Replace with live gold/silver price API
    final goldPricePerOzLocal = s.goldPricePerOz * s.exchangeRateFromUSD;
    final silverPricePerOzLocal = s.silverPricePerOz * s.exchangeRateFromUSD;
    final goldPricePerGramLocal = goldPricePerOzLocal / troy;
    final silverPricePerGramLocal = silverPricePerOzLocal / troy;

    final goldPriceDisplay = isOz ? goldPricePerOzLocal : goldPricePerGramLocal;
    final silverPriceDisplay =
        isOz ? silverPricePerOzLocal : silverPricePerGramLocal;

    // Nisab weights — always show both gram and oz for clarity
    const goldNisabGrams = ZakatCalculator.goldNisabGrams;
    const silverNisabGrams = ZakatCalculator.silverNisabGrams;
    final goldNisabOz = goldNisabGrams / troy;
    final silverNisabOz = silverNisabGrams / troy;

    final goldNisab = ZakatCalculator.goldNisabThreshold(s);
    final silverNisab = ZakatCalculator.silverNisabThreshold(s);

    final usingGold = computed.nisabUsed == 'gold';
    final activeNisabValue = usingGold ? goldNisab : silverNisab;

    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Nisab Threshold'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Active nisab highlight ───────────────────────────
                  _ActiveNisabCard(
                    usingGold: usingGold,
                    amount: activeNisabValue,
                    sym: sym,
                  ),
                  const SizedBox(height: 20),

                  // ── Education ────────────────────────────────────────
                  _EducationSection(usingGold: usingGold),
                  const SizedBox(height: 20),

                  // ── Prices used ──────────────────────────────────────
                  _InfoCard(
                    title: 'Today\'s Prices Used',
                    children: [
                      _PriceRow(
                        label: 'Gold',
                        // TODO: Replace with live gold/silver price API
                        pricePerUnit: CurrencyFormatter.format(
                                goldPriceDisplay, symbol: sym) +
                            ' / ${isOz ? 'troy oz' : 'g'}',
                        note:
                            'Base: \$${s.goldPricePerOz.toStringAsFixed(0)} USD/troy oz · Hardcoded — live API coming',
                      ),
                      const Divider(height: 20),
                      _PriceRow(
                        label: 'Silver',
                        // TODO: Replace with live gold/silver price API
                        pricePerUnit: CurrencyFormatter.format(
                                silverPriceDisplay, symbol: sym) +
                            ' / ${isOz ? 'troy oz' : 'g'}',
                        note:
                            'Base: \$${s.silverPricePerOz.toStringAsFixed(0)} USD/troy oz · Hardcoded — live API coming',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Both nisab values ─────────────────────────────────
                  _InfoCard(
                    title: 'Nisab Thresholds',
                    children: [
                      _NisabRow(
                        label: 'Gold Nisab',
                        grams: goldNisabGrams,
                        oz: goldNisabOz,
                        amount: goldNisab,
                        sym: sym,
                        isActive: usingGold,
                      ),
                      const Divider(height: 20),
                      _NisabRow(
                        label: 'Silver Nisab',
                        grams: silverNisabGrams,
                        oz: silverNisabOz,
                        amount: silverNisab,
                        sym: sym,
                        isActive: !usingGold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: ElevatedButton(
                onPressed: () => context.push('/calculator/results'),
                child: const Text('View My Results'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Active nisab highlight card ───────────────────────────────────────────────

class _ActiveNisabCard extends StatelessWidget {
  final bool usingGold;
  final double amount;
  final String sym;

  const _ActiveNisabCard({
    required this.usingGold,
    required this.amount,
    required this.sym,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Your Nisab Threshold Today',
                style: AppTextStyles.label
                    .copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            CurrencyFormatter.format(amount, symbol: sym),
            style: AppTextStyles.amountDisplay
                .copyWith(color: AppColors.primary, fontSize: 32),
          ),
          const SizedBox(height: 6),
          Text(
            usingGold
                ? 'Using gold nisab — applies in your situation'
                : 'Using silver nisab — silver is your only zakatable asset',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }
}

// ── Education section ─────────────────────────────────────────────────────────

class _EducationSection extends StatelessWidget {
  final bool usingGold;
  const _EducationSection({required this.usingGold});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: AppColors.accent, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What is Nisab?',
              style:
                  AppTextStyles.label.copyWith(color: AppColors.accent)),
          const SizedBox(height: 8),
          Text(
            'Nisab is the minimum threshold of wealth a Muslim must possess '
            'before Zakat becomes obligatory. It is based on the value of '
            'gold or silver and is recalculated using current market prices.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 12),
          Text('Which nisab applies to you (Maliki)?',
              style:
                  AppTextStyles.label.copyWith(color: AppColors.accent)),
          const SizedBox(height: 8),
          Text(
            usingGold
                ? 'The gold nisab (85g of gold) applies. In the Maliki madhab, '
                    'the gold nisab is used whenever you own any asset other '
                    'than silver alone — such as gold, cash, jewellery held for '
                    'investment, or recoverable debts.'
                : 'The silver nisab (595g of silver) applies. In the Maliki '
                    'madhab, the silver nisab is only used when silver is your '
                    'sole zakatable asset. Since you have no gold, cash, '
                    'investment jewellery, or receivable debts, the silver '
                    'nisab threshold applies to your calculation.',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoCard({required this.title, required this.children});

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
          Text(title, style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String pricePerUnit;
  final String note;
  const _PriceRow(
      {required this.label,
      required this.pricePerUnit,
      required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.label.copyWith(color: AppColors.accent)),
        const SizedBox(height: 2),
        Text(pricePerUnit, style: AppTextStyles.body),
        const SizedBox(height: 2),
        Text(note,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary.withOpacity(0.7))),
      ],
    );
  }
}

class _NisabRow extends StatelessWidget {
  final String label;
  final double grams;
  final double oz;
  final double amount;
  final String sym;
  final bool isActive;

  const _NisabRow({
    required this.label,
    required this.grams,
    required this.oz,
    required this.amount,
    required this.sym,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isActive)
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 8),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          )
        else
          const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              Text(
                // Always show both g and troy oz so there's no ambiguity
                '${grams.toStringAsFixed(0)}g  ·  ${oz.toStringAsFixed(4)} troy oz',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        Text(
          CurrencyFormatter.format(amount, symbol: sym),
          style: AppTextStyles.body.copyWith(
            color: isActive ? AppColors.accent : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
