import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as picker;
import 'dart:io';

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({super.key});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _replyingTo;
  bool _isSearching = false;
  List<ChatMessage> _searchResults = [];
  final List<String> _reactions = [
    '👍', '❤️', '😂', '��', '😢', '👏'
  ];
  final List<ChatRoom> _chatRooms = [
    ChatRoom(
      id: '1',
      name: 'General Discussion',
      lastMessage: 'Welcome to the general chat!',
      unreadCount: 0,
      isActive: true,
      participants: 128,
      isOnline: true,
    ),
    ChatRoom(
      id: '2',
      name: 'Tutors & Students',
      lastMessage: 'Any questions about tutoring?',
      unreadCount: 2,
      isActive: true,
      participants: 45,
      isOnline: true,
    ),
    ChatRoom(
      id: '3',
      name: 'Pet Care Community',
      lastMessage: 'Share your pet care tips!',
      unreadCount: 5,
      isActive: true,
      participants: 89,
      isOnline: false,
    ),
    ChatRoom(
      id: '4',
      name: 'Wellness & Coaching',
      lastMessage: 'New meditation session tomorrow',
      unreadCount: 1,
      isActive: true,
      participants: 67,
      isOnline: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialMessages() {
    _messages.addAll([
      ChatMessage(
        text: 'Welcome to the chatroom!',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        status: MessageStatus.read,
        reactions: {'👍': 2, '❤️': 1},
      ),
      ChatMessage(
        text: 'Hello everyone!',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        text: 'How can I help you today?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        status: MessageStatus.delivered,
      ),
    ]);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
          status: MessageStatus.sent,
          replyTo: _replyingTo,
        ),
      );
      _replyingTo = null;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Thanks for your message! How can I assist you?",
            isUser: false,
            timestamp: DateTime.now(),
            status: MessageStatus.sent,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _showMessageActions(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.reply),
            title: const Text('Reply'),
            onTap: () {
              setState(() => _replyingTo = message.text);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.forward),
            title: const Text('Forward'),
            onTap: () {
              // TODO: Implement forward functionality
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy'),
            onTap: () {
              // TODO: Implement copy functionality
              Navigator.pop(context);
            },
          ),
          if (message.isUser)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                setState(() => _messages.remove(message));
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  void _showReactionPicker(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Reaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _reactions.map((emoji) => _buildReactionButton(emoji, message)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(String emoji, ChatMessage message) {
    return InkWell(
      onTap: () {
        setState(() {
          if (message.reactions.containsKey(emoji)) {
            message.reactions[emoji] = (message.reactions[emoji] ?? 0) + 1;
          } else {
            message.reactions[emoji] = 1;
          }
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _pickFile() async {
    try {
      picker.FilePickerResult? result = await picker.FilePicker.platform.pickFiles(
        type: picker.FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        setState(() {
          _messages.add(
            ChatMessage(
              text: 'Sent a file: ${result.files.single.name}',
              isUser: true,
              timestamp: DateTime.now(),
              status: MessageStatus.sent,
              attachment: ChatAttachment(
                name: result.files.single.name,
                size: result.files.single.size,
                path: result.files.single.path!,
                type: _getFileType(result.files.single.extension ?? ''),
              ),
            ),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  AttachmentType _getFileType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return AttachmentType.image;
      case 'mp4':
      case 'mov':
      case 'avi':
        return AttachmentType.video;
      case 'mp3':
      case 'wav':
      case 'm4a':
        return AttachmentType.audio;
      case 'pdf':
      case 'doc':
      case 'docx':
        return AttachmentType.document;
      default:
        return AttachmentType.other;
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchResults.clear();
      }
    });
  }

  void _searchMessages(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults.clear());
      return;
    }

    setState(() {
      _searchResults = _messages.where((message) {
        return message.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search messages...',
                  border: InputBorder.none,
                ),
                onChanged: _searchMessages,
              )
            : const Text('Chatrooms'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // TODO: Implement video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // TODO: Implement audio call
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement new chatroom creation
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching && _searchResults.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[100],
              child: Text(
                'Found ${_searchResults.length} messages',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          // Chatroom List
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _chatRooms.length,
              itemBuilder: (context, index) {
                final room = _chatRooms[index];
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: room.isActive ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: room.isActive ? Theme.of(context).colorScheme.primary : Colors.grey[300]!,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 4),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                room.name[0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            if (room.isOnline)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          room.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: room.isActive ? Theme.of(context).colorScheme.primary : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${room.participants} members',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (room.unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${room.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _isSearching ? _searchResults.length : _messages.length,
              itemBuilder: (context, index) {
                final message = _isSearching ? _searchResults[index] : _messages[index];
                return Column(
                  crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (message.replyTo != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Replying to: ${message.replyTo}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    GestureDetector(
                      onLongPress: () => _showMessageActions(message),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.attachment != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getFileIcon(message.attachment!.type),
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.attachment!.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _formatFileSize(message.attachment!.size),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            Text(
                              message.text,
                              style: TextStyle(
                                color: message.isUser ? Colors.white : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTimestamp(message.timestamp),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: message.isUser ? Colors.white70 : Colors.grey[600],
                                  ),
                                ),
                                if (message.isUser) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    message.status == MessageStatus.read
                                        ? Icons.done_all
                                        : message.status == MessageStatus.delivered
                                            ? Icons.done_all
                                            : Icons.done,
                                    size: 16,
                                    color: message.status == MessageStatus.read
                                        ? Colors.blue
                                        : message.isUser
                                            ? Colors.white70
                                            : Colors.grey[600],
                                  ),
                                ],
                              ],
                            ),
                            if (message.reactions.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: message.reactions.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Text(
                                        '${entry.key} ${entry.value}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!message.isUser)
                          GestureDetector(
                            onTap: () => _showReactionPicker(message),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('React', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          if (_isTyping)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[100],
              child: const Row(
                children: [
                  SizedBox(width: 8),
                  Text('Someone is typing...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          // Message Input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _pickFile,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (text) {
                      setState(() => _isTyping = text.isNotEmpty);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.video:
        return Icons.video_file;
      case AttachmentType.audio:
        return Icons.audio_file;
      case AttachmentType.document:
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

enum AttachmentType {
  image,
  video,
  audio,
  document,
  other,
}

class ChatAttachment {
  final String name;
  final int size;
  final String path;
  final AttachmentType type;

  ChatAttachment({
    required this.name,
    required this.size,
    required this.path,
    required this.type,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;
  final String? replyTo;
  final Map<String, int> reactions;
  final ChatAttachment? attachment;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.replyTo,
    Map<String, int>? reactions,
    this.attachment,
  }) : reactions = reactions ?? {};
}

enum MessageStatus {
  sent,
  delivered,
  read,
}

class ChatRoom {
  final String id;
  final String name;
  final String lastMessage;
  final int unreadCount;
  final bool isActive;
  final int participants;
  final bool isOnline;

  ChatRoom({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unreadCount,
    required this.isActive,
    required this.participants,
    required this.isOnline,
  });
} 