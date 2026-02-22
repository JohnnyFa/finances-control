import 'package:finances_control/feat/open_finance/vm/open_finance_state.dart';
import 'package:finances_control/feat/open_finance/vm/open_finance_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenFinancePage extends StatefulWidget {
  const OpenFinancePage({super.key});

  @override
  State<OpenFinancePage> createState() => _OpenFinancePageState();
}

class _OpenFinancePageState extends State<OpenFinancePage> {
  final _bankController = TextEditingController();
  final _accountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OpenFinanceViewModel>().load();
  }

  @override
  void dispose() {
    _bankController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Finance')),
      body: BlocConsumer<OpenFinanceViewModel, OpenFinanceState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
            context.read<OpenFinanceViewModel>().clearMessage();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _bankController,
                  decoration: const InputDecoration(labelText: 'Bank name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _accountController,
                  decoration: const InputDecoration(labelText: 'Account (masked)'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final bankName = _bankController.text.trim();
                      final account = _accountController.text.trim();
                      if (bankName.isEmpty || account.isEmpty) return;

                      await context.read<OpenFinanceViewModel>().connectBank(bankName, account);
                      _bankController.clear();
                      _accountController.clear();
                    },
                    child: const Text('Connect bank'),
                  ),
                ),
                const SizedBox(height: 20),
                if (state.status == OpenFinanceStatus.loading)
                  const CircularProgressIndicator()
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.connections.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final connection = state.connections[index];
                        return ListTile(
                          title: Text(connection.bankName),
                          subtitle: Text(connection.accountMasked),
                          trailing: IconButton(
                            tooltip: 'Sync payments',
                            icon: const Icon(Icons.sync),
                            onPressed: connection.id == null
                                ? null
                                : () async {
                                    await context.read<OpenFinanceViewModel>().sync(connection.id!);
                                  },
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
