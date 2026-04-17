import 'dart:async';

import 'package:firebase_practice/core/routes/app_route_paths.dart';
import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:firebase_practice/features/auth/domain/entities/app_user.dart';
import 'package:firebase_practice/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum ConsoleSection { tasks, deadlines, analytics, settings }

class KineticShell extends ConsumerWidget {
  const KineticShell({
    super.key,
    required this.child,
    this.selectedSection = ConsoleSection.tasks,
    this.showBackButton = false,
    this.floatingActionButton,
  });

  final Widget child;
  final ConsoleSection selectedSection;
  final bool showBackButton;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final bool isDesktop = screenSize.width >= 980;
    final AppUser? user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: isDesktop
          ? null
          : _BottomConsoleNav(
              current: selectedSection,
              onSelected: (ConsoleSection section) =>
                  _handleSectionTap(context, section),
            ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -120,
            right: -80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 180,
                    spreadRadius: 80,
                  ),
                ],
              ),
              child: const SizedBox(width: 240, height: 240),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.06),
                    blurRadius: 180,
                    spreadRadius: 70,
                  ),
                ],
              ),
              child: const SizedBox(width: 260, height: 260),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                _TopBar(
                  user: user,
                  showBackButton: showBackButton,
                  onBack: () {
                    if (context.canPop()) {
                      context.pop();
                      return;
                    }

                    context.go(AppRoutePaths.tasks);
                  },
                  onSignOut: () => _signOut(context, ref),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (isDesktop)
                        Padding(
                          padding: const EdgeInsets.only(left: 24, top: 24),
                          child: _DesktopSidebar(
                            current: selectedSection,
                            onSelected: (ConsoleSection section) =>
                                _handleSectionTap(context, section),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            isDesktop ? 24 : 24,
                            24,
                            24,
                            isDesktop ? 40 : 120,
                          ),
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSectionTap(BuildContext context, ConsoleSection section) {
    if (section == ConsoleSection.tasks) {
      context.go(AppRoutePaths.tasks);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (section) {
          ConsoleSection.deadlines =>
            'Deadlines estará disponible en la siguiente iteración.',
          ConsoleSection.analytics =>
            'Analytics queda listo para la siguiente práctica.',
          ConsoleSection.settings =>
            'Settings se puede extender después con perfil y preferencias.',
          ConsoleSection.tasks => '',
        }),
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).signOut();
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cerrar la sesión.')),
      );
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.user,
    required this.showBackButton,
    required this.onBack,
    required this.onSignOut,
  });

  final AppUser? user;
  final bool showBackButton;
  final VoidCallback onBack;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        children: <Widget>[
          if (showBackButton) ...<Widget>[
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              color: AppColors.secondary,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceContainerLow,
                side: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.18),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Icon(Icons.code_rounded, color: AppColors.secondaryContainer),
          const SizedBox(width: 12),
          Text(
            'Kinetic Dev',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.secondaryContainer,
              fontSize: 24,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            tooltip: 'Profile',
            offset: const Offset(0, 56),
            color: AppColors.surfaceContainer,
            onSelected: (String value) {
              if (value == 'signout') {
                onSignOut();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user?.displayName ?? 'Developer',
                      style: textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'authenticated@firebase.dev',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'signout',
                child: Text('Cerrar sesión'),
              ),
            ],
            child: _UserAvatar(user: user),
          ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final String initials = user?.initials ?? 'KD';

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.18),
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.onSurface),
        ),
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({required this.current, required this.onSelected});

  final ConsoleSection current;
  final ValueChanged<ConsoleSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Dev Console',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  'v1.0.4-stable',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._navItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SidebarTile(
                icon: item.icon,
                label: item.label,
                selected: current == item.section,
                onTap: () => onSelected(item.section),
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.10),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.75),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Firebase Auth Active',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.secondary,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.surfaceContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: selected ? 4 : 0,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              if (selected) const SizedBox(width: 12),
              Icon(
                icon,
                color: selected
                    ? AppColors.secondaryContainer
                    : AppColors.surfaceVariant,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: selected
                      ? AppColors.secondaryContainer
                      : AppColors.surfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomConsoleNav extends StatelessWidget {
  const _BottomConsoleNav({required this.current, required this.onSelected});

  final ConsoleSection current;
  final ValueChanged<ConsoleSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.18),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navItems
            .map(
              (item) => _BottomNavItem(
                icon: item.icon,
                label: item.label,
                selected: item.section == current,
                onTap: () => onSelected(item.section),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: selected
                  ? AppColors.secondaryContainer
                  : AppColors.surfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected
                    ? AppColors.secondaryContainer
                    : AppColors.surfaceVariant,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.section,
    required this.icon,
    required this.label,
  });

  final ConsoleSection section;
  final IconData icon;
  final String label;
}

const List<_NavItem> _navItems = <_NavItem>[
  _NavItem(
    section: ConsoleSection.tasks,
    icon: Icons.list_alt_rounded,
    label: 'Tasks',
  ),
  _NavItem(
    section: ConsoleSection.deadlines,
    icon: Icons.event_note_rounded,
    label: 'Deadlines',
  ),
  _NavItem(
    section: ConsoleSection.analytics,
    icon: Icons.bar_chart_rounded,
    label: 'Analytics',
  ),
  _NavItem(
    section: ConsoleSection.settings,
    icon: Icons.settings_rounded,
    label: 'Settings',
  ),
];
