import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/currency_input_field.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

class DebtsOwedScreen extends ConsumerStatefulWidget {
  const DebtsOwedScreen({super.key});

  @override
  ConsumerState<DebtsOwedScreen> createState() => _DebtsOwedScreenState();
}

class _DebtsOwedScreenState extends ConsumerState<DebtsOwedScreen> {
  late double _debtsOwed;

  @override
  void initState() {
    super.initState();
    _debtsOwed = ref.read(zakatProvider).debtsOwed;
  }

  void _onContinue() {
    ref.read(zakatProvider.notifier).setDebtsOwed(_debtsOwed);
    context.push('/calculator/debts-receivable');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Debts You Owe'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 8, totalSteps: 11),
                  const SizedBox(height: 20),
                  const EducationCard(
                    text:
                        'Debts you owe to others reduce your zakatable wealth. Include personal '
                        'loans and money owed to individuals. Use your best judgement on what to '
                        'include — if uncertain about specific cases, consult a scholar.',
                  ),
                  const SizedBox(height: 24),
                  CurrencyInputField(
                    label: 'Total debts you owe to others',
                    initialValue: _debtsOwed,
                    onChanged: (v) => _debtsOwed = v,
                    prefixIcon: Icons.remove_circle_outline,
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
