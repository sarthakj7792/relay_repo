import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/data/repositories/auth_repository.dart';
import 'package:relay_repo/data/repositories/storage/local_storage_repository.dart';
import 'package:relay_repo/data/repositories/storage/storage_repository.dart';
import 'package:relay_repo/data/repositories/supabase_repository.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);

  // If user is guest, use local storage
  if (authRepo.isGuest) {
    return LocalStorageRepository();
  }

  // If user is logged in, use cloud storage (Supabase)
  if (authRepo.currentUser != null) {
    return ref.watch(supabaseRepositoryProvider);
  }

  // Fallback (e.g., during loading or initial state), default to local
  return LocalStorageRepository();
});
