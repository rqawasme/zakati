import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/zakat_run.dart';
import '../../providers/runs_provider.dart';
import '../../widgets/shared/zakati_app_bar.dart';

class SavedRunsScreen extends ConsumerWidget {
  const SavedRunsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runs = ref.watch(runsProvider);

    return Scaffold(
      appBar: const ZakatiAppBar(title: 'Past Calculations'),
      body: runs.isEmpty
          ? _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              itemCount: runs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final run = runs[index];
                return _RunTile(
                  run: run,
                  onTap: () => context.push('/runs/${run.id}'),
                  onDelete: () =>
                      ref.read(runsProvider.notifier).deleteRun(run.id),
                );
              },
            ),
    );
  }
}

class _RunTile extends StatelessWidget {
  final ZakatRun run;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _RunTile({
    required this.run,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('MMMM d, yyyy — h:mm a').format(run.createdAt);
    final statusColor =
        run.metNisab ? AppColors.primary : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
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
            // Status dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateLabel, style: AppTextStyles.label),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Madhab badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _capitalize(run.madhab),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        run.metNisab
                            ? CurrencyFormatter.format(run.zakatDue)
                            : 'Below Nisab',
                        style: AppTextStyles.caption.copyWith(
                          color: run.metNisab
                              ? AppColors.accent
                              : AppColors.textSecondary,
                          fontWeight: run.metNisab
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delete icon
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.error, size: 20),
              onPressed: () => _confirmDelete(context),
              visualDensity: VisualDensity.compact,
            ),

            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Run'),
        content: const Text('Are you sure you want to delete this saved run?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) onDelete();
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history, size: 48, color: AppColors.divider),
          const SizedBox(height: 12),
          Text('No saved calculations yet.',
              style: AppTextStyles.body
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('Complete a calculation to save it here.',
              style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
