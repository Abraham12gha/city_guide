import 'package:flutter/material.dart';

import '../../../admin_app/models/attraction_model.dart';
import '../../../services/gemini_service.dart';
class AttractionAskAi extends StatefulWidget {
  final AttractionModel attraction;

  const AttractionAskAi({
    super.key,
    required this.attraction,
  });


  @override
  State<AttractionAskAi> createState() => _AttractionAskAiState();
}



class _AttractionAskAiState extends State<AttractionAskAi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {

              final response =
              await GeminiService()
                  .askAttractionQuestion(
                attraction: widget.attraction,
                question: 'What is this attraction?',
              );

              print(response);
            },
            child: const Text('Test Gemini'),
          )
        ],
      ),
    );
  }
}