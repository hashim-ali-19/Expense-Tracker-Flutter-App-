import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../utils/category_style.dart';
import '../widgets/coin_bot_mascot.dart';

/// Shows total spending per category as a donut chart with the grand
/// total nested in the middle, plus a colour-matched list underneath.
class CategoryBreakdownScreen extends StatelessWidget {
  const CategoryBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Category breakdown')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, _) {
          final totals = provider.categoryTotals;

          if (totals.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CoinBotMascot(size: 110),
                  const SizedBox(height: 16),
                  Text(
                    'No data yet — add some expenses first!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          final entries = totals.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final grandTotal = totals.values.fold(0.0, (a, b) => a + b);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 62,
                        sections: List.generate(entries.length, (i) {
                          final entry = entries[i];
                          final percent = (entry.value / grandTotal) * 100;
                          return PieChartSectionData(
                            color: CategoryStyle.colorFor(entry.key),
                            value: entry.value,
                            title: '${percent.toStringAsFixed(0)}%',
                            radius: 62,
                            titleStyle: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.inkLight,
                            ),
                          );
                        }),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Text(
                          currency.format(grandTotal),
                          style: GoogleFonts.rubik(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ...List.generate(entries.length, (i) {
                final entry = entries[i];
                final percent = (entry.value / grandTotal) * 100;
                final color = CategoryStyle.colorFor(entry.key);
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CategoryStyle.iconFor(entry.key),
                        size: 20,
                        color: AppColors.inkLight,
                      ),
                    ),
                    title: Text(
                      entry.key,
                      style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('${percent.toStringAsFixed(1)}% of total'),
                    trailing: Text(
                      currency.format(entry.value),
                      style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
