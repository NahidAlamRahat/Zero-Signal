import 'package:get/get.dart';

import '../model/chat_model.dart';

class ChatController extends GetxController {
  // --- OBSERVABLE LISTS ---
  // These lists will hold our data and notify widgets when they change.
  final RxList<Participant> participants = <Participant>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load the mock data when the controller is initialized
    _loadMockData();
  }

  void _loadMockData() {
    // Assign the mock data to the observable lists
    participants.assignAll([
      Participant(
        userId: 'p1',
        username: '@mountainrose',
        avatarUrl: 'https://placehold.co/100x100/A9B6A3/333333?text=MR',
        age: 28,
      ),
      Participant(
        userId: 'p2',
        username: '@natureenthusiast',
        avatarUrl: 'https://placehold.co/100x100/7E8D85/333333?text=NE',
        age: 32,
      ),
      Participant(
        userId: 'p3',
        username: '@peaktrekker',
        avatarUrl: 'https://placehold.co/100x100/D4CBB0/333333?text=PT',
        age: 25,
      ),
      Participant(
        userId: 'p4',
        username: '@adventureseeker',
        avatarUrl: 'https://placehold.co/100x100/E0B8A9/333333?text=AS',
        age: 30,
      ),
    ]);

    messages.assignAll([
      ChatMessage(
        id: 'm1',
        userId: 'p3',
        username: '@peaktrekker',
        avatarUrl: 'https://placehold.co/100x100/D4CBB0/333333?text=PT',
        text: 'Looking forward to our hike this weekend!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: 'm2',
        userId: 'p3',
        username: '@peaktrekker',
        avatarUrl: 'https://placehold.co/100x100/D4CBB0/333333?text=PT',
        text:
            "We'll meet at the trailhead at 9AM. Don't forget to bring enough water!",
        timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
      ),
      ChatMessage(
        id: 'm3',
        userId: 'p1',
        username: '@mountainrose',
        avatarUrl: 'https://placehold.co/100x100/A9B6A3/333333?text=MR',
        text: 'Sounds great! I\'ll be bringing snacks for everyone.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
      ),
      ChatMessage(
        id: 'm4',
        userId: 'me', // Current user
        username: 'Me',
        avatarUrl: '', // Not needed for current user
        text: 'I\'ll definitely be there.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        isCurrentUser: true,
      ),
      ChatMessage(
        id: 'm5',
        userId: 'p2',
        username: '@natureenthusiast',
        avatarUrl: 'https://placehold.co/100x100/7E8D85/333333?text=NE',
        text: 'Can\'t wait! I\'ll bring a first aid kit just in case.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ]);
  }

  // --- METHODS TO MANIPULATE DATA ---
  // Example: How you would add a new message
  void sendMessage(String text) {
    final newMessage = ChatMessage(
      id: 'm${messages.length + 1}', // Simple unique ID
      userId: 'me', // Current user
      username: 'Me',
      avatarUrl: '',
      text: text,
      timestamp: DateTime.now(),
      isCurrentUser: true,
    );

    // Add to the list. GetX will automatically update the UI.
    // We insert at index 0 because the list in the UI is reversed.
    messages.insert(0, newMessage);
  }
}
