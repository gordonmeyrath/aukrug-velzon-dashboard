// Stub für Isar auf Web-Platform
// ignore_for_file: non_constant_identifier_names
class Id {
  final int value;
  const Id(this.value);
}

class Collection {
  const Collection();
}

class Isar {
  static Future<Isar> open(List schemas, {String? directory}) async {
    throw UnsupportedError('Isar is not supported on web');
  }
}

class IsarCollection {
  Future<void> clear() async {}
  Future<void> put(dynamic entity) async {}
  Future<List> where() async => [];
}

class QueryBuilder {
  Future<List> findAll() async => [];
}
