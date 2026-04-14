import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/currency_input_field.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

class LargeLiabilitiesScreen extends ConsumerStatefulWidget {
  const LargeLiabilitiesScreen({super.key});

  @override
  ConsumerState<LargeLiabilitiesScreen> createState() =>
      _LargeLiabilitiesScreenState();
}

class _LargeLiabilitiesScreenState
    extends ConsumerState<LargeLiabilitiesScreen> {
  late double _monthly;

  @override
  void initState() {
    super.initState();
    _monthly = ref.read(zakatProvider).largeLiabilitiesMonthly;
  }

  void _onContinue() {
    ref.read(zakatProvider.notifier).setLargeLiabilitiesMonthly(_monthly);
    context.push('/calculator/unpaid-zakat');
  }

  @override
  Widget build(BuildContext context) {
    final annual = _monthly * 12;
    final sym = ref.watch(zakatProvider).currencySymbol;

    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Large Liabilities'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 10, totalSteps: 11),
                  const SizedBox(height: 20),
                  const EducationCard(
                    text:
                        'For large ongoing liabilities such as a car loan or mortgage, a widely-used '
                        'scholarly approach is to deduct only the payments due in the coming year — '
                        '12 months of payments — rather than the full remaining balance. Enter your '
                        'combined monthly payment for all such liabilities.',
                  ),
                  const SizedBox(height: 24),
                  CurrencyInputField(
                    label: 'Combined monthly payment',
                    initialValue: _monthly,
                    onChanged: (v) => setState(() => _monthly = v),
                    prefixIcon: Icons.home_outlined,
                  ),
                  const SizedBox(height: 16),
                  // Live annual deduction display
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calculate_outlined,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.textSecondary),
                              children: [
                                const TextSpan(
                                    text: 'Annual deduction: monthly × 12 = '),
                                TextSpan(
                                  text: CurrencyFormatter.format(annual,
                                      symbol: sym),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                onPressed: _onContinue,
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
