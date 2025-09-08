import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for sensitive data
class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainItemAccessibility.first_unlock_this_device,
    ),
  );

  /// Store a value securely
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a secure value
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a secure value
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all secure values
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }

  // Authentication tokens
  Future<String?> getAuthToken() => read('auth_token');
  Future<void> setAuthToken(String token) => write('auth_token', token);
  Future<void> deleteAuthToken() => delete('auth_token');

  // User credentials
  Future<String?> getUserId() => read('user_id');
  Future<void> setUserId(String userId) => write('user_id', userId);
  Future<void> deleteUserId() => delete('user_id');
}

/// Provider for secure storage
final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());
