import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'dashboard_screen.dart';
import 'transactions_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _screens = [
    DashboardScreen(),
    TransactionsScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Iconsax.home),
              activeIcon: const Icon(Iconsax.home_2),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Iconsax.wallet),
              activeIcon: const Icon(Iconsax.wallet_1),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Iconsax.chart_1),
              activeIcon: const Icon(Iconsax.chart_2),
              label: 'Analytics',
            ),
          ],
          selectedLabelStyle: GoogleFonts.poppins(
              fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        ),
      ),
    );
  }
}
