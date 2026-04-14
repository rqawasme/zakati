import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currencies.dart';
import '../../providers/zakat_provider.dart';
import '../../widgets/shared/app_toast.dart';
import '../../widgets/shared/zakati_app_bar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late CurrencyOption _selectedCurrency;
  late String _weightUnit;

  @override
  void initState() {
    super.initState();
    final s = ref.read(zakatProvider);
    _selectedCurrency = currencyByCode(s.currency);
    _weightUnit = s.weightUnit;
  }

  void _save() {
    ref.read(zakatProvider.notifier).setCurrency(
          _selectedCurrency.code,
          _selectedCurrency.symbol,
          _selectedCurrency.rateFromUSD,
        );
    ref.read(zakatProvider.notifier).setWeightUnit(_weightUnit);

    AppToast.show(context, 'Settings saved.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Settings'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Currency ───────────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.attach_money,
                    title: 'Currency',
                    subtitle:
                        'Applied to all monetary inputs and nisab thresholds.',
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<CurrencyOption>(
                    value: _selectedCurrency,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.divider),
                      ),
                    ),
                    items: kCurrencies
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              '${c.symbol}  ${c.name} (${c.code})',
                              style: AppTextStyles.body,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (c) {
                      if (c != null) setState(() => _selectedCurrency = c);
                    },
                  ),

                  const SizedBox(height: 28),

                  // ── Weight unit ────────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.scale_outlined,
                    title: 'Weight Unit',
                    subtitle:
                        'Used for gold and silver inputs throughout the app.',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _UnitButton(
                        label: 'Grams (g)',
                        selected: _weightUnit == 'g',
                        onTap: () => setState(() => _weightUnit = 'g'),
                      ),
                      const SizedBox(width: 12),
                      _UnitButton(
                        label: 'Troy oz',
                        selected: _weightUnit == 'oz',
                        onTap: () => setState(() => _weightUnit = 'oz'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Disclaimer ─────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(color: AppColors.accent, width: 3),
                      ),
                    ),
                    child: Text(
                      // TODO: Replace with live exchange rate API.
                      'Exchange rates are approximate and hardcoded. '
                      'Gold and silver prices are in USD and converted '
                      'to your selected currency using fixed rates.',
                      style: AppTextStyles.caption,
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
                onPressed: _save,
                child: const Text('Save Settings'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.headingSmall),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnitButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _UnitButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
