import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

class SpendSmartApp extends StatefulWidget {
  const SpendSmartApp({super.key});

  @override
  State<SpendSmartApp> createState() => _SpendSmartAppState();
}

class _SpendSmartAppState extends State<SpendSmartApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpenseProvider(),
      child: MaterialApp(
        title: 'SpendSmart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeMode,
        home: _HomeWrapper(onToggleTheme: _toggleTheme),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        ),
      ),
    );
  }
}

class _HomeWrapper extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const _HomeWrapper({required this.onToggleTheme});

  @override
  Widget build(BuildContext context) => const HomeScreen();
}
