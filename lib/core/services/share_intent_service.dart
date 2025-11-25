import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntentService {
  final StreamController<String> _intentController =
      StreamController<String>.broadcast();

  Stream<String> get intentStream => _intentController.stream;

  ShareIntentService();

  void init() {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
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
  final service = ShareIntentService();
  service.init();
  ref.onDispose(() => service.dispose());
  return service;
});
