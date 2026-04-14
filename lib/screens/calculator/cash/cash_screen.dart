import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';
import '../../../widgets/shared/currency_input_field.dart';

class CashScreen extends ConsumerStatefulWidget {
  const CashScreen({super.key});

  @override
  ConsumerState<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends ConsumerState<CashScreen> {
  late double _cashBank;
  late double _cashInHand;

  @override
  void initState() {
    super.initState();
    final s = ref.read(zakatProvider);
    _cashBank = s.cashBank;
    _cashInHand = s.cashInHand;
  }

  void _onContinue() {
    final notifier = ref.read(zakatProvider.notifier);
    notifier.setCashBank(_cashBank);
    notifier.setCashInHand(_cashInHand);
    context.push('/calculator/jewellery');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Cash & Savings'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 4, totalSteps: 11),
                  const SizedBox(height: 20),
                  const EducationCard(
                    text:
                        'All liquid cash is zakatable. This includes money in bank accounts, '
                        'savings accounts, and physical cash on hand. Convert any foreign currency '
                        'to your local currency at the current exchange rate before entering.',
                  ),
                  const SizedBox(height: 24),
                  CurrencyInputField(
                    label: 'Cash in bank accounts',
                    initialValue: _cashBank,
                    onChanged: (v) => _cashBank = v,
                    prefixIcon: Icons.account_balance,
                  ),
                  const SizedBox(height: 16),
                  CurrencyInputField(
                    label: 'Cash in hand / physical cash',
                    initialValue: _cashInHand,
                    onChanged: (v) => _cashInHand = v,
                    prefixIcon: Icons.wallet,
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
