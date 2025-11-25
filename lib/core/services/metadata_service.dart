import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MetadataService {
  Future<Metadata?> fetchMetadata(String url) async {
    try {
      final data = await MetadataFetch.extract(url);
      return data;
    } catch (e) {
      return null;
    }
  }
}

final metadataServiceProvider = Provider<MetadataService>((ref) {
  return MetadataService();
});
