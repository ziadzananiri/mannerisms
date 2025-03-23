import 'package:flutter/material.dart';
import 'package:mannerisms/questions/view/home_view.dart';
import 'package:mannerisms/profile/view/profile_view.dart';
import 'package:mannerisms/menu/view/settings_view.dart';
import 'package:mannerisms/home/view/culture_selection_view.dart';
import 'package:mannerisms/home/viewmodel/culture_viewmodel.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const ProfileView(),
    const SettingsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cultureViewModel = context.read<CultureViewModel>();
    if (cultureViewModel.selectedCulture == null) {
      return const CultureSelectionView();
    }
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
} 