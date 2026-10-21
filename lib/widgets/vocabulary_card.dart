
import 'package:flutter/material.dart';
import '../models/vocabulary_word.dart';

class VocabularyCard extends StatelessWidget {
  final VocabularyWord word;
  final bool learned;
  final bool saved;
  final VoidCallback onLearned;
  final VoidCallback onSaved;
  final VoidCallback onSpeak;

  const VocabularyCard({
    super.key,
    required this.word,
    required this.learned,
    required this.saved,
    required this.onLearned,
    required this.onSaved,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.word,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onSpeak,
                  icon: const Icon(Icons.volume_up_rounded),
                  tooltip: 'Listen',
                ),
                IconButton(
                  onPressed: onSaved,
                  icon: Icon(
                    saved ? Icons.bookmark : Icons.bookmark_border,
                    color: saved ? Colors.deepPurple : null,
                  ),
                  tooltip: 'Save word',
                ),
              ],
            ),
            Text(
              word.meaning,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text('Example: ${word.example}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(word.category)),
                const Spacer(),
                TextButton.icon(
                  onPressed: onLearned,
                  icon: Icon(
                    learned
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                  ),
                  label: Text(learned ? 'Learned' : 'Mark learned'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
