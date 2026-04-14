import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

class HaulConfirmationScreen extends ConsumerStatefulWidget {
  const HaulConfirmationScreen({super.key});

  @override
  ConsumerState<HaulConfirmationScreen> createState() =>
      _HaulConfirmationScreenState();
}

class _HaulConfirmationScreenState
    extends ConsumerState<HaulConfirmationScreen> {
  bool? _haulCompleted;

  @override
  void initState() {
    super.initState();
    _haulCompleted = ref.read(zakatProvider).haulCompleted;
  }

  void _onContinue() {
    ref.read(zakatProvider.notifier).setHaulCompleted(_haulCompleted!);
    context.push('/calculator/gold-silver');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Haul Confirmation'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 2, totalSteps: 11),
                  const SizedBox(height: 20),
                  const EducationCard(
                    text:
                        'The haul refers to the completion of one full lunar (Hijri) year during '
                        'which your wealth has remained at or above the nisab threshold. Zakat is '
                        'only obligatory on wealth held for a complete lunar year. If you are unsure '
                        'about your haul, consult a knowledgeable scholar.',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Have your assets been in your possession for a full lunar year?',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  _RadioCard(
                    label: 'Yes',
                    subtitle: 'My assets have been with me for a full lunar year.',
                    value: true,
                    groupValue: _haulCompleted,
                    onChanged: (v) => setState(() => _haulCompleted = v),
                  ),
                  const SizedBox(height: 12),
                  _RadioCard(
                    label: 'No',
                    subtitle:
                        'My assets have not yet completed a full lunar year.',
                    value: false,
                    groupValue: _haulCompleted,
                    onChanged: (v) => setState(() => _haulCompleted = v),
                  ),
                  if (_haulCompleted == false) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE8C06E)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline,
                              color: Color(0xFFB5862A), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Zakat may not yet be due on these assets. You can continue to estimate or plan ahead.',
                              style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF7A5C1E)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: ElevatedButton(
                onPressed: _haulCompleted != null ? _onContinue : null,
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final bool? groupValue;
  final ValueChanged<bool?> onChanged;

  const _RadioCard({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.headingSmall),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
            else
              const Icon(Icons.radio_button_unchecked,
                  color: AppColors.divider, size: 24),
          ],
        ),
      ),
    );
  }
}
