import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';

/// Central state manager for expenses + app theme.
///
/// Screens/widgets read from this via Provider/Consumer instead of
/// talking to StorageService directly, keeping persistence details
/// out of the UI layer.
class ExpenseProvider extends ChangeNotifier {
  final StorageService _storageService;
  final _uuid = const Uuid();

  List<Expense> _expenses = [];
  bool _isDarkMode = false;

  // Optional filters (bonus feature)
  String? _filterCategory;
  DateTimeRange? _filterDateRange;

  ExpenseProvider(this._storageService) {
    _loadExpenses();
    _isDarkMode = _storageService.getIsDarkMode();
  }

  bool get isDarkMode => _isDarkMode;
  String? get filterCategory => _filterCategory;
  DateTimeRange? get filterDateRange => _filterDateRange;

  void _loadExpenses() {
    _expenses = _storageService.getAllExpenses();
    _sortNewestFirst();
  }

  void _sortNewestFirst() {
    _expenses.sort((a, b) => b.date.compareTo(a.date));
  }

  /// All expenses, newest first, with any active filters applied.
  List<Expense> get expenses {
    var list = List<Expense>.from(_expenses);

    if (_filterCategory != null && _filterCategory != 'All') {
      list = list.where((e) => e.category == _filterCategory).toList();
    }

    if (_filterDateRange != null) {
      list = list.where((e) {
        final d = DateTime(e.date.year, e.date.month, e.date.day);
        final start = DateTime(_filterDateRange!.start.year,
            _filterDateRange!.start.month, _filterDateRange!.start.day);
        final end = DateTime(_filterDateRange!.end.year,
            _filterDateRange!.end.month, _filterDateRange!.end.day);
        return !d.isBefore(start) && !d.isAfter(end);
      }).toList();
    }

    return list;
  }

  double get totalBalance =>
      expenses.fold(0.0, (sum, e) => sum + e.amount);

  /// category -> total spent, for breakdown screen / chart.
  Map<String, double> get categoryTotals {
    final Map<String, double> totals = {};
    for (final e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  Future<void> addExpense({
    required double amount,
    required String category,
    required DateTime date,
    String note = '',
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      amount: amount,
      category: category,
      date: date,
      note: note,
    );
    await _storageService.addExpense(expense);
    _expenses.add(expense);
    _sortNewestFirst();
    notifyListeners();
  }

  Future<void> updateExpense(Expense updated) async {
    await _storageService.updateExpense(updated);
    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _expenses[index] = updated;
    }
    _sortNewestFirst();
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await _storageService.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void setFilterCategory(String? category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setFilterDateRange(DateTimeRange? range) {
    _filterDateRange = range;
    notifyListeners();
  }

  void clearFilters() {
    _filterCategory = null;
    _filterDateRange = null;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }
}
