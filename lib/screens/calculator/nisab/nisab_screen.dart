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
    final state = ref.read(zakatProvider);

    // Compute and persist results
    final computed = ZakatCalculator.compute(state);
    // Persist computed values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(zakatProvider.notifier).setResults(
            totalZakatableWealth: computed.totalZakatableWealth,
            zakatDue: computed.zakatDue,
            metNisab: computed.metNisab,
            breakdown: computed.breakdown,
          );
    });

    // TODO: Replace with live gold/silver price API
    final goldPricePerGram = state.goldPricePerOz / 31.1035;
    final silverPricePerGram = state.silverPricePerOz / 31.1035;
    final goldNisab = ZakatCalculator.goldNisabThreshold(state.goldPricePerOz);
    final silverNisab =
        ZakatCalculator.silverNisabThreshold(state.silverPricePerOz);

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
                  Text('Your Nisab Threshold',
                      style: AppTextStyles.headingLarge),
                  const SizedBox(height: 20),

                  // Prices used
                  _InfoCard(
                    title: 'Prices Used',
                    children: [
                      _PriceRow(
                        label: 'Gold',
                        // TODO: Replace with live gold/silver price API
                        value:
                            '${CurrencyFormatter.format(state.goldPricePerOz)} / troy oz  '
                            '(${CurrencyFormatter.format(goldPricePerGram)}/g)',
                        note: 'Hardcoded — live API coming',
                      ),
                      const SizedBox(height: 8),
                      _PriceRow(
                        label: 'Silver',
                        // TODO: Replace with live gold/silver price API
                        value:
                            '${CurrencyFormatter.format(state.silverPricePerOz)} / troy oz  '
                            '(${CurrencyFormatter.format(silverPricePerGram)}/g)',
                        note: 'Hardcoded — live API coming',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Nisab values
                  _InfoCard(
                    title: 'Nisab Thresholds',
                    children: [
                      _NisabRow(
                        label: 'Gold Nisab (85g)',
                        amount: goldNisab,
                        isActive: true,
                      ),
                      const Divider(height: 20),
                      _NisabRow(
                        label: 'Silver Nisab (595g)',
                        amount: silverNisab,
                        isActive: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Madhab card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.body.copyWith(
                                  color: AppColors.textPrimary),
                              children: [
                                const TextSpan(
                                    text: 'Your madhab (Maliki) uses the '),
                                TextSpan(
                                  text: 'gold nisab',
                                  style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary),
                                ),
                                const TextSpan(text: ' threshold.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Educational note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(color: AppColors.accent, width: 3),
                      ),
                    ),
                    child: Text(
                      'The gold nisab is higher than the silver nisab — meaning more wealth '
                      'is required before Zakat becomes obligatory. The Maliki, Hanbali, and '
                      'Shafi\'i madhabs generally use the gold nisab. This is the more '
                      'conservative threshold and benefits those with moderate wealth by '
                      'requiring a higher minimum before obligation is triggered.',
                      style: AppTextStyles.caption,
                    ),
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
  final String value;
  final String note;

  const _PriceRow(
      {required this.label, required this.value, required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.label.copyWith(color: AppColors.accent)),
        Text(value, style: AppTextStyles.body),
        Text(note,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary.withOpacity(0.7))),
      ],
    );
  }
}

class _NisabRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isActive;

  const _NisabRow(
      {required this.label, required this.amount, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (isActive)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color:
                    isActive ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
        Text(
          CurrencyFormatter.format(amount),
          style: AppTextStyles.body.copyWith(
            color: isActive ? AppColors.accent : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
