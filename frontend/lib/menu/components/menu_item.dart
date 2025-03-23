import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mannerisms/services/auth_viewmodel.dart';
import 'package:mannerisms/menu/model/menu_model.dart';
import 'package:mannerisms/utils/theme.dart';
import 'package:mannerisms/utils/theme_provider.dart';

class MenuItemComponent extends StatelessWidget {
  final MenuItem item;

  const MenuItemComponent({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLogout = item.title == 'Log Out';
    final Color itemColor = isLogout ? Colors.red : Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        Card(
          child: ListTile(
            leading: Icon(
              item.icon,
              color: itemColor,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: itemColor,
              ),
            ),
            onTap: () => _handleTap(context),
          ),
        ),
        if (item.showDivider)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    if (item.title == 'Log Out') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (confirmed == true && context.mounted) {
        await context.read<AuthViewModel>().logout();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } 
    else if (item.title == 'Theme') {
      context.read<ThemeProvider>().toggleTheme();
    }
    else {
      Navigator.pushNamed(context, item.route);
    }
  }
}

