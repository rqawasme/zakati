import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/zakat_provider.dart';

/// Monetary input field. Reads currency symbol from [zakatProvider].
class CurrencyInputField extends ConsumerStatefulWidget {
  final String label;
  final double initialValue;
  final ValueChanged<double> onChanged;
  final Color? labelColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;

  const CurrencyInputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue = 0,
    this.labelColor,
    this.prefixIcon,
    this.prefixIconColor,
  });

  @override
  ConsumerState<CurrencyInputField> createState() => _CurrencyInputFieldState();
}

class _CurrencyInputFieldState extends ConsumerState<CurrencyInputField> {
  late final TextEditingController _ctrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    final initial =
        widget.initialValue == 0 ? '' : widget.initialValue.toString();
    _ctrl = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.isEmpty) {
      setState(() => _error = null);
      widget.onChanged(0);
      return;
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      setState(() => _error = 'Enter a valid number');
      return;
    }
    if (parsed < 0) {
      setState(() => _error = 'Value cannot be negative');
      return;
    }
    setState(() => _error = null);
    widget.onChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final symbol = ref.watch(zakatProvider).currencySymbol;
    return TextFormField(
      controller: _ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: _onChanged,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: AppTextStyles.label.copyWith(
          color: widget.labelColor ?? AppColors.textSecondary,
        ),
        prefixText: '$symbol ',
        prefixStyle:
            AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon,
                color: widget.prefixIconColor ?? AppColors.textSecondary,
                size: 20)
            : null,
        errorText: _error,
      ),
    );
  }
}

/// Weight input field — suffix switches between 'g' and 'oz'
/// based on [zakatProvider].weightUnit.
class WeightInputField extends ConsumerStatefulWidget {
  final String label;
  final double initialValue; // always in grams internally
  final ValueChanged<double> onChanged; // always returns grams
  final Color? labelColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;

  const WeightInputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue = 0,
    this.labelColor,
    this.prefixIcon,
    this.prefixIconColor,
  });

  @override
  ConsumerState<WeightInputField> createState() => _WeightInputFieldState();
}

class _WeightInputFieldState extends ConsumerState<WeightInputField> {
  late final TextEditingController _ctrl;
  String? _error;

  static const _troyOzToGrams = 31.1035;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: _displayValue(widget.initialValue));
  }

  String _displayValue(double grams) {
    if (grams == 0) return '';
    final unit = ref.read(zakatProvider).weightUnit;
    final display = unit == 'oz' ? grams / _troyOzToGrams : grams;
    return display.toStringAsFixed(unit == 'oz' ? 4 : 2)
        .replaceAll(RegExp(r'\.?0+$'), '');
  }

  void _onChanged(String value) {
    if (value.isEmpty) {
      setState(() => _error = null);
      widget.onChanged(0);
      return;
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      setState(() => _error = 'Enter a valid number');
      return;
    }
    if (parsed < 0) {
      setState(() => _error = 'Value cannot be negative');
      return;
    }
    setState(() => _error = null);
    final unit = ref.read(zakatProvider).weightUnit;
    final grams = unit == 'oz' ? parsed * _troyOzToGrams : parsed;
    widget.onChanged(grams);
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(zakatProvider).weightUnit;
    return TextFormField(
      controller: _ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: _onChanged,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: AppTextStyles.label.copyWith(
          color: widget.labelColor ?? AppColors.textSecondary,
        ),
        suffixText: unit,
        suffixStyle:
            AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon,
                color: widget.prefixIconColor ?? AppColors.textSecondary,
                size: 20)
            : null,
        errorText: _error,
      ),
    );
  }
}
