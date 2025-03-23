import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mannerisms/menu/viewmodel/menu_viewmodel.dart';
import 'package:mannerisms/menu/components/menu_item.dart';
import 'package:mannerisms/services/auth_interceptor.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final _authInterceptor = AuthInterceptor();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final headers = await _authInterceptor.getAuthHeaders();
      if (!mounted) return;
      context.read<MenuViewModel>().loadMenuItems(headers);
    });
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final menuViewModel = context.watch<MenuViewModel>();
    
    if (menuViewModel.isLoading) {
      return [const Center(child: CircularProgressIndicator())];
    }

    final menu = menuViewModel.menu;
    if (menu == null) {
      return [const Center(child: Text('No menu items available'))];
    }

    return menu.menuItems.map((item) => MenuItemComponent(item: item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _buildMenuItems(context),
      ),
    );
  }
} 