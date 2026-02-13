import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ResultScreen extends StatelessWidget {
  final String notes;
  final String studentLevel;

  const ResultScreen({
    super.key,
    required this.notes,
    required this.studentLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$studentLevel Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Markdown(
        data: notes,
        padding: const EdgeInsets.all(16.0),
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          p: const TextStyle(fontSize: 16, height: 1.5),
          listBullet: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
