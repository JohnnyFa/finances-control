import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_state.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finances_control/widget/main_bottom_nav.dart';

class EbooksPage extends StatelessWidget {
  const EbooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.appStrings.nav_ebooks),
      ),
      body: BlocBuilder<EbooksViewModel, EbooksState>(
        builder: (context, state) {
          if (state is EbooksLoading || state is EbooksInitial) {
            return Center(child: Text(context.appStrings.loading));
          }

          if (state is EbooksError) {
            return Center(child: Text(state.message));
          }

          if (state is! EbooksLoaded || state.ebooks.isEmpty) {
            return Center(child: Text(context.appStrings.no_data));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final book = state.ebooks[index];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title, style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemCount: state.ebooks.length,
          );
        },
      ),
      bottomNavigationBar: const MainBottomNav(currentIndex: 1),
    );
  }
}
