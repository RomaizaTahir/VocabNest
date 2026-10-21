
import '../data/vocabulary_data.dart';
import '../models/vocabulary_word.dart';

class DictionaryService {
  List<VocabularyWord> search(String query) {
    final text = query.trim().toLowerCase();

    if (text.isEmpty) {
      return vocabularyWords;
    }

    return vocabularyWords.where((word) {
      return word.word.toLowerCase().contains(text) ||
          word.meaning.toLowerCase().contains(text) ||
          word.example.toLowerCase().contains(text) ||
          word.category.toLowerCase().contains(text);
    }).toList();
  }
}
