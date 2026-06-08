<div align="center">

<img src="https://raw.githubusercontent.com/JAIN2309/SpendSmart_flutter/main/web/icons/Icon-512.png" width="120" alt="SpendSmart Logo"/>

# SpendSmart

### 💸 Track Every Rupee. Own Your Finances.

*A production-quality Flutter expense tracker — fully offline, beautifully animated, deeply analytical.*

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-6C63FF?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-34D399?style=for-the-badge)](https://flutter.dev)
[![Offline](https://img.shields.io/badge/Works-100%25%20Offline-FF6B6B?style=for-the-badge)](https://pub.dev/packages/hive)

<br/>

---

</div>

<br/>

## ✨ Features

<br/>

<table>
<tr>
<td width="50%">

### 🏠 Dashboard
- 🌅 Greeting with time-based message *(Good morning, Krish 👋)*
- 📅 **Month navigator** — swipe through any month
- 💎 **Glassmorphism balance card** — total / income / expenses
- 📊 **Weekly bar chart** — last 7 days, tap for tooltip
- 🍩 **Category donut chart** — tap slices for ₹ breakdown
- 🕐 **Recent 5 transactions** with See all →

</td>
<td width="50%">

### 💳 Transactions
- 🔍 **Live search** by title or note
- 🏷️ **Category filter chips** — All, Food, Transport…
- 📆 **Date group headers** — Today / Yesterday / June 5
- 👆 **Swipe left to delete** with undo snackbar
- ➕ **FAB** opens Add Expense sheet instantly

</td>
</tr>
<tr>
<td width="50%">

### 📈 Analytics
- 📉 **Line chart trend** — Week / Month / Year tabs
- 🎯 **Category breakdown** — animated progress bars
- 🧮 **Top stats grid** — highest expense, avg daily, top category, days tracked
- 🆚 **Monthly comparison** — this month vs last with % change badge

</td>
<td width="50%">

### ➕ Add Expense
- 🔀 **Expense / Income toggle** — segmented control
- 💰 **Big ₹ amount input** — clean centered numpad
- 🏷️ **Scrollable category chips** — with icons + colors
- 🗓️ **Date picker** — defaults to today
- 📝 **Optional note** field
- ✅ **Gradient save button** with haptic feedback

</td>
</tr>
</table>

<br/>

---

<br/>

## 🎨 Design System

<br/>

<div align="center">

| Token | 🌑 Dark | ☀️ Light |
|:------|:-------:|:--------:|
| Background | `#0D1117` | `#F8FAFC` |
| Card Surface | `#161B22` | `#FFFFFF` |
| Primary Accent | `#6C63FF` 🟣 | `#6C63FF` 🟣 |
| Income Green | `#2ECC71` 🟢 | `#2ECC71` 🟢 |
| Expense Red | `#FF6B6B` 🔴 | `#FF6B6B` 🔴 |
| Border | `#30363D` | `#E2E8F0` |
| Font | **Poppins** | **Poppins** |
| Card Radius | `16 – 20 px` | `16 – 20 px` |

</div>

<br/>

---

<br/>

## 🗂️ Categories

<br/>

<div align="center">

| Icon | Category | Hex | Type |
|:----:|:---------|:---:|:----:|
| ☕ | Food & Drinks | ![](https://img.shields.io/badge/-FF6B6B-FF6B6B?style=flat-square) `#FF6B6B` | Expense |
| 🚗 | Transport | ![](https://img.shields.io/badge/-4ECDC4-4ECDC4?style=flat-square) `#4ECDC4` | Expense |
| 🛍️ | Shopping | ![](https://img.shields.io/badge/-A78BFA-A78BFA?style=flat-square) `#A78BFA` | Expense |
| 💊 | Health | ![](https://img.shields.io/badge/-34D399-34D399?style=flat-square) `#34D399` | Expense |
| 🎮 | Entertainment | ![](https://img.shields.io/badge/-FFBF24-FFBF24?style=flat-square) `#FFBF24` | Expense |
| 💡 | Bills | ![](https://img.shields.io/badge/-60A5FA-60A5FA?style=flat-square) `#60A5FA` | Expense |
| 📚 | Education | ![](https://img.shields.io/badge/-F472B6-F472B6?style=flat-square) `#F472B6` | Expense |
| 💰 | Salary | ![](https://img.shields.io/badge/-2ECC71-2ECC71?style=flat-square) `#2ECC71` | Income |
| 📦 | Other | ![](https://img.shields.io/badge/-94A3B8-94A3B8?style=flat-square) `#94A3B8` | Both |

</div>

<br/>

---

<br/>

## 🛠️ Tech Stack

<br/>

<div align="center">

| Package | Version | Purpose |
|:--------|:-------:|:--------|
| 🐝 `hive` + `hive_flutter` | `^2.2.3` | Lightning-fast local key-value storage |
| 📊 `fl_chart` | `^0.68.0` | Bar chart · Donut pie · Line chart |
| 🔄 `provider` | `^6.1.2` | Global state management (ChangeNotifier) |
| 🌍 `intl` | `^0.19.0` | Indian ₹ currency & date formatting |
| 🆔 `uuid` | `^4.3.3` | Unique IDs per transaction |
| 🔤 `google_fonts` | `^6.2.1` | Poppins font family |
| ✨ `flutter_animate` | `^4.5.0` | Staggered entrance animations |
| 🎨 `iconsax` | `^0.0.8` | Beautiful outline icon set |

</div>

<br/>

> **Zero build_runner required** — the Hive TypeAdapter is hand-written, so `flutter run` works straight after `flutter pub get`.

<br/>

---

<br/>

## 📁 Project Structure

<br/>

```
spendsmart/
│
├── 📄 main.dart                      ← Hive init, SystemUI, runApp
├── 📄 app.dart                       ← ChangeNotifierProvider, MaterialApp, theme
│
├── 📂 models/
│   └── expense.dart                  ← HiveObject: id · title · amount · category · date · note · isIncome
│
├── 📂 hive/
│   └── expense_adapter.dart          ← Hand-written TypeAdapter<Expense>
│
├── 📂 providers/
│   └── expense_provider.dart         ← CRUD + 11 computed getters (totalIncome, byCategory, last7Days…)
│
├── 📂 screens/
│   ├── home_screen.dart              ← BottomNavigationBar (Dashboard · Transactions · Analytics)
│   ├── dashboard_screen.dart         ← Hero card + charts + recent list
│   ├── transactions_screen.dart      ← Search, filter, grouped list, swipe-delete
│   ├── add_expense_screen.dart       ← Full-height bottom sheet form
│   └── stats_screen.dart             ← Line chart, breakdown, top-stats grid
│
├── 📂 widgets/
│   ├── summary_card.dart             ← Gradient glassmorphism balance card
│   ├── category_chip.dart            ← Animated pill category selector
│   ├── expense_tile.dart             ← Dismissible animated list tile
│   ├── bar_chart_widget.dart         ← fl_chart BarChart — last 7 days
│   ├── pie_chart_widget.dart         ← fl_chart PieChart — donut + legend
│   ├── line_chart_widget.dart        ← fl_chart LineChart — curved + gradient fill
│   └── empty_state.dart              ← Illustration + CTA when no data
│
└── 📂 utils/
    ├── constants.dart                ← AppColors · CategoryColors · CategoryIcons · CategoryNames
    ├── formatter.dart                ← currency(₹ en_IN) · date · dayLabel · monthYear
    └── theme.dart                    ← Full light + dark ThemeData with Poppins
```

<br/>

---

<br/>

## 🚀 Getting Started

<br/>

### Prerequisites

- [Flutter SDK 3.x](https://docs.flutter.dev/get-started/install)
- Dart `^3.10.1`
- Android Studio / VS Code with Flutter extension

<br/>

### Clone & Run

```bash
# 1. Clone the repo
git clone https://github.com/JAIN2309/SpendSmart_flutter.git
cd SpendSmart_flutter

# 2. Install dependencies (no build_runner step needed)
flutter pub get

# 3. Launch on your device or emulator
flutter run
```

<br/>

### Build Release APK

```bash
flutter build apk --release
```

The signed APK will be at `build/app/outputs/flutter-apk/app-release.apk`

<br/>

### Build for iOS

```bash
flutter build ios --release
```

<br/>

---

<br/>

## 📦 pubspec.yaml — Dependencies at a Glance

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
```

<br/>

---

<br/>

## 🏗️ Architecture

```
UI (Screens + Widgets)
        │
        ▼
ExpenseProvider  ←─────── ChangeNotifier
  (Provider)               notifyListeners()
        │
        ▼
  Hive Box<Expense>  ─────  Local Storage
  (expense_adapter)         ~/.hive/expenses.hive
```

- **Single source of truth** — all state lives in `ExpenseProvider`
- **Reactive UI** — `Consumer<ExpenseProvider>` rebuilds only affected subtrees
- **Offline-first** — Hive persists to device storage; no network calls anywhere

<br/>

---

<br/>

## 🤝 Contributing

Pull requests are welcome! For major changes please open an issue first.

1. Fork the repo
2. Create your branch — `git checkout -b feature/AmazingFeature`
3. Commit your changes — `git commit -m 'Add AmazingFeature'`
4. Push to the branch — `git push origin feature/AmazingFeature`
5. Open a Pull Request

<br/>

---

<br/>

<div align="center">

## 📄 License

MIT License © 2026 **[JAIN2309](https://github.com/JAIN2309)**

<br/>

*Built with ❤️ using Flutter*

<br/>

[![Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)

</div>
