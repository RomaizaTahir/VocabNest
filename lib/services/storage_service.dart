
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _profilesKey = 'vocab_nest_user_profiles_v1';
  static const String _activeUserKey = 'vocab_nest_active_user_v1';

  String _userId(String name) => name.trim().toLowerCase();

  String _today() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  Future<Map<String, dynamic>> _readProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profilesKey);

    if (raw == null || raw.isEmpty) return {};

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}

    return {};
  }

  Future<void> _writeProfiles(
      Map<String, dynamic> profiles,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profilesKey, jsonEncode(profiles));
  }

  Map<String, dynamic> _newProfile(String name) => {
    'name': name.trim(),
    'learnedWords': <String>[],
    'savedWords': <String>[],
    'learnedSentences': <String>[],
    'learnedTenses': <String>[],
    'quizHistory': <Map<String, dynamic>>[],
    'activityHistory': <Map<String, dynamic>>[],
  };

  Future<Map<String, dynamic>> getProfile(String name) async {
    final profiles = await _readProfiles();
    final id = _userId(name);
    final existing = profiles[id];

    final profile = existing is Map
        ? Map<String, dynamic>.from(existing)
        : _newProfile(name);

    profile.putIfAbsent('name', () => name.trim());
    profile.putIfAbsent('learnedWords', () => <String>[]);
    profile.putIfAbsent('savedWords', () => <String>[]);
    profile.putIfAbsent('learnedSentences', () => <String>[]);
    profile.putIfAbsent('learnedTenses', () => <String>[]);
    profile.putIfAbsent('quizHistory', () => <Map<String, dynamic>>[]);
    profile.putIfAbsent('activityHistory', () => <Map<String, dynamic>>[]);

    return profile;
  }

  Future<void> saveProfile(
      String name,
      Map<String, dynamic> profile,
      ) async {
    final profiles = await _readProfiles();
    profiles[_userId(name)] = profile;
    await _writeProfiles(profiles);
  }

  Future<String?> getActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeUserKey);
  }

  Future<void> setActiveUser(String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    final profiles = await _readProfiles();
    profiles.putIfAbsent(
      _userId(cleanName),
          () => _newProfile(cleanName),
    );

    await _writeProfiles(profiles);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeUserKey, cleanName);
  }

  Future<List<String>> getUserNames() async {
    final profiles = await _readProfiles();

    return profiles.values
        .whereType<Map>()
        .map((p) => p['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  Future<List<String>> _getList(
      String name,
      String key,
      ) async {
    final profile = await getProfile(name);
    return List<String>.from(profile[key] ?? <String>[]);
  }

  // Record a learning activity for this particular learner.
  Future<void> recordActivity(
      String name, {
        required String type,
        required String title,
        String? details,
        int? score,
        int? total,
      }) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    final profile = await getProfile(cleanName);

    final history = (profile['activityHistory'] as List? ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    history.add({
      'type': type,
      'title': title,
      'details': details ?? '',
      'date': DateTime.now().toIso8601String(),
      'day': _today(),
      if (score != null) 'score': score,
      if (total != null) 'total': total,
    });

    profile['activityHistory'] = history;
    await saveProfile(cleanName, profile);
  }

  // Newest activity first. Every learner gets their own history.
  Future<List<Map<String, dynamic>>> getActivityHistory(
      String name,
      ) async {
    final profile = await getProfile(name);

    final history = (profile['activityHistory'] as List? ?? [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    history.sort((a, b) {
      final dateA =
          DateTime.tryParse(a['date']?.toString() ?? '') ??
              DateTime(2000);
      final dateB =
          DateTime.tryParse(b['date']?.toString() ?? '') ??
              DateTime(2000);

      return dateB.compareTo(dateA);
    });

    return history;
  }

  // Group history by local calendar date, newest day first.
  Future<Map<String, List<Map<String, dynamic>>>> getDailyHistory(
      String name,
      ) async {
    final history = await getActivityHistory(name);
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final item in history) {
      final date = item['day']?.toString() ??
          (DateTime.tryParse(item['date']?.toString() ?? '')
              ?.toLocal()
              .toIso8601String()
              .substring(0, 10) ??
              'Unknown date');

      grouped.putIfAbsent(date, () => []).add(item);
    }

    return grouped;
  }

  // Compatibility methods used by the existing HomeScreen.
  Future<Set<String>> getLearned() async {
    final name = await getActiveUser() ?? 'Guest';
    return (await _getList(name, 'learnedWords')).toSet();
  }

  Future<Set<String>> getSaved() async {
    final name = await getActiveUser() ?? 'Guest';
    return (await _getList(name, 'savedWords')).toSet();
  }

  Future<void> saveWords(
      Set<String> learned,
      Set<String> saved,
      ) async {
    final name = await getActiveUser() ?? 'Guest';
    final profile = await getProfile(name);
    profile['learnedWords'] = learned.toList();
    profile['savedWords'] = saved.toList();
    await saveProfile(name, profile);
  }

  Future<int> getBestScore() async {
    final name = await getActiveUser() ?? 'Guest';
    final profile = await getProfile(name);

    final history = (profile['quizHistory'] as List? ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    if (history.isEmpty) return 0;

    return history
        .map((item) => (item['score'] as num?)?.toInt() ?? 0)
        .fold<int>(
      0,
          (best, score) => score > best ? score : best,
    );
  }

  Future<int> getQuizCount() async {
    final name = await getActiveUser() ?? 'Guest';
    final profile = await getProfile(name);
    return (profile['quizHistory'] as List? ?? []).length;
  }

  Future<void> saveQuizResult(int score) async {
    final name = await getActiveUser() ?? 'Guest';
    await saveQuizResultForUser(name, score, 10);
  }

  Future<void> saveQuizResultForUser(
      String name,
      int score,
      int total,
      ) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    final profile = await getProfile(cleanName);

    final history = (profile['quizHistory'] as List? ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    final now = DateTime.now();

    history.add({
      'score': score,
      'total': total,
      'date': now.toIso8601String(),
    });

    profile['quizHistory'] = history;

    final activityHistory =
    (profile['activityHistory'] as List? ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    activityHistory.add({
      'type': 'quiz',
      'title': 'Vocabulary quiz completed',
      'details': 'Score: $score / $total',
      'score': score,
      'total': total,
      'date': now.toIso8601String(),
      'day': _today(),
    });

    profile['activityHistory'] = activityHistory;

    await saveProfile(cleanName, profile);
  }

  Future<void> saveSentenceLearned(
      String name,
      String sentenceId,
      bool learned,
      ) async {
    final profile = await getProfile(name);
    final items =
    List<String>.from(profile['learnedSentences'] ?? []);
    final wasLearned = items.contains(sentenceId);

    if (learned && !wasLearned) {
      items.add(sentenceId);
    } else if (!learned) {
      items.remove(sentenceId);
    }

    profile['learnedSentences'] = items;
    await saveProfile(name, profile);

    if (learned && !wasLearned) {
      await recordActivity(
        name,
        type: 'sentence',
        title: 'Sentence learned',
        details: 'Sentence ID: $sentenceId',
      );
    }
  }

  Future<void> saveTenseLearned(
      String name,
      String tenseId,
      bool learned,
      ) async {
    final profile = await getProfile(name);
    final items =
    List<String>.from(profile['learnedTenses'] ?? []);
    final wasLearned = items.contains(tenseId);

    if (learned && !wasLearned) {
      items.add(tenseId);
    } else if (!learned) {
      items.remove(tenseId);
    }

    profile['learnedTenses'] = items;
    await saveProfile(name, profile);

    if (learned && !wasLearned) {
      await recordActivity(
        name,
        type: 'tense',
        title: 'Tense learned',
        details: 'Tense ID: $tenseId',
      );
    }
  }

  Future<void> resetProgress() async {
    final name = await getActiveUser() ?? 'Guest';
    await resetUserProgress(name);
  }

  Future<void> resetUserProgress(String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    final profiles = await _readProfiles();
    profiles[_userId(cleanName)] = _newProfile(cleanName);
    await _writeProfiles(profiles);
  }
}
