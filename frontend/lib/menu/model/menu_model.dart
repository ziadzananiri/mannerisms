import 'package:flutter/material.dart';

class MenuModel {
  final List<MenuItem> menuItems;

  MenuModel({
    List<MenuItem>? menuItems,
  }) : menuItems = menuItems ??
            [
              MenuItem(
                id: '1',
                title: 'Theme',
                icon: Icons.brightness_7,
                route: '/theme',
                showDivider: true,
              ),
              MenuItem(
                id: '2',
                title: 'Log Out',
                icon: Icons.logout,
                route: '/login',
                showDivider: true,
              ),
            ];
}

class MenuItem {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final bool showDivider;

  MenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.showDivider = false,
  });
}
