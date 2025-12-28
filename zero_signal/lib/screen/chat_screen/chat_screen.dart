import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/gen/assets.gen.dart';
import 'controller/chat_controller.dart';
import 'model/chat_model.dart';
import 'widget/audio_player_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // --- CONTROLLERS ---
  // Find (or create) the ChatController instance
  final ChatController controller = Get.put(ChatController());

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Colors based on the image
  static const Color backgroundColor = Color(0xFFFFF4E9);
  static const Color primaryTextColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFF555555);
  static const Color currentUserBubbleColor = Color(0xFFF3EADE);
  static const Color buttonBackgroundColor = Color(0xFFE4E7E4);
  static const Color iconColor = Color(0xFF044A42);
  static const Color borderColor = Color(0xFFD4CBB0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Load more when scrolling to the top (since messages are reversed)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.fetchMessages(isLoadMore: true);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInputArea(),
        ],
      ),
    );
  }

  // Builds the custom AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100), // Kept your preferred height
      child: AppBar(
        backgroundColor: backgroundColor,
        // --- FIX ---
        // Set elevation > 0 for the shadowColor to appear as a border
        elevation: 0,
        shadowColor: borderColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primaryTextColor,
            size: 20,
          ),
          onPressed: () {
            Get.back();
            debugPrint('Back button pressed');
          },
        ),
        centerTitle: true,
        // --- CHANGE: Set title to empty and use flexibleSpace ---
        title: const Text(''), // Set title to empty
        flexibleSpace: SafeArea(
          // Use SafeArea to avoid status bar overlap
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ), // Padding for vertical alignment
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.hikingAdventure,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 20, // Kept your font size
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _showParticipantsDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 1.5),
                        borderRadius: BorderRadius.circular(
                          3,
                        ), // Kept your change (commented out)
                      ),
                      // Use an Obx wrapper to listen for changes to the participants list
                      child: Obx(
                        () => Text(
                          '${controller.participants.length}${AppStrings.participantsSuffix}',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 16, // Kept your font size
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Empty actions to help center the title perfectly
        actions: [
          Opacity(
            opacity: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Builds the list of messages
  Widget _buildMessageList() {
    // We wrap the ListView in an Obx to make it reactive
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(iconColor)),
        );
      }

      // Sort messages by timestamp, descending (newest first)
      // This is safer than relying on list order.
      final sortedMessages = controller.messages.toList()
        ..sort((a, b) {
          if (a.createdAt == null || b.createdAt == null) return 0;
          return DateTime.parse(b.createdAt!)
              .compareTo(DateTime.parse(a.createdAt!));
        });

      if (sortedMessages.isEmpty) {
        return Center(
          child: Text(
            AppStrings.noMessagesYet,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 16,
            ),
          ),
        );
      }

      return ListView.builder(
        controller: _scrollController,
        reverse: true, // Start from the bottom
        padding: const EdgeInsets.all(16),
        itemCount: sortedMessages.length,
        itemBuilder: (context, index) {
          final message = sortedMessages[index];
          return _buildMessageItem(message);
        },
      );
    });
  }

  // Builds a single message bubble
  Widget _buildMessageItem(ChatMessage message) {
    final senderId = message.sender?.id;
    final isMe = controller.isCurrentUser(senderId);

    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    // Kept your bubble color change
    final bubbleColor = isMe ? currentUserBubbleColor : backgroundColor;

    final avatarUrl = message.sender?.image ?? '';
    final username = message.sender?.username ?? 'Unknown';
    final text = message.text ?? '';
    final time = _formatTime(message.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show avatar if not the current user
              if (!isMe)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: buttonBackgroundColor,
                  child: ClipOval(
                    child: Image.network(
                      avatarUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Failed to load avatar: $error');
                        return Container(
                          color: buttonBackgroundColor,
                          child: const Icon(
                            Icons.person,
                            color: iconColor,
                            size: 24,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              iconColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (!isMe) const SizedBox(width: 10),

              // Message content
              Flexible(
                child: Column(
                  crossAxisAlignment: alignment,
                  children: [
                    // Username if not the current user
                    if (!isMe)
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    if (!isMe) const SizedBox(height: 4),

                    // The message bubble
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          if (!isMe)
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: message.type == 'audio'
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: message.isSending ? 0.5 : 1.0,
                                  child: _buildAudioPlayer(message),
                                ),
                                if (message.isSending)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          iconColor),
                                    ),
                                  ),
                              ],
                            )
                          : Text(
                              text.isEmpty ? AppStrings.emptyMessage : text,
                              style: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              // --- UPDATE: Timestamp only shown if !isMe ---
              if (!isMe) ...[
                // Add a small space between message and timestamp
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt).toLocal();
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  Widget _buildAudioPlayer(ChatMessage message) {
    final audioUrl = message.audio;
    if (audioUrl == null || audioUrl.isEmpty) {
      return const Text(
        AppStrings.audioMessage,
        style: TextStyle(
          color: primaryTextColor,
          fontSize: 15,
        ),
      );
    }

    return AudioPlayerWidget(audioUrl: audioUrl);
  }

  // Builds the bottom text input field
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: const Offset(0, -3),
        //   ),
        // ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x00f5e9df),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: AppStrings.composeMessageHint,
                    hintStyle: TextStyle(color: secondaryTextColor),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Mic button with long press
            Obx(() => GestureDetector(
                  onLongPressStart: (_) {
                    controller.startRecording();
                  },
                  onLongPressEnd: (_) {
                    controller.stopRecordingAndSend();
                  },
                  onLongPressCancel: () {
                    controller.cancelRecording();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: controller.isRecording.value
                        ? BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          )
                        : null,
                    child: Image.asset(
                      Assets.icons.microphoneIcon.path,
                      width: 32,
                      height: 32,
                      color: controller.isRecording.value ? Colors.red : null,
                    ),
                  ),
                )),

            // Send button
            _buildImageIconButton(Assets.icons.sendIcon.path, () {
              if (_messageController.text.isNotEmpty) {
                // --- UPDATE ---
                // Use the controller to send the message
                controller.sendMessage(_messageController.text);
                _messageController.clear();
                // Scroll to the bottom to show the new message
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              }
            }),
          ],
        ),
      ),
    );
  }

  // Helper for icon buttons

  // Helper for image icon buttons
  Widget _buildImageIconButton(String assetPath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(assetPath, width: 32, height: 32),
      ),
    );
  }

  // --- PARTICIPANTS DIALOG ---

  void _showParticipantsDialog(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final double dialogWidth =
        screenSize.width > 600 ? 500 : screenSize.width * 0.9;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogWidth,
              maxHeight: screenSize.height * 0.7,
            ),
            child: _ParticipantsDialogContent(controller: controller),
          ),
        );
      },
    );
  }
}

// Content for the participants dialog
class _ParticipantsDialogContent extends StatelessWidget {
  // Receive the controller
  final ChatController controller;
  const _ParticipantsDialogContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.participantsHeader,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: _ChatScreenState.primaryTextColor,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: _ChatScreenState.secondaryTextColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          // List of participants
          // Use Flexible to make the list scrollable if it's too long
          Flexible(
            child: ListView.builder(
              shrinkWrap: true, // Take only necessary space
              // Use the controller's list
              itemCount: controller.participants.length,
              itemBuilder: (context, index) {
                // Get participant from the controller
                final participant = controller.participants[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: _ChatScreenState.buttonBackgroundColor,
                        child: ClipOval(
                          child: Image.network(
                            participant.image ?? '',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Failed to load avatar: $error');
                              return Container(
                                color: _ChatScreenState.buttonBackgroundColor,
                                child: const Icon(
                                  Icons.person,
                                  color: _ChatScreenState.iconColor,
                                  size: 28,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _ChatScreenState.iconColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            participant.username ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: _ChatScreenState.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
