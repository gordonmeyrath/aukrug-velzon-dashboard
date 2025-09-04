// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$documentsRepositoryHash() =>
    r'2a4e0f6281ab15dd3689f04b5b97cfeb82afb8e3';

/// See also [documentsRepository].
@ProviderFor(documentsRepository)
final documentsRepositoryProvider =
    AutoDisposeProvider<DocumentsRepository>.internal(
  documentsRepository,
  name: r'documentsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$documentsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DocumentsRepositoryRef = AutoDisposeProviderRef<DocumentsRepository>;
String _$allDocumentsHash() => r'9d0c44be8e4ce46473dcad161c4319928d04f029';

/// See also [allDocuments].
@ProviderFor(allDocuments)
final allDocumentsProvider = AutoDisposeFutureProvider<List<Document>>.internal(
  allDocuments,
  name: r'allDocumentsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allDocumentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllDocumentsRef = AutoDisposeFutureProviderRef<List<Document>>;
String _$popularDocumentsHash() => r'35d5e535207b08d283ffd75e616e090367b53102';

/// See also [popularDocuments].
@ProviderFor(popularDocuments)
final popularDocumentsProvider =
    AutoDisposeFutureProvider<List<Document>>.internal(
  popularDocuments,
  name: r'popularDocumentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$popularDocumentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PopularDocumentsRef = AutoDisposeFutureProviderRef<List<Document>>;
String _$documentsByCategoryHash() =>
    r'206cd68a235147abdeb1b3e3678a3c72512e9953';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [documentsByCategory].
@ProviderFor(documentsByCategory)
const documentsByCategoryProvider = DocumentsByCategoryFamily();

/// See also [documentsByCategory].
class DocumentsByCategoryFamily extends Family<AsyncValue<List<Document>>> {
  /// See also [documentsByCategory].
  const DocumentsByCategoryFamily();

  /// See also [documentsByCategory].
  DocumentsByCategoryProvider call(
    DocumentCategory category,
  ) {
    return DocumentsByCategoryProvider(
      category,
    );
  }

  @override
  DocumentsByCategoryProvider getProviderOverride(
    covariant DocumentsByCategoryProvider provider,
  ) {
    return call(
      provider.category,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'documentsByCategoryProvider';
}

/// See also [documentsByCategory].
class DocumentsByCategoryProvider
    extends AutoDisposeFutureProvider<List<Document>> {
  /// See also [documentsByCategory].
  DocumentsByCategoryProvider(
    DocumentCategory category,
  ) : this._internal(
          (ref) => documentsByCategory(
            ref as DocumentsByCategoryRef,
            category,
          ),
          from: documentsByCategoryProvider,
          name: r'documentsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$documentsByCategoryHash,
          dependencies: DocumentsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              DocumentsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  DocumentsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final DocumentCategory category;

  @override
  Override overrideWith(
    FutureOr<List<Document>> Function(DocumentsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DocumentsByCategoryProvider._internal(
        (ref) => create(ref as DocumentsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Document>> createElement() {
    return _DocumentsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DocumentsByCategoryRef on AutoDisposeFutureProviderRef<List<Document>> {
  /// The parameter `category` of this provider.
  DocumentCategory get category;
}

class _DocumentsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Document>>
    with DocumentsByCategoryRef {
  _DocumentsByCategoryProviderElement(super.provider);

  @override
  DocumentCategory get category =>
      (origin as DocumentsByCategoryProvider).category;
}

String _$documentsSearchHash() => r'a50a26d87ac3462332c797f09e415aea95c1fd11';

/// See also [DocumentsSearch].
@ProviderFor(DocumentsSearch)
final documentsSearchProvider =
    AutoDisposeAsyncNotifierProvider<DocumentsSearch, List<Document>>.internal(
  DocumentsSearch.new,
  name: r'documentsSearchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$documentsSearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DocumentsSearch = AutoDisposeAsyncNotifier<List<Document>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
