
import 'package:flutter/material.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController searchController = TextEditingController();

  final Map<String, Map<String, String>> words = {
    'محبت': {'english': 'Love', 'roman': 'mohabbat'},
    'خوشی': {'english': 'Happiness', 'roman': 'khushi'},
    'پانی': {'english': 'Water', 'roman': 'pani'},
    'کتاب': {'english': 'Book', 'roman': 'kitab'},
    'گھر': {'english': 'House / Home', 'roman': 'ghar'},
    'دوست': {'english': 'Friend', 'roman': 'dost'},
    'ماں': {'english': 'Mother', 'roman': 'maan'},
    'باپ': {'english': 'Father', 'roman': 'baap'},
    'تعلیم': {'english': 'Education', 'roman': 'taleem'},
    'علم': {'english': 'Knowledge', 'roman': 'ilm'},
    'خوبصورت': {'english': 'Beautiful', 'roman': 'khoobsurat'},
    'اچھا': {'english': 'Good', 'roman': 'acha'},
    'برا': {'english': 'Bad', 'roman': 'bura'},
    'دوستی': {'english': 'Friendship', 'roman': 'dosti'},
    'محنت': {'english': 'Hard work', 'roman': 'mehnat'},
    'وقت': {'english': 'Time', 'roman': 'waqt'},
    'دن': {'english': 'Day', 'roman': 'din'},
    'رات': {'english': 'Night', 'roman': 'raat'},
    'کھانا': {'english': 'Food', 'roman': 'khana'},
    'پیار': {'english': 'Love / Affection', 'roman': 'pyar'},
    'شکریہ': {'english': 'Thank you', 'roman': 'shukriya'},
    'امید': {'english': 'Hope', 'roman': 'umeed'},
    'زندگی': {'english': 'Life', 'roman': 'zindagi'},
    'خواب': {'english': 'Dream', 'roman': 'khwab'},
    'روشنی': {'english': 'Light', 'roman': 'roshni'},
    'آسمان': {'english': 'Sky', 'roman': 'aasman'},
    'زمین': {'english': 'Earth / Land', 'roman': 'zameen'},
    'پھول': {'english': 'Flower', 'roman': 'phool'},
    'درخت': {'english': 'Tree', 'roman': 'darakht'},
    'بارش': {'english': 'Rain', 'roman': 'barish'},
  };

  String query = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();

    final results = words.entries.where((entry) {
      final urdu = entry.key;
      final english = entry.value['english']!.toLowerCase();
      final roman = entry.value['roman']!.toLowerCase();

      return urdu.contains(normalizedQuery) ||
          english.contains(normalizedQuery) ||
          roman.contains(normalizedQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Urdu to English Dictionary'),
        backgroundColor: const Color(0xFF6554C0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find any word',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Urdu ya Roman Urdu mein word search karein.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() => query = value);
              },
              decoration: InputDecoration(
                hintText: 'مثلاً محبت یا mohabbat',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() => query = '');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: query.trim().isEmpty
                  ? const Center(
                child: Text(
                  'Search an Urdu or Roman Urdu word.',
                  textAlign: TextAlign.center,
                ),
              )
                  : results.isEmpty
                  ? const Center(
                child: Text(
                  'Word not found in offline dictionary.',
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final entry = results[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFEAE5FF),
                        child: Icon(
                          Icons.translate,
                          color: Color(0xFF6554C0),
                        ),
                      ),
                      title: Text(
                        entry.key,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Roman Urdu: ${entry.value['roman']}',
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: Text(entry.key),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text('English meaning'),
                                  const SizedBox(height: 8),
                                  Text(
                                    entry.value['english']!,
                                    style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6554C0),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Roman Urdu: ${entry.value['roman']}',
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext),
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
