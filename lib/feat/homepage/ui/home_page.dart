import 'package:finances_control/widget/custom_text.dart';
import 'package:finances_control/widget/month_year_selector.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

@override
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Add ");
          },
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: Column(
            children: [
              MonthYearSelector(),
              _balance(context),
              _expensesPerCategory(context),
            ],
          ),
        ),
      ),
    );
  }

  Container _balance(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Color(0xFF7B3FF6), Color(0xFF4E8CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 12),
          CustomText(
            description: "SALDO DO MÊS",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          SizedBox(height: 8),
          CustomText(
            description: "⚖️ R\$ 0,00",
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D7BFF), Color(0xFF7B3FF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: const [
                      CustomText(
                        description: "📈 Income",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      CustomText(
                        description: "R\$ 0,00",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D7BFF), Color(0xFF7B3FF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: const [
                      CustomText(
                        description: "📉 Expenses",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      CustomText(
                        description: "R\$ 0,00",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            child: Center(
              child: const CustomText(
                description: "🎉Economia: + R\$ 0,00",
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Container _expensesPerCategory(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CustomText(
                description: "📊 Expenses per category",
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
