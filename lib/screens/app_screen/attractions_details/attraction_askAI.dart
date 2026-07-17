// import 'package:flutter/material.dart';
//
// import '../../../admin_app/models/attraction_model.dart';
// import '../../../services/gemini_service.dart';
// class AttractionAskAi extends StatefulWidget {
//   final AttractionModel attraction;
//
//   const AttractionAskAi({
//     super.key,
//     required this.attraction,
//   });
//
//
//   @override
//   State<AttractionAskAi> createState() => _AttractionAskAiState();
// }
//
//
//
// class _AttractionAskAiState extends State<AttractionAskAi> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () async {
//
//               final response =
//               await GeminiService()
//                   .askAttractionQuestion(
//                 attraction: widget.attraction,
//                 question: 'What is this attraction?',
//               );
//
//               print(response);
//             },
//             child: const Text('Test Gemini'),
//           )
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

import '../../../admin_app/models/attraction_model.dart';
import '../../../services/gemini_service.dart';
import '../../app_models/chat_message.dart';

const Color _kPrimary = Color(0xFF14B8A6);

class AttractionAskAi extends StatefulWidget {
  final AttractionModel attraction;

  const AttractionAskAi({super.key, required this.attraction});

  @override
  State<AttractionAskAi> createState() => _AttractionAskAiState();
}

class _AttractionAskAiState extends State<AttractionAskAi> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text: "Hi! Ask me anything about ${widget.attraction.name}.",
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final question = _inputController.text.trim();
    if (question.isEmpty || _isSending) return;

    setState(() {
      _messages.add(ChatMessage(text: question, isUser: true));
      _isSending = true;
      _inputController.clear();
    });
    _scrollToBottom();

    try {
      // Assumes askAttractionQuestion returns a String — adjust if it doesn't.
      final response = await GeminiService().askAttractionQuestion(
        attraction: widget.attraction,
        question: question,
      );

      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Sorry, something went wrong. Please try again.",
            isUser: false,
          ),
        );
      });
    } finally {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: _messages.length + (_isSending ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) return _buildTypingBubble();
              return _buildBubble(_messages[index]);
            },
          ),
        ),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? _kPrimary : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: _kPrimary),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Ask about this place...",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: _kPrimary, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}