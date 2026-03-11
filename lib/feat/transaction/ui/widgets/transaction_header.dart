import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class TransactionHeader extends StatelessWidget {
  final String query;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onImportCsvPressed;
  final VoidCallback onBackPressed;

  const TransactionHeader({
    super.key,
    required this.query,
    required this.searchController,
    required this.onQueryChanged,
    required this.onImportCsvPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.appStrings.transactions,
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        context.appStrings.recurring_transactions,
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onImportCsvPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.onPrimary.withValues(alpha: 0.18),
                  foregroundColor: scheme.onPrimary,
                ),
                icon: const Icon(Icons.upload_file_rounded),
                label: Text(context.appStrings.upload_csv),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              onChanged: onQueryChanged,
              cursorColor: scheme.primary,
              style: TextStyle(color: scheme.onSurface),
              decoration: InputDecoration(
                hintText: context.appStrings.description,
                hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6)),
                prefixIcon: const Icon(Icons.search_rounded),
                prefixIconColor: scheme.onSurface.withValues(alpha: 0.7),
                filled: true,
                fillColor: scheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          searchController.clear();
                          onQueryChanged('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
