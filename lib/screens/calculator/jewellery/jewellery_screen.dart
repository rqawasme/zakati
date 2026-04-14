import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/jewellery_item.dart';
import '../../../providers/zakat_provider.dart';
import '../../../widgets/shared/education_card.dart';
import '../../../widgets/shared/step_progress_bar.dart';
import '../../../widgets/shared/zakati_app_bar.dart';

const _uuid = Uuid();

class JewelleryScreen extends ConsumerStatefulWidget {
  const JewelleryScreen({super.key});

  @override
  ConsumerState<JewelleryScreen> createState() => _JewelleryScreenState();
}

class _JewelleryScreenState extends ConsumerState<JewelleryScreen> {
  late List<JewelleryItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(ref.read(zakatProvider).jewelleryItems);
  }

  void _addItem() {
    setState(() {
      _items.add(JewelleryItem(
        id: _uuid.v4(),
        label: '',
        material: 'gold',
        weightGrams: 0,
        purityPercent: 75,
        purpose: 'beautification',
      ));
    });
  }

  void _removeItem(String id) =>
      setState(() => _items.removeWhere((i) => i.id == id));

  void _updateItem(JewelleryItem updated) {
    setState(() {
      final idx = _items.indexWhere((i) => i.id == updated.id);
      if (idx != -1) _items[idx] = updated;
    });
  }

  void _onContinue() {
    final notifier = ref.read(zakatProvider.notifier);
    // Sync all items
    final current = ref.read(zakatProvider).jewelleryItems;
    // Remove all then re-add from local state
    for (final item in current) {
      notifier.removeJewelleryItem(item.id);
    }
    for (final item in _items) {
      notifier.addJewelleryItem(item);
    }
    context.push('/calculator/investments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Jewellery'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 5, totalSteps: 11),
                  const SizedBox(height: 20),
                  const EducationCard(
                    text:
                        'In the Maliki madhab, jewellery worn regularly for personal beautification '
                        'is generally exempt from Zakat. Jewellery purchased or held as an investment '
                        'is zakatable. For mixed pieces, use your best judgement on the primary purpose.',
                  ),
                  const SizedBox(height: 24),

                  if (_items.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No jewellery items added.\nTap "+ Add Item" if applicable.',
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  ..._items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _JewelleryItemCard(
                          item: item,
                          onUpdate: _updateItem,
                          onRemove: () => _removeItem(item.id),
                        ),
                      )),

                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 48),
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

class _JewelleryItemCard extends StatefulWidget {
  final JewelleryItem item;
  final ValueChanged<JewelleryItem> onUpdate;
  final VoidCallback onRemove;

  const _JewelleryItemCard({
    required this.item,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<_JewelleryItemCard> createState() => _JewelleryItemCardState();
}

class _JewelleryItemCardState extends State<_JewelleryItemCard> {
  late TextEditingController _labelCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _purityCtrl;
  late String _material;
  late String _purpose;

  static const _purityPresets = [
    _PurityPreset('24k', 99.9),
    _PurityPreset('22k', 91.7),
    _PurityPreset('18k', 75.0),
    _PurityPreset('14k', 58.3),
  ];

  @override
  void initState() {
    super.initState();
    _labelCtrl = TextEditingController(text: widget.item.label);
    _weightCtrl = TextEditingController(
        text: widget.item.weightGrams == 0
            ? ''
            : widget.item.weightGrams.toString());
    _purityCtrl = TextEditingController(
        text: widget.item.purityPercent.toString());
    _material = widget.item.material;
    _purpose = widget.item.purpose;
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _weightCtrl.dispose();
    _purityCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onUpdate(widget.item.copyWith(
      label: _labelCtrl.text,
      material: _material,
      weightGrams: double.tryParse(_weightCtrl.text) ?? 0,
      purityPercent: double.tryParse(_purityCtrl.text) ?? 0,
      purpose: _purpose,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isInvestment = _purpose == 'investment';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Jewellery Item',
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textSecondary)),
              ),
              // Purpose badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: isInvestment
                      ? AppColors.accentLight
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isInvestment ? 'Zakatable' : 'Exempt (Maliki)',
                  style: AppTextStyles.caption.copyWith(
                    color: isInvestment
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 20),
                onPressed: widget.onRemove,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Label
          TextFormField(
            controller: _labelCtrl,
            onChanged: (_) => _notify(),
            style: AppTextStyles.body,
            decoration: InputDecoration(
              labelText: 'Item label (e.g. Gold necklace)',
              labelStyle: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),

          // Material
          Text('Material', style: AppTextStyles.label),
          const SizedBox(height: 6),
          _SegmentedRow(
            options: const ['gold', 'silver'],
            labels: const ['Gold', 'Silver'],
            selected: _material,
            onChanged: (v) {
              setState(() => _material = v);
              _notify();
            },
          ),
          const SizedBox(height: 12),

          // Weight
          TextFormField(
            controller: _weightCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
            ],
            onChanged: (_) => _notify(),
            style: AppTextStyles.body,
            decoration: InputDecoration(
              labelText: 'Weight (grams)',
              suffixText: 'g',
              labelStyle: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),

          // Purity
          TextFormField(
            controller: _purityCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
            ],
            onChanged: (_) => _notify(),
            style: AppTextStyles.body,
            decoration: InputDecoration(
              labelText: 'Purity (%)',
              suffixText: '%',
              labelStyle: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 8),

          // Purity presets
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _purityPresets
                .map((p) => GestureDetector(
                      onTap: () {
                        setState(
                            () => _purityCtrl.text = p.value.toString());
                        _notify();
                      },
                      child: Chip(
                        label: Text(p.label,
                            style: AppTextStyles.caption
                                .copyWith(fontSize: 11)),
                        backgroundColor: AppColors.primaryLight,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),

          // Purpose
          Text('Purpose', style: AppTextStyles.label),
          const SizedBox(height: 6),
          _SegmentedRow(
            options: const ['beautification', 'investment'],
            labels: const ['Beautification', 'Investment'],
            selected: _purpose,
            onChanged: (v) {
              setState(() => _purpose = v);
              _notify();
            },
          ),
        ],
      ),
    );
  }
}

class _SegmentedRow extends StatelessWidget {
  final List<String> options;
  final List<String> labels;
  final String selected;
  final ValueChanged<String> onChanged;

  const _SegmentedRow({
    required this.options,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (i) {
        final isSelected = options[i] == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(options[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.only(right: i < options.length - 1 ? 8 : 0),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[i],
                style: AppTextStyles.label.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _PurityPreset {
  final String label;
  final double value;
  const _PurityPreset(this.label, this.value);
}
