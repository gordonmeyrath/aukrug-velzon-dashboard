import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';

part 'kv_store.g.dart';

/// Key-value store interface using Isar for local data persistence
@riverpod
Future<Isar> kvStore(KvStoreRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      // Register Isar schemas here
      // PlaceSchema,
      // EventSchema,
      // etc.
    ],
    name: AppConfig.isarDbName,
    directory: dir.path,
  );

  return isar;
}

/// Generic repository interface for CRUD operations
abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<void> save(T item);
  Future<void> saveAll(List<T> items);
  Future<void> delete(int id);
  Future<void> deleteAll();
}

/// Base implementation for Isar repositories
abstract class IsarRepository<T> implements Repository<T> {
  final Isar isar;

  IsarRepository(this.isar);

  /// Get the Isar collection for type T
  IsarCollection<T> get collection;

  @override
  Future<List<T>> getAll() async {
    return await isar.txn(() async {
      return await collection.where().findAll();
    });
  }

  @override
  Future<T?> getById(int id) async {
    return await isar.txn(() async {
      return await collection.get(id);
    });
  }

  @override
  Future<void> save(T item) async {
    await isar.writeTxn(() async {
      await collection.put(item);
    });
  }

  @override
  Future<void> saveAll(List<T> items) async {
    await isar.writeTxn(() async {
      await collection.putAll(items);
    });
  }

  @override
  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await collection.delete(id);
    });
  }

  @override
  Future<void> deleteAll() async {
    await isar.writeTxn(() async {
      await collection.clear();
    });
  }
}
