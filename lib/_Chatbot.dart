import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> with TickerProviderStateMixin {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final List<String> quickReplies = [
    "Cleaning",
    "Plumbing",
    "Moving",
    "Handyman",
    "Delivery"
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true, animation: null));
      _isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

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
            {
              "role": "system",
              "content":
              "You are a helpful assistant for a task booking app. Guide the user to book tasks with date and time."
            },
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
        final animController = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );
        _messages.add(_ChatMessage(
          text: reply,
          isUser: false,
          animation: animController,
        ));
        animController.forward();
        _isLoading = false;
      });

      _scrollToBottom();
      _checkForBookingIntent(text + " " + reply);
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(
          text: "Something went wrong. Please try again.",
          isUser: false,
          animation: null,
        ));
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
          _messages.add(_ChatMessage(
            text: result,
            isUser: false,
            animation: AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            )..forward(),
          ));
        });
        _scrollToBottom();
      }
    }
  }

  void _handleQuickReply(String text) {
    _sendMessage("I want to book $text");
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    for (var msg in _messages) {
      msg.animation?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("TaskBot"),
        backgroundColor: const Color(0xFF007EA7),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return message.animation != null
                    ? AnimatedBuilder(
                  animation: message.animation!,
                  builder: (context, child) {
                    return Opacity(
                      opacity: message.animation!.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - message.animation!.value)),
                        child: _buildMessageBubble(message),
                      ),
                    );
                  },
                )
                    : _buildMessageBubble(message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
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
                    backgroundColor: const Color(0xFFB2DFDB),
                    labelStyle: const TextStyle(color: Color(0xFF007EA7)),
                    onPressed: () => _handleQuickReply(reply),
                  );
                }).toList(),
              ),
            ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF007EA7) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(1, 2),
            )
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _sendMessage,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF007EA7)),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final AnimationController? animation;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.animation,
  });
}
