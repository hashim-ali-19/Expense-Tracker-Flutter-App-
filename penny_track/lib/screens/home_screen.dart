import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_tile.dart';
import '../widgets/empty_state.dart';
import 'add_expense_screen.dart';
import 'category_breakdown_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickDateRangeFilter(
      BuildContext context, ExpenseProvider provider) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: provider.filterDateRange,
    );
    if (range != null) {
      provider.setFilterDateRange(range);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final expenses = provider.expenses;
        final hasActiveFilters = provider.filterCategory != null &&
                provider.filterCategory != 'All' ||
            provider.filterDateRange != null;

        return Scaffold(
  appBar: AppBar(
  automaticallyImplyLeading: false,
  toolbarHeight: 90,
  elevation: 0,
  backgroundColor: Colors.transparent,
  flexibleSpace: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1565C0), // Royal Blue
          Color(0xFF42A5F5), // Sky Blue
        ],
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
    ),
  ),
  title: Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.account_balance_wallet_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      const SizedBox(width: 14),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Penny Track",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Track • Save • Grow",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  ),
  actions: [
    IconButton(
      tooltip: 'Category Breakdown',
      icon: const Icon(
        Icons.pie_chart_rounded,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CategoryBreakdownScreen(),
          ),
        );
      },
    ),
    IconButton(
      tooltip:
          provider.isDarkMode ? 'Light Theme' : 'Dark Theme',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          provider.isDarkMode
              ? Icons.wb_sunny_rounded
              : Icons.dark_mode_rounded,
          key: ValueKey(provider.isDarkMode),
          color: Colors.white,
        ),
      ),
      onPressed: provider.toggleTheme,
    ),
    const SizedBox(width: 8),
  ],
),
          body: Column(
            children: [
              SummaryCard(
                total: provider.totalBalance,
                expenseCount: expenses.length,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: provider.filterCategory ?? 'All',
                        isDense: true,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.filter_alt_rounded),
                        ),
                        items: ['All', ...kExpenseCategories]
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (value) =>
                            provider.setFilterCategory(value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'Filter by date range',
                      icon: const Icon(Icons.date_range_rounded),
                      onPressed: () =>
                          _pickDateRangeFilter(context, provider),
                    ),
                    if (hasActiveFilters) ...[
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Clear filters',
                        icon: const Icon(Icons.filter_alt_off_rounded),
                        onPressed: provider.clearFilters,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: expenses.isEmpty
                    ? EmptyState(isFiltered: hasActiveFilters)
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 88),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final Expense expense = expenses[index];
                          return TweenAnimationBuilder<double>(
                            key: ValueKey('anim-${expense.id}'),
                            tween: Tween(begin: 0, end: 1),
                            duration:
                                Duration(milliseconds: 260 + (index * 30).clamp(0, 300)),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - value) * 16),
                                  child: child,
                                ),
                              );
                            },
                            child: ExpenseTile(
                              expense: expense,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddExpenseScreen(
                                      existingExpense: expense,
                                    ),
                                  ),
                                );
                              },
                              onDelete: () =>
                                  provider.deleteExpense(expense.id),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddExpenseScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add expense'),
          ),
        );
      },
    );
  }
}
