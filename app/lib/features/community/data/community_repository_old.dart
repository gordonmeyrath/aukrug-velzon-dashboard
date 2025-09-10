import '../../../core/services/content_service.dart';
import '../domain/community_models.dart';

/// Production Community Repository - Leere Implementierung bis API verfügbar
class CommunityRepository {
  final ContentService? _contentService;
  
  CommunityRepository([this._contentService]);

  // Users - Production: Leer bis API verfügbar
  Future<List<CommunityUser>> getUsers() async {
    return _cachedUsers ?? [];
  }

  Future<void> refreshUsers() async {
    // Production: Placeholder für zukünftige API-Integration
    _cachedUsers = [];
  }

  // Groups
  Future<List<CommunityGroup>> getGroups() async {
    if (_cachedGroups == null) {
      await _loadGroups();
    }
    return _cachedGroups ?? [];
  }

  Future<List<CommunityGroup>> getUserJoinedGroups() async {
    final allGroups = await getGroups();
    return allGroups.where((group) => group.isJoined).toList();
  }

  Future<List<CommunityGroup>> getTrendingGroups() async {
    final allGroups = await getGroups();
    // Sortiere nach Mitgliederzahl für trending
    final trending = List<CommunityGroup>.from(allGroups);
    trending.sort((a, b) => b.membersCount.compareTo(a.membersCount));
    return trending.take(5).toList();
  }

  Future<CommunityGroup?> getGroupById(String groupId) async {
    final groups = await getGroups();
    try {
      return groups.firstWhere((group) => group.id == groupId);
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshGroups() async {
    _cachedGroups = null;
    await _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/fixtures/community/groups.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedGroups = jsonList
          .map((json) => CommunityGroup.fromJson(json))
          .toList();
    } catch (e) {
      _cachedGroups = [];
    }
  }

  // Posts/Feed
  Future<List<CommunityPost>> getFeed() async {
    if (_cachedPosts == null) {
      await _loadPosts();
    }
    return _cachedPosts ?? [];
  }

  Future<void> refreshFeed() async {
    _cachedPosts = null;
    await _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/fixtures/community/posts.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedPosts = jsonList
          .map((json) => CommunityPost.fromJson(json))
          .toList();
    } catch (e) {
      _cachedPosts = [];
    }
  }

  // Messages
  Future<List<CommunityConversation>> getConversations() async {
    if (_cachedConversations == null) {
      await _loadConversations();
    }
    return _cachedConversations ?? [];
  }

  Future<List<CommunityMessage>> getMessagesByPeer(String peerId) async {
    if (_cachedMessages == null) {
      await _loadMessages();
    }
    return _cachedMessages
            ?.where(
              (msg) =>
                  msg.senderId == peerId || msg.conversationId.contains(peerId),
            )
            .toList() ??
        [];
  }

  Future<void> refreshMessages() async {
    _cachedMessages = null;
    _cachedConversations = null;
    await _loadMessages();
    await _loadConversations();
  }

  Future<void> _loadMessages() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/fixtures/community/messages.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedMessages = jsonList
          .map((json) => CommunityMessage.fromJson(json))
          .toList();
    } catch (e) {
      _cachedMessages = [];
    }
  }

  Future<void> _loadConversations() async {
    // Erstelle Konversationen basierend auf Nachrichten
    final messages = await getMessagesByPeer('current_user'); // Simuliert
    final conversationMap = <String, List<CommunityMessage>>{};

    for (final message in messages) {
      conversationMap
          .putIfAbsent(message.conversationId, () => [])
          .add(message);
    }

    _cachedConversations = conversationMap.entries.map((entry) {
      final msgs = entry.value;
      msgs.sort((a, b) => b.sentAt.compareTo(a.sentAt));

      return CommunityConversation(
        id: entry.key,
        title: 'Unterhaltung ${entry.key}',
        participantIds: [msgs.first.senderId],
        lastMessage: msgs.first,
        updatedAt: msgs.first.sentAt,
        unreadCount: msgs.where((m) => m.readAt == null).length,
      );
    }).toList();
  }

  // Events
  Future<List<CommunityEvent>> getEvents() async {
    if (_cachedEvents == null) {
      await _loadEvents();
    }
    return _cachedEvents ?? [];
  }

  Future<void> _loadEvents() async {
    // TODO: Implement API integration with ContentService
    _cachedEvents = []; // Production-ready: No hardcoded demo content
  }

  // Marketplace
  Future<List<MarketplaceListing>> getMarketplaceListings() async {
    if (_cachedListings == null) {
      await _loadMarketplaceListings();
    }
    return _cachedListings ?? [];
  }

  Future<void> _loadMarketplaceListings() async {
    // TODO: Implement API integration with ContentService
    _cachedListings = []; // Production-ready: No hardcoded demo content
  }

  // Optimistic Actions
  Future<void> createPost({
    required String content,
    String? groupId,
    required List<String> attachments,
  }) async {
    // Simuliere API-Call
    await Future.delayed(const Duration(milliseconds: 500));

    final newPost = CommunityPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      authorId: 'current_user',
      authorName: 'Du',
      createdAt: DateTime.now(),
      groupId: groupId,
      attachments: attachments,
    );

    _cachedPosts?.insert(0, newPost);
  }

  Future<void> sendMessage({
    required String content,
    required String conversationId,
    required List<String> attachments,
  }) async {
    // Simuliere API-Call
    await Future.delayed(const Duration(milliseconds: 300));

    final newMessage = CommunityMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      senderId: 'current_user',
      senderName: 'Du',
      conversationId: conversationId,
      sentAt: DateTime.now(),
      attachments: attachments,
    );

    _cachedMessages?.add(newMessage);
  }
}
