import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Central place mapping each category to its icon + pastel color,
/// so the Home list, Add screen chips, and breakdown chart all agree.
class CategoryStyle {
  static IconData iconFor(String category) {
    switch (category) {
      case 'Food':
        return Icons.icecream_rounded;
      case 'Transport':
        return Icons.directions_bus_filled_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Bills':
        return Icons.receipt_long_rounded;
      case 'Entertainment':
        return Icons.theater_comedy_rounded;
      case 'Health':
        return Icons.favorite_rounded;
      case 'Education':
        return Icons.auto_stories_rounded;
      default:
        return Icons.celebration_rounded;
    }
  }

  static Color colorFor(String category) => AppColors.categoryColor(category);
}
