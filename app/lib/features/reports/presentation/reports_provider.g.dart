// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allReportsHash() => r'bc0e44b7ee7f5a3fa7f7c83d7b761abcb73b0729';

/// See also [allReports].
@ProviderFor(allReports)
final allReportsProvider = AutoDisposeFutureProvider<List<Report>>.internal(
  allReports,
  name: r'allReportsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allReportsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllReportsRef = AutoDisposeFutureProviderRef<List<Report>>;
String _$reportsByCategoryHash() => r'a8a831c912f8fccfbacc95db53677fb03532a357';

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

/// See also [reportsByCategory].
@ProviderFor(reportsByCategory)
const reportsByCategoryProvider = ReportsByCategoryFamily();

/// See also [reportsByCategory].
class ReportsByCategoryFamily extends Family<AsyncValue<List<Report>>> {
  /// See also [reportsByCategory].
  const ReportsByCategoryFamily();

  /// See also [reportsByCategory].
  ReportsByCategoryProvider call(
    ReportCategory category,
  ) {
    return ReportsByCategoryProvider(
      category,
    );
  }

  @override
  ReportsByCategoryProvider getProviderOverride(
    covariant ReportsByCategoryProvider provider,
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
  String? get name => r'reportsByCategoryProvider';
}

/// See also [reportsByCategory].
class ReportsByCategoryProvider
    extends AutoDisposeFutureProvider<List<Report>> {
  /// See also [reportsByCategory].
  ReportsByCategoryProvider(
    ReportCategory category,
  ) : this._internal(
          (ref) => reportsByCategory(
            ref as ReportsByCategoryRef,
            category,
          ),
          from: reportsByCategoryProvider,
          name: r'reportsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportsByCategoryHash,
          dependencies: ReportsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              ReportsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  ReportsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final ReportCategory category;

  @override
  Override overrideWith(
    FutureOr<List<Report>> Function(ReportsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportsByCategoryProvider._internal(
        (ref) => create(ref as ReportsByCategoryRef),
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
  AutoDisposeFutureProviderElement<List<Report>> createElement() {
    return _ReportsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReportsByCategoryRef on AutoDisposeFutureProviderRef<List<Report>> {
  /// The parameter `category` of this provider.
  ReportCategory get category;
}

class _ReportsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Report>>
    with ReportsByCategoryRef {
  _ReportsByCategoryProviderElement(super.provider);

  @override
  ReportCategory get category => (origin as ReportsByCategoryProvider).category;
}

String _$reportsByStatusHash() => r'cd29b4334f8039d43e04244768ea91ae23542d51';

/// See also [reportsByStatus].
@ProviderFor(reportsByStatus)
const reportsByStatusProvider = ReportsByStatusFamily();

/// See also [reportsByStatus].
class ReportsByStatusFamily extends Family<AsyncValue<List<Report>>> {
  /// See also [reportsByStatus].
  const ReportsByStatusFamily();

  /// See also [reportsByStatus].
  ReportsByStatusProvider call(
    ReportStatus status,
  ) {
    return ReportsByStatusProvider(
      status,
    );
  }

  @override
  ReportsByStatusProvider getProviderOverride(
    covariant ReportsByStatusProvider provider,
  ) {
    return call(
      provider.status,
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
  String? get name => r'reportsByStatusProvider';
}

/// See also [reportsByStatus].
class ReportsByStatusProvider extends AutoDisposeFutureProvider<List<Report>> {
  /// See also [reportsByStatus].
  ReportsByStatusProvider(
    ReportStatus status,
  ) : this._internal(
          (ref) => reportsByStatus(
            ref as ReportsByStatusRef,
            status,
          ),
          from: reportsByStatusProvider,
          name: r'reportsByStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportsByStatusHash,
          dependencies: ReportsByStatusFamily._dependencies,
          allTransitiveDependencies:
              ReportsByStatusFamily._allTransitiveDependencies,
          status: status,
        );

  ReportsByStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final ReportStatus status;

  @override
  Override overrideWith(
    FutureOr<List<Report>> Function(ReportsByStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportsByStatusProvider._internal(
        (ref) => create(ref as ReportsByStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Report>> createElement() {
    return _ReportsByStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportsByStatusProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReportsByStatusRef on AutoDisposeFutureProviderRef<List<Report>> {
  /// The parameter `status` of this provider.
  ReportStatus get status;
}

class _ReportsByStatusProviderElement
    extends AutoDisposeFutureProviderElement<List<Report>>
    with ReportsByStatusRef {
  _ReportsByStatusProviderElement(super.provider);

  @override
  ReportStatus get status => (origin as ReportsByStatusProvider).status;
}

String _$reportsByPriorityHash() => r'1fbf35f12687855f080d3183dbd156871a2b5802';

/// See also [reportsByPriority].
@ProviderFor(reportsByPriority)
const reportsByPriorityProvider = ReportsByPriorityFamily();

/// See also [reportsByPriority].
class ReportsByPriorityFamily extends Family<AsyncValue<List<Report>>> {
  /// See also [reportsByPriority].
  const ReportsByPriorityFamily();

  /// See also [reportsByPriority].
  ReportsByPriorityProvider call(
    ReportPriority priority,
  ) {
    return ReportsByPriorityProvider(
      priority,
    );
  }

  @override
  ReportsByPriorityProvider getProviderOverride(
    covariant ReportsByPriorityProvider provider,
  ) {
    return call(
      provider.priority,
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
  String? get name => r'reportsByPriorityProvider';
}

/// See also [reportsByPriority].
class ReportsByPriorityProvider
    extends AutoDisposeFutureProvider<List<Report>> {
  /// See also [reportsByPriority].
  ReportsByPriorityProvider(
    ReportPriority priority,
  ) : this._internal(
          (ref) => reportsByPriority(
            ref as ReportsByPriorityRef,
            priority,
          ),
          from: reportsByPriorityProvider,
          name: r'reportsByPriorityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportsByPriorityHash,
          dependencies: ReportsByPriorityFamily._dependencies,
          allTransitiveDependencies:
              ReportsByPriorityFamily._allTransitiveDependencies,
          priority: priority,
        );

  ReportsByPriorityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.priority,
  }) : super.internal();

  final ReportPriority priority;

  @override
  Override overrideWith(
    FutureOr<List<Report>> Function(ReportsByPriorityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportsByPriorityProvider._internal(
        (ref) => create(ref as ReportsByPriorityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        priority: priority,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Report>> createElement() {
    return _ReportsByPriorityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportsByPriorityProvider && other.priority == priority;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, priority.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReportsByPriorityRef on AutoDisposeFutureProviderRef<List<Report>> {
  /// The parameter `priority` of this provider.
  ReportPriority get priority;
}

class _ReportsByPriorityProviderElement
    extends AutoDisposeFutureProviderElement<List<Report>>
    with ReportsByPriorityRef {
  _ReportsByPriorityProviderElement(super.provider);

  @override
  ReportPriority get priority => (origin as ReportsByPriorityProvider).priority;
}

String _$nearbyReportsHash() => r'c16fa6abed812d86514087eacb3cfaf956297e25';

/// See also [nearbyReports].
@ProviderFor(nearbyReports)
const nearbyReportsProvider = NearbyReportsFamily();

/// See also [nearbyReports].
class NearbyReportsFamily extends Family<AsyncValue<List<Report>>> {
  /// See also [nearbyReports].
  const NearbyReportsFamily();

  /// See also [nearbyReports].
  NearbyReportsProvider call({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) {
    return NearbyReportsProvider(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }

  @override
  NearbyReportsProvider getProviderOverride(
    covariant NearbyReportsProvider provider,
  ) {
    return call(
      latitude: provider.latitude,
      longitude: provider.longitude,
      radiusKm: provider.radiusKm,
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
  String? get name => r'nearbyReportsProvider';
}

/// See also [nearbyReports].
class NearbyReportsProvider extends AutoDisposeFutureProvider<List<Report>> {
  /// See also [nearbyReports].
  NearbyReportsProvider({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) : this._internal(
          (ref) => nearbyReports(
            ref as NearbyReportsRef,
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
          ),
          from: nearbyReportsProvider,
          name: r'nearbyReportsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearbyReportsHash,
          dependencies: NearbyReportsFamily._dependencies,
          allTransitiveDependencies:
              NearbyReportsFamily._allTransitiveDependencies,
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
        );

  NearbyReportsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
  }) : super.internal();

  final double latitude;
  final double longitude;
  final double radiusKm;

  @override
  Override overrideWith(
    FutureOr<List<Report>> Function(NearbyReportsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbyReportsProvider._internal(
        (ref) => create(ref as NearbyReportsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Report>> createElement() {
    return _NearbyReportsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyReportsProvider &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radiusKm == radiusKm;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);
    hash = _SystemHash.combine(hash, radiusKm.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NearbyReportsRef on AutoDisposeFutureProviderRef<List<Report>> {
  /// The parameter `latitude` of this provider.
  double get latitude;

  /// The parameter `longitude` of this provider.
  double get longitude;

  /// The parameter `radiusKm` of this provider.
  double get radiusKm;
}

class _NearbyReportsProviderElement
    extends AutoDisposeFutureProviderElement<List<Report>>
    with NearbyReportsRef {
  _NearbyReportsProviderElement(super.provider);

  @override
  double get latitude => (origin as NearbyReportsProvider).latitude;
  @override
  double get longitude => (origin as NearbyReportsProvider).longitude;
  @override
  double get radiusKm => (origin as NearbyReportsProvider).radiusKm;
}

String _$filteredReportsHash() => r'5965e71054aae38cd9c4bb2904e69c30bb6c2a89';

/// See also [filteredReports].
@ProviderFor(filteredReports)
const filteredReportsProvider = FilteredReportsFamily();

/// See also [filteredReports].
class FilteredReportsFamily extends Family<AsyncValue<List<Report>>> {
  /// See also [filteredReports].
  const FilteredReportsFamily();

  /// See also [filteredReports].
  FilteredReportsProvider call({
    ReportCategory? category,
    ReportStatus? status,
    ReportPriority? priority,
    DateTime? fromDate,
    DateTime? toDate,
    bool? hasImages,
  }) {
    return FilteredReportsProvider(
      category: category,
      status: status,
      priority: priority,
      fromDate: fromDate,
      toDate: toDate,
      hasImages: hasImages,
    );
  }

  @override
  FilteredReportsProvider getProviderOverride(
    covariant FilteredReportsProvider provider,
  ) {
    return call(
      category: provider.category,
      status: provider.status,
      priority: provider.priority,
      fromDate: provider.fromDate,
      toDate: provider.toDate,
      hasImages: provider.hasImages,
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
  String? get name => r'filteredReportsProvider';
}

/// See also [filteredReports].
class FilteredReportsProvider extends AutoDisposeFutureProvider<List<Report>> {
  /// See also [filteredReports].
  FilteredReportsProvider({
    ReportCategory? category,
    ReportStatus? status,
    ReportPriority? priority,
    DateTime? fromDate,
    DateTime? toDate,
    bool? hasImages,
  }) : this._internal(
          (ref) => filteredReports(
            ref as FilteredReportsRef,
            category: category,
            status: status,
            priority: priority,
            fromDate: fromDate,
            toDate: toDate,
            hasImages: hasImages,
          ),
          from: filteredReportsProvider,
          name: r'filteredReportsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredReportsHash,
          dependencies: FilteredReportsFamily._dependencies,
          allTransitiveDependencies:
              FilteredReportsFamily._allTransitiveDependencies,
          category: category,
          status: status,
          priority: priority,
          fromDate: fromDate,
          toDate: toDate,
          hasImages: hasImages,
        );

  FilteredReportsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
    required this.status,
    required this.priority,
    required this.fromDate,
    required this.toDate,
    required this.hasImages,
  }) : super.internal();

  final ReportCategory? category;
  final ReportStatus? status;
  final ReportPriority? priority;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool? hasImages;

  @override
  Override overrideWith(
    FutureOr<List<Report>> Function(FilteredReportsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredReportsProvider._internal(
        (ref) => create(ref as FilteredReportsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
        status: status,
        priority: priority,
        fromDate: fromDate,
        toDate: toDate,
        hasImages: hasImages,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Report>> createElement() {
    return _FilteredReportsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredReportsProvider &&
        other.category == category &&
        other.status == status &&
        other.priority == priority &&
        other.fromDate == fromDate &&
        other.toDate == toDate &&
        other.hasImages == hasImages;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, priority.hashCode);
    hash = _SystemHash.combine(hash, fromDate.hashCode);
    hash = _SystemHash.combine(hash, toDate.hashCode);
    hash = _SystemHash.combine(hash, hasImages.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FilteredReportsRef on AutoDisposeFutureProviderRef<List<Report>> {
  /// The parameter `category` of this provider.
  ReportCategory? get category;

  /// The parameter `status` of this provider.
  ReportStatus? get status;

  /// The parameter `priority` of this provider.
  ReportPriority? get priority;

  /// The parameter `fromDate` of this provider.
  DateTime? get fromDate;

  /// The parameter `toDate` of this provider.
  DateTime? get toDate;

  /// The parameter `hasImages` of this provider.
  bool? get hasImages;
}

class _FilteredReportsProviderElement
    extends AutoDisposeFutureProviderElement<List<Report>>
    with FilteredReportsRef {
  _FilteredReportsProviderElement(super.provider);

  @override
  ReportCategory? get category => (origin as FilteredReportsProvider).category;
  @override
  ReportStatus? get status => (origin as FilteredReportsProvider).status;
  @override
  ReportPriority? get priority => (origin as FilteredReportsProvider).priority;
  @override
  DateTime? get fromDate => (origin as FilteredReportsProvider).fromDate;
  @override
  DateTime? get toDate => (origin as FilteredReportsProvider).toDate;
  @override
  bool? get hasImages => (origin as FilteredReportsProvider).hasImages;
}

String _$reportsSearchHash() => r'16c2b4ba98ebf5f8216e767f70a823feea9e7951';

/// See also [ReportsSearch].
@ProviderFor(ReportsSearch)
final reportsSearchProvider =
    AutoDisposeAsyncNotifierProvider<ReportsSearch, List<Report>>.internal(
  ReportsSearch.new,
  name: r'reportsSearchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportsSearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReportsSearch = AutoDisposeAsyncNotifier<List<Report>>;
String _$reportSubmissionHash() => r'6e1329ab5806e827ee63fc2ceb82e897ef756fc3';

/// See also [ReportSubmission].
@ProviderFor(ReportSubmission)
final reportSubmissionProvider =
    AutoDisposeNotifierProvider<ReportSubmission, AsyncValue<Report?>>.internal(
  ReportSubmission.new,
  name: r'reportSubmissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportSubmissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReportSubmission = AutoDisposeNotifier<AsyncValue<Report?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
