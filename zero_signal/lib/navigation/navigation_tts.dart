import 'package:flutter_tts/flutter_tts.dart';

class NavigationTTS {
  final FlutterTts _tts = FlutterTts();
  String? _lastInstruction;

  NavigationTTS() {
    _initTTS();
  }

  Future<void> _initTTS() async {
    try {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
    } catch (e) {
      print(
          "TTS Initialization failed: $e. Rebuild the app if this is a MissingPluginException.");
    }
  }

  Future<void> speak(String text) async {
    // Avoid repeating the same instruction immediately
    if (text == _lastInstruction) return;

    _lastInstruction = text;
    await _tts.speak(text);
  }

  void stop() {
    _tts.stop();
  }
}
