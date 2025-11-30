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
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:relay_repo/core/services/streak_service.dart';
import 'package:relay_repo/core/services/tutorial_service.dart';
import 'package:relay_repo/features/achievements/view/achievements_screen.dart';

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

  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _categoriesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  void _checkAndShowTutorial() {
    try {
      final tutorialService = ref.read(tutorialServiceProvider);
      if (!tutorialService.hasSeenTutorial) {
        _showTutorial(tutorialService);
      }
    } catch (e) {
      // Silently fail if tutorial can't be shown
      // This can happen if widgets aren't ready yet
    }
  }

  void _showTutorial(TutorialService tutorialService) {
    final targets = [
      TargetFocus(
        identify: 'fab',
        keyTarget: _fabKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Content',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Tap here to save videos from YouTube, Instagram, and more.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: 'search',
        keyTarget: _searchKey,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Quickly find your saved items here.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: 'categories',
        keyTarget: _categoriesKey,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by Platform',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Filter your collection by source platform.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ];

    tutorialService.showTutorial(
      context: context,
      targets: targets,
    );
  }

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
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Stash',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 1.0,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Streak Counter
                          Consumer(
                            builder: (context, ref, child) {
                              final streakService =
                                  ref.watch(streakServiceProvider);
                              // Trigger check on load
                              ref.read(streakServiceProvider).checkStreak();

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                        Icons.local_fire_department_rounded,
                                        color: Colors.orange,
                                        size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${streakService.currentStreak}',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AchievementsScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events_outlined,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
                              backgroundImage: (ref
                                          .watch(authRepositoryProvider)
                                          .currentUser
                                          ?.userMetadata?['avatar_url'] !=
                                      null)
                                  ? NetworkImage(ref
                                      .watch(authRepositoryProvider)
                                      .currentUser!
                                      .userMetadata!['avatar_url'])
                                  : null,
                              child: ref
                                          .watch(authRepositoryProvider)
                                          .currentUser
                                          ?.userMetadata?['avatar_url'] ==
                                      null
                                  ? Text(
                                      (ref
                                                      .watch(authRepositoryProvider)
                                                      .currentUser
                                                      ?.userMetadata?[
                                                  'full_name'] as String? ??
                                              'User')[0]
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
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
                  key: _searchKey,
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
                  key: _categoriesKey,
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

              // On This Day
              Consumer(
                builder: (context, ref, child) {
                  final itemsAsync = ref.watch(homeViewModelProvider);
                  return itemsAsync.when(
                    data: (items) {
                      final onThisDayItems = items.where((item) {
                        final now = DateTime.now();
                        // Check if item was saved exactly 1 year ago (ignoring time)
                        return item.date.year == now.year - 1 &&
                            item.date.month == now.month &&
                            item.date.day == now.day;
                      }).toList();

                      if (onThisDayItems.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final item = onThisDayItems.first;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoDetailScreen(item: item),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2575FC)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.history,
                                      color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'On This Day',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'You saved "${item.title}" 1 year ago',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.8),
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                },
              ),
              const SizedBox(height: 8),

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        decoration: Theme.of(context).brightness == Brightness.light
            ? AppTheme.glassFabDecoration
            : AppTheme.glassFabDecorationDark,
        child: FloatingActionButton(
          key: _fabKey,
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
