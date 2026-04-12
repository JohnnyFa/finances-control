import 'package:finances_control/core/analytics/analytics_service.dart';
import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/ebooks/ui/components/ebooks_card.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_state.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EbooksBody extends StatefulWidget {
  const EbooksBody({super.key});

  @override
  State<EbooksBody> createState() => _EbooksBodyState();
}
class _EbooksBodyState extends State<EbooksBody> {
  bool _hasTrackedBooksView = false;

  @override
  void initState() {
    super.initState();

    final vm = context.read<EbooksViewModel>();


    if (vm.state is! EbooksLoaded) {
      vm.load();
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EbooksViewModel, EbooksState>(
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

        if (!_hasTrackedBooksView) {
          _hasTrackedBooksView = true;
          getIt<AnalyticsService>().trackViewBooks();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.ebooks.length,
          itemBuilder: (context, index) {
            final ebook = state.ebooks[index];


            return EbookCard(
              key: Key('${ebook.title}-${ebook.author}'),
              ebook: ebook,
            );
          },
        );
      },
    );
  }
}
