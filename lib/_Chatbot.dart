import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  final List<String> quickReplies = [
    "Cleaning",
    "Plumbing",
    "Moving",
    "Handyman",
    "Delivery"
  ];

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant for a task booking app. When asked about a task, guide the user to book by asking for date and time."},
            ..._messages.map((msg) => {
              "role": msg.isUser ? "user" : "assistant",
              "content": msg.text,
            })
          ],
        }),
      );

      final decoded = json.decode(response.body);
      final reply = decoded['choices'][0]['message']['content'];

      setState(() {
        _messages.add(_ChatMessage(text: reply, isUser: false));
        _isLoading = false;
      });

      _checkForBookingIntent(text + " " + reply);
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(text: "Something went wrong. Please try again.", isUser: false));
        _isLoading = false;
      });
    }
  }

  void _checkForBookingIntent(String combinedText) async {
    final lower = combinedText.toLowerCase();

    String? task;
    if (lower.contains("clean")) task = "Cleaning";
    if (lower.contains("plumb")) task = "Plumbing";
    if (lower.contains("move")) task = "Moving";
    if (lower.contains("handyman")) task = "Handyman";
    if (lower.contains("deliver")) task = "Delivery";

    final timeReg = RegExp(r'\b\d{1,2} ?(am|pm)\b');
    final dateReg = RegExp(r'\b(tomorrow|today|\d{1,2}(st|nd|rd|th)?( of)? \w+)\b', caseSensitive: false);

    final timeMatch = timeReg.firstMatch(combinedText);
    final dateMatch = dateReg.firstMatch(combinedText);

    if (task != null && dateMatch != null && timeMatch != null) {
      final result = await Navigator.pushNamed(
        context,
        '/booking',
        arguments: {
          "service": task,
          "date": dateMatch.group(0),
          "time": timeMatch.group(0),
        },
      );

      if (result != null && result is String) {
        setState(() {
          _messages.add(_ChatMessage(text: result, isUser: false));
        });
      }
    }
  }

  void _handleQuickReply(String text) {
    _sendMessage("I want to book $text");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskBot"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.deepPurple : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          if (!_isLoading && _messages.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: quickReplies.map((reply) {
                  return ActionChip(
                    label: Text(reply),
                    backgroundColor: Colors.deepPurple.shade100,
                    labelStyle: const TextStyle(color: Colors.deepPurple),
                    onPressed: () => _handleQuickReply(reply),
                  );
                }).toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}
