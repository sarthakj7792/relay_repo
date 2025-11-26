import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/core/theme/app_theme.dart';
import 'package:relay_repo/core/theme/theme_view_model.dart';
import 'package:relay_repo/data/repositories/auth_repository.dart';
import 'package:relay_repo/features/notifications/view/notifications_screen.dart';
import 'package:relay_repo/features/settings/view/personal_information_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.light
              ? AppTheme.liquidBackgroundGradient
              : AppTheme.liquidBackgroundGradientDark,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.settings_outlined,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Settings',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Profile Card
                      Consumer(
                        builder: (context, ref, child) {
                          final user =
                              ref.watch(authRepositoryProvider).currentUser;
                          final email = user?.email ?? 'Guest';
                          final name =
                              user?.userMetadata?['full_name'] as String? ??
                                  'User';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PersonalInformationScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? AppTheme.glassCardDecoration
                                  : AppTheme.glassCardDecorationDark,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 32,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.1),
                                      backgroundImage:
                                          user?.userMetadata?['avatar_url'] !=
                                                  null
                                              ? NetworkImage(user!
                                                  .userMetadata!['avatar_url'])
                                              : null,
                                      child:
                                          user?.userMetadata?['avatar_url'] ==
                                                  null
                                              ? Text(
                                                  name.isNotEmpty
                                                      ? name[0].toUpperCase()
                                                      : 'U',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                )
                                              : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                  ),
                                            ),
                                            // const SizedBox(width: 8),
                                            // Container(
                                            //   padding:
                                            //       const EdgeInsets.symmetric(
                                            //           horizontal: 8,
                                            //           vertical: 2),
                                            //   decoration: BoxDecoration(
                                            //     color: Colors.amber,
                                            //     borderRadius:
                                            //         BorderRadius.circular(12),
                                            //   ),
                                            //   child: const Text(
                                            //     'FREE',
                                            //     style: TextStyle(
                                            //       color: Colors.black,
                                            //       fontSize: 10,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          email,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Account Settings
                      _buildSectionTitle(context, 'Account'),
                      const SizedBox(height: 16),
                      _buildSettingsGroup(context, [
                        _buildSettingItem(
                          context,
                          'Security',
                          Icons.lock_outline,
                          onTap: () {
                            // Placeholder for security settings
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Security settings coming soon')),
                            );
                          },
                        ),
                        _buildSettingItem(
                          context,
                          'Notifications',
                          Icons.notifications_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                      ]),

                      const SizedBox(height: 32),

                      // App Settings
                      _buildSectionTitle(context, 'App Settings'),
                      const SizedBox(height: 16),
                      _buildSettingsGroup(context, [
                        _buildSettingItem(
                          context,
                          'Appearance',
                          Icons.palette_outlined,
                          trailing: Text(
                            _getThemeName(ref.watch(themeViewModelProvider)),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.5)),
                          ),
                          onTap: () => _showThemeDialog(context, ref),
                        ),
                        _buildSettingItem(
                          context,
                          'Language',
                          Icons.language,
                          trailing: Text('English',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.5))),
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          context,
                          'Clear Cache',
                          Icons.cleaning_services_outlined,
                          onTap: () => _clearCache(context),
                        ),
                      ]),

                      const SizedBox(height: 32),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showSignOutDialog(context, ref),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                            foregroundColor: Colors.red,
                            elevation: 0,
                            side: BorderSide(
                                color: Colors.red.withValues(alpha: 0.5)),
                          ),
                          child: const Text('Log Out'),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          'Version 1.0.0 (Build 100)',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                              fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }

  Widget _buildSettingsGroup(BuildContext context, List<Widget> children) {
    return Container(
      decoration: Theme.of(context).brightness == Brightness.light
          ? AppTheme.glassCardDecoration
          : AppTheme.glassCardDecorationDark,
      child: Column(
        children: children,
      ),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ??
          Icon(Icons.chevron_right,
              color: colorScheme.onSurface.withValues(alpha: 0.5), size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final currentTheme = ref.watch(themeViewModelProvider);
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: Theme.of(context).brightness == Brightness.light
                ? AppTheme.glassCardDecoration
                : AppTheme.glassCardDecorationDark,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Theme',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                _buildThemeOption(
                  context,
                  ref,
                  'System Default',
                  ThemeMode.system,
                  currentTheme,
                ),
                _buildThemeOption(
                  context,
                  ref,
                  'Light',
                  ThemeMode.light,
                  currentTheme,
                ),
                _buildThemeOption(
                  context,
                  ref,
                  'Dark',
                  ThemeMode.dark,
                  currentTheme,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    String title,
    ThemeMode mode,
    ThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;
    return ListTile(
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        ref.read(themeViewModelProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authRepositoryProvider).signOut();
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearCache(BuildContext context) {
    // Clear image cache
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared successfully')),
    );
  }
}
