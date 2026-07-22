# Penny Track (Flutter & Dart)

A complete, local-first expense tracker built purely in Flutter/Dart for the
Weekly Flutter Development Task.

## Features Implemented

### Core (required)
- **Add Expense screen** — amount, category (dropdown), date (date picker), optional note, with full input validation (no empty/negative/zero amounts).
- **Home / Dashboard screen** — scrollable list of expenses (newest first) with a running total balance summary card at the top.
- **Edit / Delete** — tap an expense to edit it; swipe left to delete, with a confirmation dialog.
- **Category breakdown** — dedicated screen with both a pie chart and a sorted list of totals per category.
- **Local persistence** — all data stored on-device with **Hive**, so expenses survive app restarts. No backend/server involved.
- **Empty state** — friendly message + icon shown when there are no expenses (or none match the active filters).
- **Input validation** — amount must be a valid number greater than zero; form won't submit otherwise.

### Bonus
- **Light / Dark theme switching** — toggle button in the app bar, preference persisted locally.
- **Pie chart category breakdown** — via `fl_chart`.
- **Filter by category and/or date range** — filter controls on the Home screen, with a "clear filters" action.

## Packages Used
| Package | Purpose |
|---|---|
| `hive` / `hive_flutter` | Local, typed on-device storage for expenses and settings |
| `provider` | State management (`ExpenseProvider` as a `ChangeNotifier`) |
| `fl_chart` | Donut chart on the Category Breakdown screen |
| `intl` | Currency and date formatting |
| `uuid` | Unique IDs for each expense |
| `google_fonts` | Bold, modern typography (Rubik / Inter / Space Grotesk) |

## Design System — "Penny Track"

A sharp, tech-flavored identity — deep navy and electric blue with a
teal/amber accent pair, meant to feel like a focused little utility app:

- **Palette** — electric blue (`#3A86FF`) as the hero color, teal
  (`#06D6A0`) and amber (`#FF9F1C`) as supporting accents, on a cool
  light-grey background (`#F1F5F9`) / deep navy in dark mode (`#11151C`).
  Each of the 8 categories gets its own distinct color (amber, blue,
  purple, slate, rose, teal, cyan, grey) reused consistently across the
  list, the Add-expense chips, and the breakdown chart.
- **Typography** — **Rubik** for headings and buttons (bold, slightly
  angular), **Inter** for body text, **Space Grotesk** for money amounts.
- **Signature element** — a small coin-slot robot mascot
  (`widgets/coin_bot_mascot.dart`), built entirely with `CustomPainter`
  shapes rather than an image asset. It appears on the empty state (with
  a gentle floating animation) and peeks out of the summary card.
- **Motion** — the expense list fades and slides in with a light stagger
  per item, the empty-state mascot floats continuously, and cards use
  soft shadows instead of hard Material elevation.
- **Voice** — copy stays clean and direct, focused on the task at hand.

## Project Structure
```
lib/
  models/       -> Expense data model + Hive adapter
  services/     -> StorageService (Hive read/write wrapper)
  providers/    -> ExpenseProvider (state management, filters, theme)
  theme/        -> AppTheme + AppColors design tokens
  utils/        -> CategoryStyle (category -> icon/color mapping)
  screens/      -> HomeScreen, AddExpenseScreen, CategoryBreakdownScreen
  widgets/      -> SummaryCard, ExpenseTile, EmptyState, CoinBotMascot
  main.dart     -> App entry point, theme setup, provider wiring
```

## Getting Started

1. Make sure you have the Flutter SDK (stable channel) installed.
2. From the project root:
   ```bash
   flutter pub get
   flutter run
   ```
3. To build a release APK:
   ```bash
   flutter build apk --release
   ```
   The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

## Notes
- The Hive `TypeAdapter` for `Expense` is written by hand (no `build_runner`
  needed), so the project builds immediately after `flutter pub get`.
- State management uses `provider` (per the task's acceptable options); no
  external backend or server-side technology is used anywhere.
- Tested against Material 3 widgets for a clean, responsive layout across
  screen sizes.
