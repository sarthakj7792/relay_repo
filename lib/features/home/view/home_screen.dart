import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:relay_repo/features/home/view/widgets/saved_item_card.dart';
import 'package:relay_repo/features/home/view_model/home_view_model.dart';
import 'package:relay_repo/data/repositories/auth_repository.dart';
import 'package:relay_repo/features/folders/view/folders_screen.dart';
import 'package:relay_repo/core/theme/app_theme.dart';

import 'package:relay_repo/features/settings/view/settings_screen.dart';
import 'package:relay_repo/features/settings/view/personal_information_screen.dart';
import 'package:relay_repo/features/add_item/view/add_item_screen.dart';
import 'package:relay_repo/features/details/view/video_detail_screen.dart';
import 'package:relay_repo/core/services/share_intent_service.dart';
import 'package:relay_repo/features/notifications/view/notifications_screen.dart';
import 'package:relay_repo/features/notifications/view_model/notifications_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const FoldersScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Listen for shared intents
    ref.read(shareIntentServiceProvider).intentStream.listen((url) {
      if (mounted && url.isNotEmpty) {
        // Navigate to AddItemScreen with the shared URL
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddItemScreen(initialUrl: url),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Folders'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedCategoryIndex = 0;
  final _categories = [
    'All',
    'YouTube',
    'Instagram',
    'Facebook',
    'Reddit',
    'Quora',
    'LinkedIn',
    'Others'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(homeViewModelProvider);
    ref.watch(
        notificationsViewModelProvider); // Watch to trigger rebuilds on notification changes

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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          color: Colors.transparent,
                          child: Image.asset(
                            'assets/icon/icon.png',
                            height: 30,
                            width: 30,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Relay',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                                letterSpacing: 1.0,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              icon: Icon(Icons.notifications_outlined,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationsScreen()),
                                );
                              },
                            ),
                            if (ref
                                    .read(
                                        notificationsViewModelProvider.notifier)
                                    .unreadCount >
                                0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '${ref.read(notificationsViewModelProvider.notifier).unreadCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.2),
                                  width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              child: Text(
                                (ref
                                                .watch(authRepositoryProvider)
                                                .currentUser
                                                ?.userMetadata?['full_name']
                                            as String? ??
                                        'User')[0]
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Container(
                  height: 50,
                  decoration: Theme.of(context).brightness == Brightness.light
                      ? AppTheme.glassCardDecoration
                      : AppTheme.glassCardDecorationDark,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.search,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: 'Search saved videos...',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.5)),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories (Tabs)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: isSelected
                            ? AppTheme.primaryGradient.createShader(
                                        const Rect.fromLTWH(0, 0, 200, 50)) !=
                                    null
                                ? BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryColor
                                            .withValues(alpha: 0.6),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  )
                                : null
                            : (Theme.of(context).brightness == Brightness.light
                                ? AppTheme.glassChipDecoration
                                : AppTheme.glassChipDecorationDark),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Content
              Expanded(
                child: itemsState.when(
                  data: (items) {
                    var filteredItems = items.where((item) {
                      return item.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase().trim());
                    }).toList();

                    if (_selectedCategoryIndex != 0) {
                      final category = _categories[_selectedCategoryIndex];
                      if (category == 'Others') {
                        filteredItems = filteredItems
                            .where((item) => ![
                                  'YouTube',
                                  'Instagram',
                                  'Facebook',
                                  'Reddit',
                                  'Quora',
                                  'LinkedIn'
                                ].contains(item.platform))
                            .toList();
                      } else {
                        filteredItems = filteredItems
                            .where((item) => item.platform == category)
                            .toList();
                      }
                    }

                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library_outlined,
                                size: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.2)),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No saved videos yet'
                                  : 'No results found',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5)),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75, // Taller cards
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return SavedItemCard(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoDetailScreen(item: item),
                              ),
                            );
                          },
                          onBookmark: () {
                            ref
                                .read(homeViewModelProvider.notifier)
                                .toggleBookmark(item.id);
                          },
                          onDelete: () {
                            ref
                                .read(homeViewModelProvider.notifier)
                                .deleteItem(item.id);
                          },
                          onAddToFolder: () {
                            _showMoveToFolderDialog(context, item);
                          },
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: Theme.of(context).brightness == Brightness.light
            ? AppTheme.glassFabDecoration
            : AppTheme.glassFabDecorationDark,
        child: FloatingActionButton(
          heroTag: 'home_fab',
          onPressed: () => _showAddLinkDialog(context, ref),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showMoveToFolderDialog(BuildContext context, dynamic item) async {
    // Fetch folders
    final folders = await ref.read(homeViewModelProvider.notifier).getFolders();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Folder'),
        content: SizedBox(
          width: double.maxFinite,
          child: folders.isEmpty
              ? const Text('No folders created yet.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    return ListTile(
                      leading: const Icon(Icons.folder),
                      title: Text(folder.title),
                      onTap: () {
                        ref
                            .read(homeViewModelProvider.notifier)
                            .moveItemToFolder(item.id, folder.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added to ${folder.title}'),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAddLinkDialog(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );
  }
}
