import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../../onboarding/ui/widgets/app_text_field.dart';
import '../vm/financial_settings_state.dart';
import '../vm/financial_settings_vm.dart';

class FinancialSettingsBody extends StatefulWidget {
  const FinancialSettingsBody({super.key});

  @override
  State<FinancialSettingsBody> createState() => _FinancialSettingsBodyState();
}

class _FinancialSettingsBodyState extends State<FinancialSettingsBody> {

  final salaryController = TextEditingController();
  final savingsController = TextEditingController();

  @override
  void dispose() {
    salaryController.dispose();
    savingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      child: ColoredBox(
        color: scheme.surface,
        child: BlocListener<FinancialSettingsViewModel, FinancialSettingsState>(
          listener: (context, state) {

            if (state is FinancialSettingsError) {
              String errorMessage;
              switch (state.errorType) {
                case FinancialSettingsErrorType.loadFailed:
                  errorMessage = context.appStrings.error_load_financial_data;
                  break;
                case FinancialSettingsErrorType.saveFailed:
                  errorMessage = context.appStrings.error_save_financial_data;
                  break;
                case FinancialSettingsErrorType.salaryGreaterThanZero:
                  errorMessage = context.appStrings.error_salary_greater_than_zero;
                  break;
                case FinancialSettingsErrorType.savingsGreaterThanZero:
                  errorMessage = context.appStrings.error_savings_greater_than_zero;
                  break;
              }
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            }

            if (state is FinancialSettingsLoaded) {

              salaryController.text =
                  (state.salary / 100).toStringAsFixed(2);

              savingsController.text =
                  (state.amountToSave / 100).toStringAsFixed(2);
            }
          },
          child: BlocBuilder<FinancialSettingsViewModel, FinancialSettingsState>(
            builder: (context, state) {

              if (state is FinancialSettingsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FinancialSettingsLoaded) {
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [

                    /// SALARY
                    AppTextField(
                      hintText: "R\$ 0,00",
                      controller: salaryController,
                      inputFormatters: [CurrencyInputFormatter()],
                      prefixIcon: const Icon(Icons.payments_outlined),
                      textAlign: TextAlign.center,
                      onChanged: (value) {

                        final cents =
                            int.tryParse(toNumericString(value)) ?? 0;

                        context
                            .read<FinancialSettingsViewModel>()
                            .updateSalary(cents);
                      },
                    ),

                    const SizedBox(height: 20),

                    /// SAVINGS GOAL
                    AppTextField(
                      hintText: "R\$ 0,00",
                      controller: savingsController,
                      inputFormatters: [CurrencyInputFormatter()],
                      prefixIcon: const Icon(Icons.savings_outlined),
                      textAlign: TextAlign.center,
                      onChanged: (value) {

                        final cents =
                            int.tryParse(toNumericString(value)) ?? 0;

                        context
                            .read<FinancialSettingsViewModel>()
                            .updateSavings(cents);
                      },
                    ),

                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: () {
                        context.read<FinancialSettingsViewModel>().save();
                        Navigator.pop(context);
                      },
                      child: Text(context.appStrings.save),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}