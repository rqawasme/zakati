import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/app_toast.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

class MadhabSelectionScreen extends ConsumerStatefulWidget {
  const MadhabSelectionScreen({super.key});

  @override
  ConsumerState<MadhabSelectionScreen> createState() =>
      _MadhabSelectionScreenState();
}

class _MadhabSelectionScreenState extends ConsumerState<MadhabSelectionScreen> {
  String? _selected;

  static const _madhabs = [
    _MadhabOption(
      id: 'maliki',
      name: 'Maliki',
      subtitle: 'Predominant in North & West Africa, parts of the Middle East',
      available: true,
    ),
    _MadhabOption(
      id: 'hanafi',
      name: 'Hanafi',
      subtitle: 'Predominant in South & Central Asia, Turkey, the Balkans',
      available: false,
    ),
    _MadhabOption(
      id: 'shafii',
      name: "Shafi'i",
      subtitle:
          'Predominant in East Africa, Southeast Asia, parts of the Middle East',
      available: false,
    ),
    _MadhabOption(
      id: 'hanbali',
      name: 'Hanbali',
      subtitle: 'Predominant in the Arabian Peninsula',
      available: false,
    ),
  ];

  void _onMadhabTap(_MadhabOption option) {
    if (!option.available) {
      // TODO: Implement Hanafi/Shafi'i/Hanbali madhab logic
      AppToast.show(context, 'Coming soon, insha\'Allah.');
      return;
    }
    setState(() => _selected = option.id);
  }

  void _onContinue() {
    if (_selected == null) return;
    ref.read(zakatProvider.notifier).setMadhab(_selected!);
    context.push('/calculator/haul');
  }

  @override
  Widget build(BuildContext context) {
    final savedMadhab = ref.watch(zakatProvider).madhab;
    final effective = _selected ?? savedMadhab;

    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Select Your Madhab'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 1, totalSteps: 11),
                  const SizedBox(height: 20),
                  const EducationCard(
                    text:
                        'The four major madhabs (schools of Islamic jurisprudence) have some '
                        'differences in how Zakat is calculated — particularly around jewellery '
                        'exemptions, nisab thresholds, and certain asset types. Select the madhab '
                        'you follow so the app can apply the correct rulings to your situation.',
                  ),
                  const SizedBox(height: 24),
                  Text('Which madhab do you follow?',
                      style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  ...(_madhabs.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MadhabCard(
                        option: m,
                        isSelected: effective == m.id,
                        onTap: () => _onMadhabTap(m),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: ElevatedButton(
                onPressed: effective != null ? _onContinue : null,
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MadhabCard extends StatelessWidget {
  final _MadhabOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _MadhabCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  Row(
                    children: [
                      Text(option.name, style: AppTextStyles.headingSmall),
                      const SizedBox(width: 8),
                      if (!option.available)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Coming Soon',
                            style: AppTextStyles.caption.copyWith(fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(option.subtitle, style: AppTextStyles.caption),
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

class _MadhabOption {
  final String id;
  final String name;
  final String subtitle;
  final bool available;

  const _MadhabOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.available,
  });
}
