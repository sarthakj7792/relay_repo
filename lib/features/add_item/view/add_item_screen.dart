import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/core/theme/app_theme.dart';
import 'package:relay_repo/features/home/view_model/home_view_model.dart';
import 'package:relay_repo/core/services/metadata_service.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  final String? initialUrl;
  const AddItemScreen({super.key, this.initialUrl});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _urlController = TextEditingController();
  bool _isLoading = false;
  String? _previewTitle;
  String? _previewImage;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null) {
      _urlController.text = widget.initialUrl!;
      // Use addPostFrameCallback to ensure the widget is built before calling setState or async methods that might affect UI
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchPreview();
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _fetchPreview() async {
    if (_urlController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _previewTitle = null;
        _previewImage = null;
      });

      try {
        final metadataService = ref.read(metadataServiceProvider);
        final metadata =
            await metadataService.fetchMetadata(_urlController.text);

        if (mounted) {
          setState(() {
            _isLoading = false;
            _previewTitle = metadata?.title ?? 'No Title Found';
            _previewImage = metadata?.image;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _previewTitle = 'Error fetching preview';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Item',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.liquidBackgroundGradient
                        : AppTheme.liquidBackgroundGradientDark,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Paste a link to save it to your vault',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                              fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Input Field
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : const Color(0xFF252836)
                                        .withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : Colors.white.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? const Color(0xFF7090B0)
                                        .withValues(alpha: 0.2)
                                    : Colors.black.withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _urlController,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                            decoration: InputDecoration(
                              hintText: 'https://...',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.5)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(20),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.paste,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7)),
                                onPressed: () async {
                                  final data = await Clipboard.getData(
                                      Clipboard.kTextPlain);
                                  if (data?.text != null) {
                                    _urlController.text = data!.text!;
                                    _fetchPreview();
                                  }
                                },
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && _previewTitle == null) {
                                // Debounce fetching preview in real app
                              }
                            },
                            onSubmitted: (_) => _fetchPreview(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Preview Card
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (_previewTitle != null)
                          Container(
                            decoration:
                                Theme.of(context).brightness == Brightness.light
                                    ? AppTheme.glassCardDecoration
                                    : AppTheme.glassCardDecorationDark,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_previewImage != null)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      _previewImage!,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _previewTitle!,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'YouTube', // Mock platform
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const Spacer(),

                        // Save Button
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_urlController.text.isNotEmpty) {
                                ref
                                    .read(homeViewModelProvider.notifier)
                                    .addItem(_urlController.text);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text(
                              'Save to Vault',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
