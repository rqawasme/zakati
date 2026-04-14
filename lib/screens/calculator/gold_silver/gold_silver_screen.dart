import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
  // Always stored in grams internally; WeightInputField handles conversion.
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
    final unit = ref.watch(zakatProvider).weightUnit;

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
                  const SizedBox(height: 20),

                  // Weight unit toggle
                  _UnitToggleRow(
                    selected: unit,
                    onChanged: (u) =>
                        ref.read(zakatProvider.notifier).setWeightUnit(u),
                  ),
                  const SizedBox(height: 16),

                  WeightInputField(
                    key: ValueKey('gold_$unit'),
                    label: 'Gold owned',
                    initialValue: _goldGrams,
                    onChanged: (g) => _goldGrams = g,
                    labelColor: AppColors.accent,
                    prefixIcon: Icons.circle,
                    prefixIconColor: AppColors.accent,
                  ),
                  const SizedBox(height: 16),
                  WeightInputField(
                    key: ValueKey('silver_$unit'),
                    label: 'Silver owned',
                    initialValue: _silverGrams,
                    onChanged: (g) => _silverGrams = g,
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

class _UnitToggleRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _UnitToggleRow({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Unit:', style: AppTextStyles.label),
        const SizedBox(width: 12),
        _Chip(
          label: 'Grams (g)',
          active: selected == 'g',
          onTap: () => onChanged('g'),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Troy oz',
          active: selected == 'oz',
          onTap: () => onChanged('oz'),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: active ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
