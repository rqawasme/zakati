import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CurrencyInputField extends StatefulWidget {
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
  State<CurrencyInputField> createState() => _CurrencyInputFieldState();
}

class _CurrencyInputFieldState extends State<CurrencyInputField> {
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
        prefixText: '\$ ',
        // TODO: Add currency selection dropdown to WelcomeScreen. Default CAD.
        // Store selected currency in ZakatCalculationState. Apply currency
        // symbol as prefix to all monetary inputs. Convert nisab USD thresholds
        // to selected currency via exchange rate API.
        prefixStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
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

class WeightInputField extends StatefulWidget {
  final String label;
  final double initialValue;
  final ValueChanged<double> onChanged;
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
  State<WeightInputField> createState() => _WeightInputFieldState();
}

class _WeightInputFieldState extends State<WeightInputField> {
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
        suffixText: 'g',
        suffixStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
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
