import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/currency_input_field.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

class DebtsReceivableScreen extends ConsumerStatefulWidget {
  const DebtsReceivableScreen({super.key});

  @override
  ConsumerState<DebtsReceivableScreen> createState() =>
      _DebtsReceivableScreenState();
}

class _DebtsReceivableScreenState extends ConsumerState<DebtsReceivableScreen> {
  late double _debtsReceivable;

  @override
  void initState() {
    super.initState();
    _debtsReceivable = ref.read(zakatProvider).debtsReceivable;
  }

  void _onContinue() {
    ref.read(zakatProvider.notifier).setDebtsReceivable(_debtsReceivable);
    context.push('/calculator/large-liabilities');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Debts Owed to You'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 9, totalSteps: 11),
                  const SizedBox(height: 20),
                  const EducationCard(
                    text:
                        'Money that others owe you and that you reasonably expect to recover is '
                        'part of your zakatable wealth in the Maliki madhab. Only include amounts '
                        'you are confident will be returned. Debts unlikely to be recovered are '
                        'generally excluded.',
                  ),
                  const SizedBox(height: 24),
                  CurrencyInputField(
                    label: 'Total recoverable debts owed to you',
                    initialValue: _debtsReceivable,
                    onChanged: (v) => _debtsReceivable = v,
                    prefixIcon: Icons.add_circle_outline,
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
