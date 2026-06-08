# SpendSmart 💸

A production-quality **Flutter expense tracker** app — fully offline, beautifully animated, with deep analytics powered by fl_chart.

---

## Screenshots

> Dashboard · Transactions · Analytics · Add Expense

| Dashboard | Transactions | Analytics | Add Expense |
|-----------|-------------|-----------|-------------|
| Balance hero card, weekly bar chart, category pie chart, recent transactions | Search + filter chips, date-grouped list, swipe-to-delete with undo | Line chart trend, category breakdown with progress bars, monthly comparison | Income/expense toggle, big amount input, category chips, date picker |

---

## Features

- **Dashboard** — greeting, month navigator (← June 2026 →), glassmorphism balance card showing total balance / income / expenses, weekly bar chart, category donut pie chart, recent 5 transactions
- **Transactions** — full searchable list with category filter chips, date group headers (Today / Yesterday / June 5…), swipe-to-delete with undo snackbar
- **Analytics** — Week / Month / Year tabs, smooth curved line chart, category breakdown with animated progress bars, 2×2 top stats grid, this-month vs last-month comparison
- **Add Expense** — bottom sheet with expense/income toggle, large ₹ amount input, horizontal category chips, calendar date picker, optional note field, gradient save button with haptic feedback
- **Fully offline** — all data stored locally with Hive (no backend, no internet required)
- **Light + Dark mode** — complete Poppins-font theme for both
- **Smooth animations** — flutter_animate entrance effects on every card, chart, and list tile

---

## Tech Stack

| Package | Purpose |
|---------|---------|
| `hive` + `hive_flutter` | Local key-value persistence |
| `fl_chart` | Bar chart, pie/donut chart, line chart |
| `provider` | Global state management (ChangeNotifier) |
| `intl` | Indian Rupee (₹) currency & date formatting |
| `uuid` | Unique IDs per transaction |
| `google_fonts` | Poppins font throughout |
| `flutter_animate` | Entrance animations on cards, charts, tiles |
| `iconsax` | Beautiful outline icons |

---

## Project Structure

```
lib/
├── main.dart                   # Hive init + runApp
├── app.dart                    # MaterialApp, Provider, theme, routes
├── models/
│   └── expense.dart            # Hive model: id, title, amount, category, date, note, isIncome
├── hive/
│   └── expense_adapter.dart    # Hand-written TypeAdapter (no build_runner needed)
├── providers/
│   └── expense_provider.dart   # CRUD + computed stats: totalIncome, byCategory, last7Days…
├── screens/
│   ├── home_screen.dart        # BottomNavigationBar tab controller
│   ├── dashboard_screen.dart   # Summary card + charts + recent list
│   ├── transactions_screen.dart# Search, filter, grouped list, swipe-delete
│   ├── add_expense_screen.dart # Bottom sheet form
│   └── stats_screen.dart       # Line chart + breakdown + comparison
├── widgets/
│   ├── summary_card.dart       # Gradient balance hero card
│   ├── category_chip.dart      # Animated pill selector
│   ├── expense_tile.dart       # Dismissible list tile
│   ├── bar_chart_widget.dart   # Weekly fl_chart BarChart
│   ├── pie_chart_widget.dart   # Category donut PieChart
│   ├── line_chart_widget.dart  # Trend LineChart
│   └── empty_state.dart        # Illustration + CTA
└── utils/
    ├── constants.dart          # Colors, category metadata (name / color / icon)
    ├── formatter.dart          # Currency (₹ en_IN) + date helpers
    └── theme.dart              # Light + dark ThemeData
```

---

## Categories

| Category | Color |
|----------|-------|
| Food & Drinks | `#FF6B6B` |
| Transport | `#4ECDC4` |
| Shopping | `#A78BFA` |
| Health | `#34D399` |
| Entertainment | `#FFBF24` |
| Bills | `#60A5FA` |
| Education | `#F472B6` |
| Salary *(income)* | `#2ECC71` |
| Other | `#94A3B8` |

---

## Getting Started

### Prerequisites

- Flutter 3.x SDK — [install guide](https://docs.flutter.dev/get-started/install)
- Dart SDK `^3.10.1`

### Run locally

```bash
git clone https://github.com/JAIN2309/SpendSmart_flutter.git
cd SpendSmart_flutter
flutter pub get
flutter run
```

> No `flutter pub run build_runner build` needed — the Hive TypeAdapter is hand-written.

### Build release APK

```bash
flutter build apk --release
```

---

## Dependencies

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  fl_chart: ^0.68.0
  provider: ^6.1.2
  intl: ^0.19.0
  uuid: ^4.3.3
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  iconsax: ^0.0.8

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.9
```

---

## Design System

| Token | Dark | Light |
|-------|------|-------|
| Background | `#0D1117` | `#F8FAFC` |
| Card | `#161B22` | `#FFFFFF` |
| Primary accent | `#6C63FF` | `#6C63FF` |
| Income | `#2ECC71` | `#2ECC71` |
| Expense | `#FF6B6B` | `#FF6B6B` |
| Font | Poppins | Poppins |
| Card radius | 16–20 px | 16–20 px |

---

## License

MIT © 2026 [JAIN2309](https://github.com/JAIN2309)
