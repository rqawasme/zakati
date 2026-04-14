import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/currency_input_field.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

class UnpaidZakatScreen extends ConsumerStatefulWidget {
  const UnpaidZakatScreen({super.key});

  @override
  ConsumerState<UnpaidZakatScreen> createState() => _UnpaidZakatScreenState();
}

class _UnpaidZakatScreenState extends ConsumerState<UnpaidZakatScreen> {
  late double _unpaid;

  @override
  void initState() {
    super.initState();
    _unpaid = ref.read(zakatProvider).unpaidPreviousZakat;
  }

  void _onContinue() {
    ref.read(zakatProvider.notifier).setUnpaidPreviousZakat(_unpaid);
    context.push('/calculator/nisab');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Previous Unpaid Zakat'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 11, totalSteps: 11),
                  const SizedBox(height: 20),
                  const EducationCard(
                    text:
                        'If you have Zakat from previous years that was due but unpaid, this amount '
                        'is deducted from your current zakatable wealth before calculating this '
                        'year\'s obligation. Fulfilling past Zakat obligations takes precedence.',
                  ),
                  const SizedBox(height: 24),
                  CurrencyInputField(
                    label: 'Unpaid previous Zakat (default 0)',
                    initialValue: _unpaid,
                    onChanged: (v) => _unpaid = v,
                    prefixIcon: Icons.history,
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
