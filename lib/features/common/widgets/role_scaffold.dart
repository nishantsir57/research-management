import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';

class RoleNavigationItem {
  const RoleNavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

class RoleScaffold extends StatelessWidget {
  const RoleScaffold({
    super.key,
    required this.title,
    required this.navItems,
    required this.child,
    this.actions,
    this.fab,
    this.showMobileNav = true,
    this.trailing,
  });

  final String title;
  final List<RoleNavigationItem> navItems;
  final Widget child;
  final List<Widget>? actions;
  final Widget? fab;
  final Widget? trailing;
  final bool showMobileNav;

  int _indexForRoute(BuildContext context) {
    final location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    final index = navItems.indexWhere((item) => location.startsWith(item.route));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        final navIndex = _indexForRoute(context);
        return Scaffold(
          backgroundColor: AppColors.pearl50,
          floatingActionButton: fab,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(title, style: theme.textTheme.titleLarge),
            actions: actions,
          ),
          drawer: isDesktop
              ? null
              : Drawer(
                  child: _DrawerNavigation(
                    navItems: navItems,
                    selectedIndex: navIndex,
                  ),
                ),
          body: Row(
            children: [
              if (isDesktop)
                Container(
                  width: 260,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      right: BorderSide(color: AppColors.gray200),
                    ),
                  ),
                  child: _SideNavigation(
                    navItems: navItems,
                    selectedIndex: navIndex,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    if (trailing != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: trailing,
                      ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: (!isDesktop && showMobileNav)
              ? NavigationBar(
                  selectedIndex: navIndex,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  onDestinationSelected: (index) {
                    final item = navItems[index];
                    if (GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString() != item.route) {
                      context.go(item.route);
                    }
                  },
                  destinations: navItems
                      .map(
                        (item) => NavigationDestination(
                          icon: Icon(item.icon),
                          label: item.label,
                        ),
                      )
                      .toList(),
                )
              : null,
        );
      },
    );
  }
}

class _SideNavigation extends StatelessWidget {
  const _SideNavigation({
    required this.navItems,
    required this.selectedIndex,
  });

  final List<RoleNavigationItem> navItems;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      itemCount: navItems.length,
      itemBuilder: (context, index) {
        final item = navItems[index];
        final isSelected = index == selectedIndex;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              if (router.routerDelegate.currentConfiguration.uri.toString() != item.route) {
                context.go(item.route);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isSelected ? AppColors.indigo700 : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.indigo600 : AppColors.gray200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    color: isSelected ? Colors.white : AppColors.gray600,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DrawerNavigation extends StatelessWidget {
  const _DrawerNavigation({
    required this.navItems,
    required this.selectedIndex,
  });

  final List<RoleNavigationItem> navItems;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Kohinchha'),
            subtitle: Text('Research Management System'),
          ),
          const Divider(),
          ...navItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == selectedIndex;
            return ListTile(
              leading: Icon(item.icon, color: isSelected ? AppColors.indigo600 : null),
              title: Text(item.label),
              selected: isSelected,
              onTap: () {
                Navigator.of(context).pop();
                if (GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString() != item.route) {
                  context.go(item.route);
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
