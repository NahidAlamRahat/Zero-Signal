import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/gen/assets.gen.dart';

import '../../constant/app_icon_path.dart';
import 'controller/chat_controller.dart';
import 'model/chat_model.dart';

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
  static const Color otherUserBubbleColor = Color(0xFFFFFFFF);
  static const Color buttonBackgroundColor = Color(0xFFE4E7E4);
  static const Color iconColor = Color(0xFF044A42);
  static const Color borderColor = Color(0xFFD4CBB0);

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
            // In a real app, you'd use Navigator.pop(context)
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
                    'Hiking Adventure',
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
                          '${controller.participants.length} participants',
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
              onPressed: () {},
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
      // Sort messages by timestamp, descending (newest first)
      // This is safer than relying on list order.
      final sortedMessages = controller.messages.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

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
    final isMe = message.isCurrentUser;
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    // Kept your bubble color change
    final bubbleColor = isMe ? currentUserBubbleColor : backgroundColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show avatar if not the current user
              if (!isMe)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: buttonBackgroundColor,
                  child: ClipOval(
                    child: Image.network(
                      message.avatarUrl,
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
                        message.username,
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
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Text(
                        message.text,
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
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
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
                  hintText: 'Compose your message...',
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

          // Mic button
          _buildImageIconButton(Assets.icons.microphoneIcon.path, () {
            debugPrint('Mic button pressed');
          }),

          // Send button
          _buildImageIconButton(Assets.icons.sendIcon.path, () {
            if (_messageController.text.isNotEmpty) {
              // --- UPDATE ---
              // Use the controller to send the message
              controller.sendMessage(_messageController.text);
              _messageController.clear();
              // Scroll to the bottom to show the new message
              _scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }),
        ],
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
    // Get screen size for responsiveness
    final screenSize = MediaQuery.of(context).size;

    // Use a smaller width on tablets/large screens,
    // and a percentage of the screen width on smaller phones.
    final double dialogWidth = screenSize.width > 600
        ? 500
        : screenSize.width * 0.9;

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
            // Pass the controller to the dialog content
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
  const _ParticipantsDialogContent({super.key, required this.controller});

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
              const Text(
                'Participants',
                style: TextStyle(
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
                            participant.avatarUrl,
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
                            participant.username,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: _ChatScreenState.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${participant.age} years old',
                            style: const TextStyle(
                              fontSize: 14,
                              color: _ChatScreenState.secondaryTextColor,
                            ),
                          ),
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
