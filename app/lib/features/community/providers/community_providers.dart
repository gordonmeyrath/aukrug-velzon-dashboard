import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/community_repository.dart';
import '../domain/community_models.dart';

// Repository Provider
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository();
});

// User Providers
final usersProvider = FutureProvider<List<CommunityUser>>((ref) async {
  final repository = ref.read(communityRepositoryProvider);
  return repository.getUsers();
});

final refreshUsersProvider = FutureProvider.family<void, void>((ref, _) async {
  final repository = ref.read(communityRepositoryProvider);
  await repository.refreshUsers();
  ref.invalidate(usersProvider);
});

// Groups Providers
final groupsProvider = FutureProvider<List<CommunityGroup>>((ref) async {
  final repository = ref.read(communityRepositoryProvider);
  return repository.getGroups();
});

final userJoinedGroupsProvider = FutureProvider<List<CommunityGroup>>((
  ref,
) async {
  final repository = ref.read(communityRepositoryProvider);
  return repository.getUserJoinedGroups();
});

final trendingGroupsProvider = FutureProvider<List<CommunityGroup>>((
  ref,
) async {
  final repository = ref.read(communityRepositoryProvider);
  return repository.getTrendingGroups();
});

final groupByIdProvider = FutureProvider.family<CommunityGroup?, String>((
  ref,
  groupId,
) async {
  final repository = ref.read(communityRepositoryProvider);
  return repository.getGroupById(groupId);
});

final refreshGroupsProvider = FutureProvider.family<void, void>((ref, _) async {
  final repository = ref.read(communityRepositoryProvider);
  await repository.refreshGroups();
  ref.invalidate(groupsProvider);
  ref.invalidate(userJoinedGroupsProvider);
  ref.invalidate(trendingGroupsProvider);
});

// Posts/Feed Providers
final feedProvider = FutureProvider<List<CommunityPost>>((ref) async {
  final repository = ref.read(communityRepositoryProvider);
  return repository.getFeed();
});

final refreshFeedProvider = FutureProvider.family<void, void>((ref, _) async {
  final repository = ref.read(communityRepositoryProvider);
  await repository.refreshFeed();
  ref.invalidate(feedProvider);
});

// Messages Providers
final messagesProvider = FutureProvider<List<CommunityConversation>>((
  ref,
) async {
  final repository = ref.read(communityRepositoryProvider);
  return repository.getConversations();
});

final chatByPeerProvider =
    FutureProvider.family<List<CommunityMessage>, String>((ref, peerId) async {
      final repository = ref.read(communityRepositoryProvider);
      return repository.getMessagesByPeer(peerId);
    });

final refreshMessagesProvider = FutureProvider.family<void, void>((
  ref,
  _,
) async {
  final repository = ref.read(communityRepositoryProvider);
  await repository.refreshMessages();
  ref.invalidate(messagesProvider);
});

// Events Provider
final eventsProvider = FutureProvider<List<CommunityEvent>>((ref) async {
  final repository = ref.read(communityRepositoryProvider);
  return repository.getEvents();
});

final refreshEventsProvider = FutureProvider.family<void, String?>((
  ref,
  _,
) async {
  ref.invalidate(eventsProvider);
});

// Marketplace Provider
final marketplaceProvider = FutureProvider<List<MarketplaceListing>>((
  ref,
) async {
  final repository = ref.read(communityRepositoryProvider);
  return repository.getMarketplaceListings();
});

final refreshMarketplaceProvider = FutureProvider.family<void, String?>((
  ref,
  _,
) async {
  ref.invalidate(marketplaceProvider);
});

// Filter/Search State
final groupFiltersProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// Optimistic Actions
final createPostControllerProvider =
    StateNotifierProvider<CreatePostController, AsyncValue<void>>((ref) {
      final repository = ref.read(communityRepositoryProvider);
      return CreatePostController(repository, ref);
    });

final sendMessageControllerProvider =
    StateNotifierProvider<SendMessageController, AsyncValue<void>>((ref) {
      final repository = ref.read(communityRepositoryProvider);
      return SendMessageController(repository, ref);
    });

class CreatePostController extends StateNotifier<AsyncValue<void>> {
  final CommunityRepository _repository;
  final Ref _ref;

  CreatePostController(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> createPost({
    required String content,
    String? groupId,
    List<String>? attachments,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _repository.createPost(
        content: content,
        groupId: groupId,
        attachments: attachments ?? [],
      );

      // Refresh feed after successful post creation
      _ref.invalidate(feedProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class SendMessageController extends StateNotifier<AsyncValue<void>> {
  final CommunityRepository _repository;
  final Ref _ref;

  SendMessageController(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> sendMessage({
    required String content,
    required String conversationId,
    List<String>? attachments,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _repository.sendMessage(
        content: content,
        conversationId: conversationId,
        attachments: attachments ?? [],
      );

      // Refresh messages after successful send
      _ref.invalidate(messagesProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
