import 'package:flutter/material.dart';
import 'coin_bot_mascot.dart';

/// Placeholder shown when there are no expenses to display, either
/// because none exist yet or because the active filters exclude
/// everything. Built around the app's coin-bot mascot with a gentle
/// floating animation instead of a generic icon.
class EmptyState extends StatefulWidget {
  final bool isFiltered;

  const EmptyState({super.key, this.isFiltered = false});

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _float = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _float,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _float.value),
                  child: child,
                );
              },
              child: CoinBotMascot(size: 130, idle: widget.isFiltered),
            ),
            const SizedBox(height: 20),
            Text(
              widget.isFiltered
                  ? 'No matches found'
                  : 'Nothing tracked yet',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.isFiltered
                  ? 'Clear your filters to see everything again.'
                  : 'Tap the + button to log your first expense.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
