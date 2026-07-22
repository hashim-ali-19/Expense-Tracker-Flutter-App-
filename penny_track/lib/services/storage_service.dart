import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

/// Handles all local persistence for expenses using Hive.
///
/// Hive was chosen over SharedPreferences/sqflite because it stores
/// typed Dart objects directly with very little boilerplate, while
/// still being fully local, fast, and offline.
class StorageService {
  static const String expenseBoxName = 'expenses_box';
  static const String settingsBoxName = 'settings_box';
  static const String themeKey = 'isDarkMode';

  late Box<Expense> _expenseBox;
  late Box _settingsBox;

  /// Call once in main() before runApp().
  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ExpenseAdapter());
    }
    _expenseBox = await Hive.openBox<Expense>(expenseBoxName);
    _settingsBox = await Hive.openBox(settingsBoxName);
  }

  Box<Expense> get expenseBox => _expenseBox;

  List<Expense> getAllExpenses() {
    return _expenseBox.values.toList();
  }

  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  Future<void> updateExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }

  // --- Theme persistence ---

  bool getIsDarkMode() {
    return _settingsBox.get(themeKey, defaultValue: false) as bool;
  }

  Future<void> setIsDarkMode(bool value) async {
    await _settingsBox.put(themeKey, value);
  }
}
