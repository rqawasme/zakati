import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';
import '../../../widgets/shared/currency_input_field.dart';

class GoldSilverScreen extends ConsumerStatefulWidget {
  const GoldSilverScreen({super.key});

  @override
  ConsumerState<GoldSilverScreen> createState() => _GoldSilverScreenState();
}

class _GoldSilverScreenState extends ConsumerState<GoldSilverScreen> {
  late double _goldGrams;
  late double _silverGrams;

  @override
  void initState() {
    super.initState();
    final s = ref.read(zakatProvider);
    _goldGrams = s.goldWeightGrams;
    _silverGrams = s.silverWeightGrams;
  }

  void _onContinue() {
    final notifier = ref.read(zakatProvider.notifier);
    notifier.setGoldWeight(_goldGrams);
    notifier.setSilverWeight(_silverGrams);
    context.push('/calculator/cash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Gold & Silver'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 3, totalSteps: 11),
                  const SizedBox(height: 20),
                  const EducationCard(
                    text:
                        'Gold and silver in raw form — bars, coins, and bullion — are directly '
                        'zakatable. Enter the total weight you own. If you only know the monetary '
                        'value, you can estimate the weight using current market prices.',
                  ),
                  const SizedBox(height: 24),
                  WeightInputField(
                    label: 'Gold owned (grams)',
                    initialValue: _goldGrams,
                    onChanged: (v) => _goldGrams = v,
                    labelColor: AppColors.accent,
                    prefixIcon: Icons.circle,
                    prefixIconColor: AppColors.accent,
                  ),
                  const SizedBox(height: 16),
                  WeightInputField(
                    label: 'Silver owned (grams)',
                    initialValue: _silverGrams,
                    onChanged: (v) => _silverGrams = v,
                    labelColor: AppColors.accent,
                    prefixIcon: Icons.circle_outlined,
                    prefixIconColor: AppColors.accent,
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
