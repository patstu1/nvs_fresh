import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalChatPage extends ConsumerStatefulWidget {
  const GlobalChatPage({super.key});

  @override
  ConsumerState<GlobalChatPage> createState() => _GlobalChatPageState();
}

class _GlobalChatPageState extends ConsumerState<GlobalChatPage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedRoom = 'general';
  bool _showPrivateAlbums = false;
  bool _isTyping = false;

  late AnimationController _yoAnimationController;
  late AnimationController _favoriteAnimationController;
  late Animation<double> _yoAnimation;
  late Animation<double> _favoriteAnimation;

  final List<Map<String, dynamic>> _rooms = <Map<String, dynamic>>[
    <String, dynamic>{'id': 'general', 'name': 'General', 'icon': '🌍', 'color': Colors.blue},
    <String, dynamic>{'id': 'top', 'name': 'Tops', 'icon': '🔥', 'color': Colors.red},
    <String, dynamic>{'id': 'dom', 'name': 'Doms', 'icon': '👑', 'color': Colors.purple},
    <String, dynamic>{'id': 'twink', 'name': 'Twinks', 'icon': '✨', 'color': Colors.pink},
    <String, dynamic>{'id': 'bear', 'name': 'Bears', 'icon': '🐻', 'color': Colors.brown},
    <String, dynamic>{'id': 'vers', 'name': 'Vers', 'icon': '🔄', 'color': Colors.green},
    <String, dynamic>{'id': 'dating', 'name': 'Dating', 'icon': '💕', 'color': Colors.pink},
    <String, dynamic>{'id': 'hookup', 'name': 'Hookup', 'icon': '🔥', 'color': Colors.orange},
  ];

  final List<String> _favoriteUsers = <String>[];
  final Map<String, bool> _yoSentUsers = <String, bool>{};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadFavorites();
  }

  void _initializeAnimations() {
    _yoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _yoAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _yoAnimationController, curve: Curves.elasticOut),
    );

    _favoriteAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _favoriteAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _loadFavorites() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();

      setState(() {
        _favoriteUsers.clear();
        _favoriteUsers
            .addAll(doc.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => doc.id));
      });
    } catch (e) {
      // Handle Firebase errors gracefully
      print('Error loading favorites: $e');
    }
  }

  Future<void> _toggleFavorite(String userId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _favoriteAnimationController.forward().then((_) {
      _favoriteAnimationController.reverse();
    });

    if (_favoriteUsers.contains(userId)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(userId)
          .delete();

      setState(() {
        _favoriteUsers.remove(userId);
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(userId)
          .set(<String, dynamic>{
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _favoriteUsers.add(userId);
      });
    }
  }

  Future<void> _sendYO(String targetUserId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _yoAnimationController.forward().then((_) {
      _yoAnimationController.reverse();
    });

    // Send YO notification
    await FirebaseFirestore.instance.collection('notifications').add(<String, dynamic>{
      'type': 'yo',
      'senderId': user.uid,
      'receiverId': targetUserId,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });

    setState(() {
      _yoSentUsers[targetUserId] = true;
    });

    // Reset after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _yoSentUsers.remove(targetUserId);
        });
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(_selectedRoom)
        .collection('messages')
        .add(<String, dynamic>{
      'senderId': user.uid,
      'message': _messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _yoAnimationController.dispose();
    _favoriteAnimationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          // Header with room selector
          _buildHeader(),

          // Messages
          Expanded(
            child: _buildMessages(),
          ),

          // Input area
          _buildInputArea(),

          // Symbol toolbar
          _buildSymbolToolbar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Column(
        children: <Widget>[
          // Room selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _rooms.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> room = _rooms[index];
                final bool isSelected = room['id'] == _selectedRoom;

                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRoom = room['id'];
                        });
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? room['color'].withValues(alpha: 0.2) : Colors.grey[900],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? room['color'] : Colors.grey[700]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              room['icon'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              room['name'],
                              style: TextStyle(
                                color: isSelected ? room['color'] : Colors.white,
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Private albums toggle
          Row(
            children: <Widget>[
              const Icon(Icons.photo_library, color: Color(0xFF4BEFE0), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Private Albums',
                style: TextStyle(
                  color: Color(0xFF4BEFE0),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Switch(
                value: _showPrivateAlbums,
                onChanged: (bool value) {
                  setState(() {
                    _showPrivateAlbums = value;
                  });
                },
                activeThumbColor: const Color(0xFF4BEFE0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(_selectedRoom)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error loading messages',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4BEFE0)),
          );
        }

        final List<QueryDocumentSnapshot<Object?>> messages =
            snapshot.data?.docs ?? <QueryDocumentSnapshot<Object?>>[];

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> message = messages[index].data() as Map<String, dynamic>;
            return _buildMessageItem(message, messages[index].id);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message, String messageId) {
    final bool isMyMessage = message['senderId'] == FirebaseAuth.instance.currentUser?.uid;
    final String senderId = message['senderId'] as String;
    final bool isFavorite = _favoriteUsers.contains(senderId);
    final bool hasYoSent = _yoSentUsers[senderId] ?? false;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(senderId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> userSnapshot) {
        final Map<String, dynamic>? userData = userSnapshot.data?.data() as Map<String, dynamic>?;
        final displayName = userData?['displayName'] ?? 'Unknown User';
        final profileImage = userData?['profileImage'];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isMyMessage) ...<Widget>[
                // User avatar
                GestureDetector(
                  onTap: () => _showUserProfile(userData, senderId),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: profileImage != null ? NetworkImage(profileImage) : null,
                    child:
                        profileImage == null ? const Icon(Icons.person, color: Colors.white) : null,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    if (!isMyMessage)
                      Row(
                        children: <Widget>[
                          Text(
                            displayName,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          // YO button
                          AnimatedBuilder(
                            animation: _yoAnimation,
                            builder: (BuildContext context, Widget? child) {
                              return Transform.scale(
                                scale: hasYoSent ? _yoAnimation.value : 1.0,
                                child: IconButton(
                                  onPressed: hasYoSent ? null : () => _sendYO(senderId),
                                  icon: Icon(
                                    hasYoSent ? Icons.favorite : Icons.pan_tool,
                                    color: hasYoSent ? Colors.red : const Color(0xFF4BEFE0),
                                    size: 20,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Favorite button
                          AnimatedBuilder(
                            animation: _favoriteAnimation,
                            builder: (BuildContext context, Widget? child) {
                              return Transform.scale(
                                scale: _favoriteAnimation.value,
                                child: IconButton(
                                  onPressed: () => _toggleFavorite(senderId),
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey,
                                    size: 20,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: 4),

                    // Message bubble
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isMyMessage ? const Color(0xFF4BEFE0) : Colors.grey[900],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isMyMessage ? const Color(0xFF4BEFE0) : Colors.grey[700]!,
                        ),
                      ),
                      child: Text(
                        message['message'] ?? '',
                        style: TextStyle(
                          color: isMyMessage ? Colors.black : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Timestamp
                    Text(
                      _formatTimestamp(message['timestamp']),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isMyMessage) ...<Widget>[
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                      ? NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                        )
                      : null,
                  child: FirebaseAuth.instance.currentUser?.photoURL == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Private album button
          if (_showPrivateAlbums)
            IconButton(
              onPressed: () {
                // Show private album picker
              },
              icon: const Icon(Icons.photo_library, color: Color(0xFF4BEFE0)),
            ),

          // Message input
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Color(0xFF4BEFE0)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onChanged: (String value) {
                setState(() {
                  _isTyping = value.isNotEmpty;
                });
              },
            ),
          ),

          const SizedBox(width: 12),

          // Send button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: _isTyping ? _sendMessage : null,
              icon: Icon(
                _isTyping ? Icons.send : Icons.send,
                color: _isTyping ? const Color(0xFF4BEFE0) : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildToolbarButton('🌍', 'Global', () {}),
          _buildToolbarButton('💬', 'Chat', () {}),
          _buildToolbarButton('🫱', 'YO', () {}),
          _buildToolbarButton('💚', 'Favorites', () {}),
          _buildToolbarButton('👤', 'Profile', () {}),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(String icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showUserProfile(Map<String, dynamic>? userData, String userId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => _buildUserProfileSheet(userData, userId),
    );
  }

  Widget _buildUserProfileSheet(Map<String, dynamic>? userData, String userId) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: userData?['profileImage'] != null
                      ? NetworkImage(userData!['profileImage'])
                      : null,
                  child: userData?['profileImage'] == null
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  userData?['displayName'] ?? 'Unknown User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userData?['bio'] ?? 'No bio available',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _sendYO(userId),
                        icon: const Text('🫱', style: TextStyle(fontSize: 20)),
                        label: const Text('YO'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4BEFE0),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _toggleFavorite(userId),
                        icon: Icon(
                          _favoriteUsers.contains(userId) ? Icons.favorite : Icons.favorite_border,
                        ),
                        label: const Text('Favorite'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4BEFE0),
                          side: const BorderSide(color: Color(0xFF4BEFE0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final DateTime now = DateTime.now();
      final Duration diff = now.difference(timestamp.toDate());

      if (diff.inDays > 0) {
        return '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    }
    return 'Unknown';
  }
}
