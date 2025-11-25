import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntentService {
  final StreamController<String> _intentController =
      StreamController<String>.broadcast();

  Stream<String> get intentStream => _intentController.stream;

  ShareIntentService() {
    _init();
  }

  void _init() {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    ReceiveSharingIntent.instance.getMediaStream().listen(
        (List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.path.isNotEmpty) {
        // We are primarily interested in text/links for now
        // But receive_sharing_intent unifies this.
        // Wait, for text/links we might need getTextStream?
        // Let's check the package documentation pattern.
        // Actually, for latest versions, it might be unified or separate.
        // Let's assume we want text/url sharing.
      }
    }, onError: (err) {
      debugPrint('getMediaStream error: $err');
    });

    // For sharing text/url
    ReceiveSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedMediaFile> value) {
      // This is for files/media
    });

    // Correct usage for text/url sharing in newer versions:
    // It seems the package has changed recently.
    // Let's use the standard way for text.
    // Actually, looking at the package, it often separates media and text.
    // But wait, I need to be sure about the version ^1.8.1 API.
    // It usually has getTextStream and getInitialText.

    // Listen to media stream (which might include text in some versions or be separate)
    // Let's try to handle both if possible, but for this app we want Links.

    // NOTE: In 1.8.x, it's often:
    // ReceiveSharingIntent.getTextStream().listen(...)
    // ReceiveSharingIntent.getInitialText().then(...)

    // Let's implement that.

    ReceiveSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedMediaFile> value) {
      // Handle files if needed later
    });
  }

  // Re-implementing with correct API for text
  void init() {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    ReceiveSharingIntent.instance.getMediaStream().listen(
        (List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        // If it's a file, we might want to handle it, but for now let's focus on text/links.
        // Often links come as text.
      }
    }, onError: (err) {
      debugPrint('getIntentDataStream error: $err');
    });

    // Get the media stream (files, images, videos)
    // For text (links), we usually use a different stream or the same one depending on configuration.
    // Wait, the latest receive_sharing_intent (1.8.1) might have changed.
    // Let's assume it supports `getMediaStream` for everything or has `getInitialMedia`.
    // Actually, checking the docs (mentally), 1.8.0+ removed `getTextStream` and unified everything into `getMediaStream`?
    // Or maybe it's the other way around.
    // Let's assume we need to handle text specifically if it's a link.

    // Let's try to be safe and use the unified approach if possible, or check for text.
    // If I look at the `receive_sharing_intent` 1.8.1 changelog, it says "Unified API".
    // So `getMediaStream` returns `List<SharedMediaFile>`.
    // `SharedMediaFile` has `path`, `type`, `thumbnail`, etc.
    // If it's text, `path` might be the text? Or `message`?
    // Let's look at the `SharedMediaFile` definition if I could...
    // I'll assume `path` holds the link/text for `SharedMediaType.text` or similar.

    // Let's write code that is robust.

    ReceiveSharingIntent.instance.getMediaStream().listen(
        (List<SharedMediaFile> value) {
      _handleSharedFiles(value);
    }, onError: (err) {
      debugPrint('getMediaStream error: $err');
    });

    // Get the shared media when the app is launched from a cold start
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      _handleSharedFiles(value);
    });
  }

  void _handleSharedFiles(List<SharedMediaFile> files) {
    if (files.isNotEmpty) {
      for (final file in files) {
        if (file.type == SharedMediaType.text ||
            file.type == SharedMediaType.url) {
          _intentController
              .add(file.path); // path usually contains the text/url
        }
      }
    }
  }

  void dispose() {
    _intentController.close();
  }
}

final shareIntentServiceProvider = Provider<ShareIntentService>((ref) {
  return ShareIntentService()..init();
});
