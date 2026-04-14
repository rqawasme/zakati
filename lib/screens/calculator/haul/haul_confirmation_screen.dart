import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

class HaulConfirmationScreen extends StatelessWidget {
  const HaulConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZakatiAppBar(title: 'About the Haul'),
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
                        'The haul refers to the completion of one full lunar (Hijri) year since '
                        'your wealth first reached the nisab threshold. Zakat is calculated on '
                        'whatever you possess on that anniversary date — your wealth may rise and '
                        'fall throughout the year without affecting the obligation. If you are '
                        'unsure about your haul date, consult a knowledgeable scholar.',
                  ),
                  const SizedBox(height: 20),

                  // Additional context card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text('Key Points',
                                style: AppTextStyles.headingSmall
                                    .copyWith(color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _BulletPoint(
                            text:
                                'A lunar year (Hijri) is approximately 354 days.'),
                        _BulletPoint(
                            text:
                                'Your wealth can fluctuate above and below the nisab throughout the year — wages, expenses, and spending are normal. What matters is what you possess on the anniversary date.'),
                        _BulletPoint(
                            text:
                                'The haul begins from the date your wealth first reached the nisab threshold. One lunar year later, calculate what you own on that day — that is what Zakat is due on.'),
                        _BulletPoint(
                            text:
                                'Zakat is obligatory on every Muslim who meets the nisab — including children and those with mental incapacity. In such cases, their guardian is responsible for paying it on their behalf.'),
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
                onPressed: () => context.push('/calculator/gold-silver'),
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(color: AppColors.primary, fontSize: 14)),
          Expanded(
            child: Text(text,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
