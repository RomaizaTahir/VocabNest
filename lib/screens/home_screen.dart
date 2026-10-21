import 'package:flutter/material.dart';

import '../data/grammar_data.dart';
import '../data/lesson_data.dart';
import '../data/vocabulary_data.dart';
import '../models/vocabulary_word.dart';
import '../services/dictionary_service.dart';
import '../services/speech_service.dart';
import '../services/storage_service.dart';
import '../widgets/vocabulary_card.dart';

const purple = Color(0xFF6554C0);

class BasicSentence {
  final String id;
  final String english;
  final String urdu;

  const BasicSentence(this.id, this.english, this.urdu);
}

class TenseLesson {
  final String id;
  final String name;
  final String formula;
  final String example;
  final String urdu;
  final String question;
  final List<String> options;
  final int correct;

  const TenseLesson({
    required this.id,
    required this.name,
    required this.formula,
    required this.example,
    required this.urdu,
    required this.question,
    required this.options,
    required this.correct,
  });
}

const basicSentences = <BasicSentence>[
  BasicSentence('s1', 'I am a student.', 'میں ایک طالب علم ہوں۔'),
  BasicSentence('s2', 'I live in Lahore.', 'میں لاہور میں رہتا/رہتی ہوں۔'),
  BasicSentence('s3', 'I like reading.', 'مجھے پڑھنا پسند ہے۔'),
  BasicSentence('s4', 'She is my friend.', 'وہ میری دوست ہے۔'),
  BasicSentence('s5', 'He goes to school.', 'وہ اسکول جاتا ہے۔'),
  BasicSentence('s6', 'We are learning English.', 'ہم انگریزی سیکھ رہے ہیں۔'),
  BasicSentence('s7', 'Please help me.', 'براہِ کرم میری مدد کریں۔'),
  BasicSentence('s8', 'I understand you.', 'میں آپ کی بات سمجھتا/سمجھتی ہوں۔'),
  BasicSentence('s9', 'What is your name?', 'آپ کا نام کیا ہے؟'),
  BasicSentence('s10', 'I am feeling happy.', 'میں خوش محسوس کر رہا/رہی ہوں۔'),
  BasicSentence('s11', 'I will call you.', 'میں آپ کو فون کروں گا/گی۔'),
  BasicSentence('s12', 'Thank you very much.', 'آپ کا بہت شکریہ۔'),
];

const tenseLessons = <TenseLesson>[
  TenseLesson(
    id: 't1',
    name: 'Present Simple',
    formula: 'Subject + base verb (add s/es with he, she, it)',
    example: 'She reads a book.',
    urdu: 'روزمرہ کے کام یا عادت کے لیے استعمال ہوتا ہے۔',
    question: 'Choose the correct sentence.',
    options: ['She read a book every day.', 'She reads a book every day.', 'She reading a book.'],
    correct: 1,
  ),
  TenseLesson(
    id: 't2',
    name: 'Present Continuous',
    formula: 'Subject + am/is/are + verb-ing',
    example: 'I am reading a book.',
    urdu: 'جو کام ابھی جاری ہو رہا ہو۔',
    question: 'Complete: They ___ playing.',
    options: ['is', 'am', 'are'],
    correct: 2,
  ),
  TenseLesson(
    id: 't3',
    name: 'Present Perfect',
    formula: 'Subject + has/have + past participle',
    example: 'She has finished her work.',
    urdu: 'ایسا کام جو مکمل ہو چکا ہو اور اس کا تعلق حال سے ہو۔',
    question: 'He ___ eaten lunch.',
    options: ['has', 'have', 'is'],
    correct: 0,
  ),
  TenseLesson(
    id: 't4',
    name: 'Present Perfect Continuous',
    formula: 'Subject + has/have been + verb-ing',
    example: 'I have been studying for two hours.',
    urdu: 'ایسا کام جو ماضی میں شروع ہوا اور اب تک جاری ہو۔',
    question: 'She has been ___ since morning.',
    options: ['study', 'studying', 'studied'],
    correct: 1,
  ),
  TenseLesson(
    id: 't5',
    name: 'Past Simple',
    formula: 'Subject + past form of verb',
    example: 'They played cricket.',
    urdu: 'ماضی میں مکمل ہونے والا کام۔',
    question: 'Yesterday, we ___ to school.',
    options: ['go', 'went', 'gone'],
    correct: 1,
  ),
  TenseLesson(
    id: 't6',
    name: 'Past Continuous',
    formula: 'Subject + was/were + verb-ing',
    example: 'He was sleeping.',
    urdu: 'ماضی میں کسی وقت کام جاری تھا۔',
    question: 'I ___ watching TV.',
    options: ['were', 'was', 'am'],
    correct: 1,
  ),
  TenseLesson(
    id: 't7',
    name: 'Past Perfect',
    formula: 'Subject + had + past participle',
    example: 'She had left before I arrived.',
    urdu: 'ماضی کے کسی دوسرے کام سے پہلے مکمل ہونے والا کام۔',
    question: 'They ___ finished before noon.',
    options: ['had', 'have', 'has'],
    correct: 0,
  ),
  TenseLesson(
    id: 't8',
    name: 'Past Perfect Continuous',
    formula: 'Subject + had been + verb-ing',
    example: 'He had been working for hours.',
    urdu: 'ماضی میں کسی وقت تک کام مسلسل جاری رہا تھا۔',
    question: 'I had been ___ for an hour.',
    options: ['wait', 'waited', 'waiting'],
    correct: 2,
  ),
  TenseLesson(
    id: 't9',
    name: 'Future Simple',
    formula: 'Subject + will + base verb',
    example: 'I will call you.',
    urdu: 'مستقبل میں ہونے والا کام۔',
    question: 'She ___ visit tomorrow.',
    options: ['will', 'did', 'has'],
    correct: 0,
  ),
  TenseLesson(
    id: 't10',
    name: 'Future Continuous',
    formula: 'Subject + will be + verb-ing',
    example: 'I will be studying at 8 PM.',
    urdu: 'مستقبل میں کسی وقت کام جاری ہوگا۔',
    question: 'They will be ___ football.',
    options: ['play', 'playing', 'played'],
    correct: 1,
  ),
  TenseLesson(
    id: 't11',
    name: 'Future Perfect',
    formula: 'Subject + will have + past participle',
    example: 'She will have finished by noon.',
    urdu: 'مستقبل کے کسی وقت تک کام مکمل ہو چکا ہوگا۔',
    question: 'He will have ___ the task.',
    options: ['finish', 'finishing', 'finished'],
    correct: 2,
  ),
  TenseLesson(
    id: 't12',
    name: 'Future Perfect Continuous',
    formula: 'Subject + will have been + verb-ing',
    example: 'By June, I will have been working here for a year.',
    urdu: 'مستقبل کے کسی وقت تک کام ایک مدت سے جاری ہوگا۔',
    question: 'She will have been ___ for two hours.',
    options: ['work', 'working', 'worked'],
    correct: 1,
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService storage = StorageService();
  final DictionaryService dictionary = DictionaryService();
  final SpeechService speech = SpeechService();

  int tab = 0;
  final List<int> tabHistory = [];

  bool loading = true;
  bool reveal = false;
  int flashIndex = 0;
  int practiceMode = 0;
  int tenseQuestion = 0;
  int? tenseAnswer;
  bool tenseAnswered = false;

  String userName = '';
  Set<String> learned = {};
  Set<String> saved = {};
  Set<String> learnedSentences = {};
  Set<String> learnedTenses = {};

  String search = '';
  String category = 'All';

  int question = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;
  int bestScore = 0;
  int quizCount = 0;
  bool quizFinished = false;

  final List<int> quizOrder = List.generate(10, (i) => i);

  @override
  void initState() {
    super.initState();
    speech.initialize();
    quizOrder.shuffle();
    loadData();
  }

  Future<void> loadData() async {
    try {
      userName = await storage.getActiveUser() ?? '';

      if (userName.isNotEmpty) {
        await loadUserProfile(userName);
      } else {
        learned = {};
        saved = {};
      }
    } catch (_) {
      showMessage('Could not load saved progress.');
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> loadUserProfile(String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    await storage.setActiveUser(cleanName);
    final profile = await storage.getProfile(cleanName);

    learned = Set<String>.from(profile['learnedWords'] ?? []);
    saved = Set<String>.from(profile['savedWords'] ?? []);
    learnedSentences =
    Set<String>.from(profile['learnedSentences'] ?? []);
    learnedTenses = Set<String>.from(profile['learnedTenses'] ?? []);

    bestScore = await storage.getBestScore();
    quizCount = await storage.getQuizCount();
    activityHistory = await storage.getActivityHistory(cleanName);
    if (mounted) setState(() {});
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }


  Future<String?> askForName({
    String title = 'Choose learner',
  }) async {
    final controller = TextEditingController(text: userName);

    try {
      final existingNames = await storage.getUserNames();

      if (!mounted) return null;

      final result = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter a learner name. Progress will be saved separately '
                      'for this name on this device.',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Learner name',
                    hintText: 'e.g. Ayesha',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    final name = value.trim();
                    if (name.isNotEmpty) {
                      Navigator.pop(dialogContext, name);
                    }
                  },
                ),
                if (existingNames.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Existing learners'),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: existingNames.map((name) {
                      return ActionChip(
                        label: Text(name),
                        onPressed: () {
                          Navigator.pop(dialogContext, name);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          actions: [

            FilledButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  Navigator.pop(dialogContext, name);
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );

      if (!mounted || result == null || result.trim().isEmpty) {
        return null;
      }

      final name = result.trim();
      await loadUserProfile(name);

      return name;
    } finally {
      controller.dispose();
    }
  }


  Future<bool> ensureLearner() async {
    if (userName.trim().isNotEmpty) return true;

    final name = await askForName(title: 'Enter learner name');
    if (name == null) return false;

    if (mounted) setState(() => userName = name);
    return true;
  }

  void navigateTo(int destination) {
    if (destination == tab) return;

    setState(() {
      if (destination == 0) {
        tabHistory.clear();
      } else {
        tabHistory.add(tab);
      }
      tab = destination;
    });
  }

  void handleBack() {
    if (tabHistory.isNotEmpty) {
      setState(() => tab = tabHistory.removeLast());
    } else if (tab != 0) {
      setState(() => tab = 0);
    }
  }

  Future<void> persistWords() async {
    if (!await ensureLearner()) return;
    await storage.saveWords(learned, saved);
  }

  Future<void> toggleLearned(VocabularyWord word) async {
    if (!await ensureLearner()) return;

    final wasLearned = learned.contains(word.word);
    final updated = Set<String>.from(learned);

    if (!updated.add(word.word)) {
      updated.remove(word.word);
    }

    setState(() => learned = updated);
    await persistWords();

    // Sirf naya word learn hone par history entry banegi.
    if (!wasLearned && learned.contains(word.word)) {
      await storage.recordActivity(
        userName,
        type: 'word',
        title: 'Vocabulary word learned',
        details: word.word,
      );

      activityHistory = await storage.getActivityHistory(userName);

      if (mounted) setState(() {});
    }
  }
  Future<void> toggleSaved(VocabularyWord word) async {
    if (!await ensureLearner()) return;

    final updated = Set<String>.from(saved);
    if (!updated.add(word.word)) updated.remove(word.word);

    setState(() => saved = updated);
    await persistWords();
  }

  Future<void> markSentence(BasicSentence sentence, bool value) async {
    if (!await ensureLearner()) return;

    await storage.saveSentenceLearned(userName, sentence.id, value);
    activityHistory = await storage.getActivityHistory(userName);
    if (!mounted) return;

    setState(() {
      if (value) {
        learnedSentences.add(sentence.id);
      } else {
        learnedSentences.remove(sentence.id);
      }
    });
  }

  Future<void> markTense(TenseLesson tense, bool value) async {
    if (!await ensureLearner()) return;

    await storage.saveTenseLearned(userName, tense.id, value);
    if (!mounted) return;

    setState(() {
      if (value) {
        learnedTenses.add(tense.id);
      } else {
        learnedTenses.remove(tense.id);
      }
    });
  }
  List<Map<String, dynamic>> activityHistory = [];
  Future<void> speak(String word) async {
    try {
      await speech.speak(word);
    } catch (_) {
      showMessage('Pronunciation is unavailable on this device.');
    }
  }

  @override
  void dispose() {
    speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      vocabularyPage(),
      practicePage(),
      grammarPage(),
      progressPage(),
    ];

    return PopScope(
      canPop: tab == 0 && tabHistory.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 16,
          title:  Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/vocab_nest_logo.png',
                  width: 38,
                  height: 38,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.menu_book_rounded,
                      color: purple,
                      size: 30,
                    );
                  },
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vocab Nest',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                  Text(
                    'LEARN • PRACTISE • GROW',
                    style: TextStyle(fontSize: 9, letterSpacing: 1.2),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Change learner',
              onPressed: () async {
                final name = await askForName();
                if (name != null && mounted) {
                  setState(() {
                    userName = name;
                    question = 0;
                    score = 0;
                    quizFinished = false;
                  });
                  showMessage('Progress loaded for $name.');
                }
              },
              icon: const Icon(Icons.account_circle_outlined),
            ),
            IconButton(
              tooltip: 'Saved words',
              onPressed: () {
                setState(() {
                  category = 'Saved';
                  search = '';
                });
                navigateTo(1);
              },
              icon: const Icon(Icons.bookmark_border_rounded),
            ),
            const SizedBox(width: 6),
          ],
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
          child: IndexedStack(index: tab, children: pages),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: navigateTo,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Learn',
            ),
            NavigationDestination(
              icon: Icon(Icons.style_outlined),
              selectedIcon: Icon(Icons.style_rounded),
              label: 'Practice',
            ),
            NavigationDestination(
              icon: Icon(Icons.spellcheck_outlined),
              selectedIcon: Icon(Icons.spellcheck_rounded),
              label: 'Grammar',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights_rounded),
              label: 'Progress',
            ),
          ],
        ),
      ),
    );
  }

  Widget pageScroll(Widget child) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    child: child,
  );

  Widget sectionTitle(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF292541),
          ),
        ),
        const SizedBox(height: 5),
        Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
      ],
    ),
  );

  Widget homePage() {
    final wordTotal = vocabularyWords.length;
    final wordProgress =
    wordTotal == 0 ? 0.0 : learned.length / wordTotal;

    return pageScroll(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [purple, Color(0xFF8D7AE0)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.isEmpty ? 'Welcome to Vocab Nest!' : 'Welcome, $userName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Build your English step by step.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: wordProgress,
                  minHeight: 8,
                  backgroundColor: Colors.white30,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  '${learned.length} of $wordTotal vocabulary words learned',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: purple,
                  ),
                  onPressed: () => navigateTo(1),
                  child: const Text('Continue learning'),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () async {
                    final name = await askForName();
                    if (name != null && mounted) {
                      setState(() => userName = name);
                    }
                  },
                  icon: const Icon(Icons.person_outline),
                  label: Text(
                    userName.isEmpty ? 'Choose learner' : 'Switch learner',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Basic English sentences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '${learnedSentences.length} of 12 marked as learned',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 10),
          ...basicSentences.map((sentence) {
            final isLearned = learnedSentences.contains(sentence.id);
            return Card(
              margin: const EdgeInsets.only(bottom: 9),
              child: CheckboxListTile(
                value: isLearned,
                onChanged: (value) =>
                    markSentence(sentence, value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  sentence.english,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  sentence.urdu,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontSize: 17, color: purple),
                ),
              ),
            );
          }),
          const SizedBox(height: 18),
          const Text(
            'Your overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              overviewCard('Words learned', '${learned.length}', Icons.check_circle_outline),
              overviewCard('Saved words', '${saved.length}', Icons.bookmark_border),
              overviewCard('Sentences learned', '${learnedSentences.length}/12', Icons.translate),
              overviewCard('Tenses learned', '${learnedTenses.length}/12', Icons.spellcheck),
            ],
          ),
          const SizedBox(height: 18),
          Card(
            child: ListTile(
              leading: const Icon(Icons.style_rounded, color: purple),
              title: const Text('Ready to practise?'),
              subtitle: const Text('Open flashcards or take a named quiz.'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => navigateTo(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget overviewCard(String title, String value, IconData icon) => SizedBox(
    width: (MediaQuery.sizeOf(context).width - 44) / 2,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: purple, size: 27),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(title),
          ],
        ),
      ),
    ),
  );

  Widget vocabularyPage() {
    final categories = <String>[
      'All',
      'Saved',
      ...{for (final word in vocabularyWords) word.category},
    ];

    final results = dictionary.search(search).where((word) {
      if (category == 'Saved') return saved.contains(word.word);
      if (category == 'All') return true;
      return word.category == category;
    }).toList();

    return pageScroll(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
            'Vocabulary library',
            'Search English words and learn their Urdu meanings.',
          ),
          TextField(
            onChanged: (value) => setState(() => search = value),
            decoration: InputDecoration(
              hintText: 'Search a word or meaning...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(item),
                    selected: category == item,
                    onSelected: (_) => setState(() => category = item),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          Text('${results.length} words'),
          const SizedBox(height: 10),
          if (results.isEmpty)
            const Center(child: Text('No words found. Try another search.')),
          ...results.map(
                (word) => VocabularyCard(
              word: word,
              learned: learned.contains(word.word),
              saved: saved.contains(word.word),
              onLearned: () => toggleLearned(word),
              onSaved: () => toggleSaved(word),
              onSpeak: () => speak(word.word),
            ),
          ),
        ],
      ),
    );
  }

  Widget practicePage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(
                'Practice centre',
                'Revise vocabulary or test your English.',
              ),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    label: Text('Flashcards'),
                    icon: Icon(Icons.style_outlined),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text('Quiz'),
                    icon: Icon(Icons.quiz_outlined),
                  ),
                ],
                selected: {practiceMode},
                onSelectionChanged: (selection) async {
                  if (selection.first == 1 && !await ensureLearner()) return;
                  if (!mounted) return;
                  setState(() => practiceMode = selection.first);
                  if (selection.first == 1) startQuiz();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: practiceMode == 0 ? flashcardContent() : quizContent(),
        ),
      ],
    );
  }

  Widget flashcardContent() {
    if (vocabularyWords.isEmpty) {
      return const Center(child: Text('No vocabulary cards available.'));
    }

    final word = vocabularyWords[flashIndex % vocabularyWords.length];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Card ${flashIndex % vocabularyWords.length + 1} of ${vocabularyWords.length}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => setState(() => reveal = !reveal),
          child: Container(
            constraints: const BoxConstraints(minHeight: 260),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [purple, Color(0xFF9584E5)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(reveal ? Icons.translate : Icons.style, size: 38, color: Colors.white),
                const SizedBox(height: 24),
                Text(
                  reveal ? word.meaning : word.word,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (reveal) ...[
                  const SizedBox(height: 18),
                  Text(
                    word.example,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  reveal ? 'Tap to hide' : 'Tap to reveal meaning',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => speak(word.word),
          icon: const Icon(Icons.volume_up),
          label: const Text('Listen to pronunciation'),
        ),
        FilledButton.icon(
          onPressed: () async {
            await toggleLearned(word);
            if (!mounted) return;
            setState(() {
              flashIndex = (flashIndex + 1) % vocabularyWords.length;
              reveal = false;
            });
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Mark learned & next'),
        ),
        TextButton.icon(
          onPressed: () => toggleSaved(word),
          icon: Icon(saved.contains(word.word) ? Icons.bookmark : Icons.bookmark_border),
          label: Text(saved.contains(word.word) ? 'Remove bookmark' : 'Save word'),
        ),
      ],
    );
  }

  Widget quizContent() {
    if (vocabularyWords.isEmpty) {
      return const Center(child: Text('Add vocabulary words before taking a quiz.'));
    }

    if (quizFinished) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events_rounded, size: 64, color: purple),
              const SizedBox(height: 12),
              const Text(
                'Quiz completed!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text('Learner: $userName'),
              const SizedBox(height: 8),
              Text('Your score: $score / 10', style: const TextStyle(fontSize: 21)),
              Text('Best score: $bestScore / 10'),
              const SizedBox(height: 20),
              FilledButton(onPressed: startQuiz, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    final correctIndex = quizOrder[question] % vocabularyWords.length;
    final word = vocabularyWords[correctIndex];

    final options = <int>{
      correctIndex,
      (correctIndex + 3) % vocabularyWords.length,
      (correctIndex + 7) % vocabularyWords.length,
      (correctIndex + 11) % vocabularyWords.length,
    }.toList()
      ..sort((a, b) => vocabularyWords[a].word.compareTo(vocabularyWords[b].word));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            Expanded(child: Text('Learner: $userName')),
            Text('Question ${question + 1} of 10'),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(value: (question + 1) / 10, minHeight: 7),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Choose the correct Urdu meaning:'),
                const SizedBox(height: 12),
                Text(
                  word.word,
                  style: const TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text('Category: ${word.category}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...options.map((index) {
          final correct = index == correctIndex;
          final chosen = index == selectedAnswer;
          Color? background;
          Color? foreground;

          if (answered && correct) {
            background = Colors.green;
            foreground = Colors.white;
          } else if (answered && chosen) {
            background = Colors.red;
            foreground = Colors.white;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: background,
                  foregroundColor: foreground,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                onPressed: answered
                    ? null
                    : () {
                  setState(() {
                    selectedAnswer = index;
                    answered = true;
                    if (correct) score++;
                  });
                },
                child: Text(vocabularyWords[index].meaning, textAlign: TextAlign.center),
              ),
            ),
          );
        }),
        if (answered) ...[
          const SizedBox(height: 8),
          Text(
            selectedAnswer == correctIndex
                ? 'Correct! Well done.'
                : 'Correct answer: ${word.meaning}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectedAnswer == correctIndex ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: nextQuestion,
            child: Text(question == 9 ? 'Finish quiz' : 'Next question'),
          ),
        ],
      ],
    );
  }

  void startQuiz() {
    setState(() {
      question = 0;
      score = 0;
      selectedAnswer = null;
      answered = false;
      quizFinished = false;
      quizOrder.shuffle();
    });
  }

  Future<void> nextQuestion() async {
    if (question < 9) {
      setState(() {
        question++;
        selectedAnswer = null;
        answered = false;
      });
      return;
    }

    await storage.saveQuizResultForUser(userName, score, 10);

    await loadUserProfile(userName);

    if (!mounted) return;
    setState(() => quizFinished = true);
  }

  Widget grammarPage() {
    return pageScroll(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
            'Grammar academy',
            'Learn all 12 tenses with formulas, examples and practice.',
          ),
          Text(
            'Tenses completed: ${learnedTenses.length} of 12',
            style: const TextStyle(fontWeight: FontWeight.bold, color: purple),
          ),
          const SizedBox(height: 10),
          ...tenseLessons.map((tense) {
            final isLearned = learnedTenses.contains(tense.id);
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFEAE5FF),
                  child: Text(
                    tense.id.substring(1),
                    style: const TextStyle(color: purple, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  tense.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(tense.example),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Formula: ${tense.formula}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Urdu: ${tense.urdu}',
                      style: const TextStyle(fontSize: 16, color: purple),
                    ),
                  ),
                  const Divider(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Practice: ${tense.question}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(tense.options.length, (index) {
                    final isCorrect = tenseAnswered &&
                        tenseQuestion == tenseLessons.indexOf(tense) &&
                        tenseAnswer == index &&
                        index == tense.correct;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isCorrect ? Colors.green.shade100 : null,
                        ),
                        onPressed: () async {
                          if (!await ensureLearner()) return;
                          setState(() {
                            tenseQuestion = tenseLessons.indexOf(tense);
                            tenseAnswer = index;
                            tenseAnswered = true;
                          });
                          if (index == tense.correct) {
                            await markTense(tense, true);
                          }
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(tense.options[index]),
                        ),
                      ),
                    );
                  }),
                  if (tenseAnswered &&
                      tenseQuestion == tenseLessons.indexOf(tense))
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        tenseAnswer == tense.correct
                            ? 'Correct! Tense marked as learned.'
                            : 'Try again. Review the formula above.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tenseAnswer == tense.correct ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isLearned,
                    title: const Text('Mark this tense as learned'),
                    onChanged: (value) => markTense(tense, value ?? false),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          const Text(
            'Other grammar lessons',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...grammarTopics.map(
                (lesson) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                leading: const Icon(Icons.spellcheck, color: purple),
                title: Text(
                  lesson.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(lesson.explanation),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Urdu explanation: ${lesson.urdu}',
                      style: const TextStyle(fontSize: 16, color: purple),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Example: ${lesson.example}'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Conversation lessons',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...lessons.map(
                (lesson) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const SizedBox(height: 8),
                    Text(lesson.explanation),
                    const SizedBox(height: 6),
                    Text(
                      lesson.urdu,
                      style: const TextStyle(color: purple, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text('Example: ${lesson.example}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget progressPage() {
    final totalWords = vocabularyWords.length;
    final percent = totalWords == 0
        ? 0
        : (learned.length / totalWords * 100).round();

    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = width < 360 ? width - 40 : (width - 44) / 2;

    return pageScroll(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
            'Your progress',
            userName.isEmpty
                ? 'Choose a learner to track progress.'
                : 'Progress for $userName is saved on this device.',
          ),
          if (userName.isEmpty)
            FilledButton(
              onPressed: () async {
                final name = await askForName();
                if (name != null && mounted) setState(() => userName = name);
              },
              child: const Text('Choose learner'),
            ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: cardWidth,
                child: progressCard('Words learned', '${learned.length}', Icons.check_circle_outline),
              ),
              SizedBox(
                width: cardWidth,
                child: progressCard('Bookmarked', '${saved.length}', Icons.bookmark_border),
              ),
              SizedBox(
                width: cardWidth,
                child: progressCard('Sentences learned', '${learnedSentences.length}/12', Icons.translate),
              ),
              SizedBox(
                width: cardWidth,
                child: progressCard('Tenses learned', '${learnedTenses.length}/12', Icons.spellcheck),
              ),
              SizedBox(
                width: cardWidth,
                child: progressCard('Best quiz score', '$bestScore / 10', Icons.emoji_events_outlined),
              ),
              SizedBox(
                width: cardWidth,
                child: progressCard('Quizzes completed', '$quizCount', Icons.quiz_outlined),
              ),


            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vocabulary completion',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        '$percent%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: purple,
                        ),
                      ),
                      const Spacer(),
                      Text('${learned.length} of $totalWords words'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: totalWords == 0 ? 0 : learned.length / totalWords,
                    minHeight: 10,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: const ListTile(
              leading: Icon(Icons.info_outline, color: purple),
              title: Text('Offline progress'),
              subtitle: Text(
                'Each learner has separate progress saved on this device. '
                    'Clearing app data or uninstalling may erase saved progress. '
                    'This is local storage, not cloud sync.',
              ),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: Colors.red,
            ),
            onPressed: resetProgress,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Reset this learner’s progress'),
          ),
        ],
      ),
    );
  }

  Widget progressCard(String title, String value, IconData icon) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: purple, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(title, maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );

  Future<void> resetProgress() async {
    if (!await ensureLearner()) return;
    if (!mounted) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset progress?'),
        content: Text(
          'This will reset the saved learning progress for $userName only. '
              'Other learners will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(dialogContext).unfocus();
              Navigator.of(dialogContext).pop<String>(null);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm != true) return;

    try {
      await storage.resetUserProgress(userName);
      await loadUserProfile(userName);

      if (!mounted) return;

      setState(() {
        learned = {};
        saved = {};
        learnedSentences = {};
        learnedTenses = {};
        bestScore = 0;
        quizCount = 0;
      });

      showMessage('Progress reset for $userName.');
    } catch (_) {
      showMessage('Could not reset progress. Please try again.');
    }
  }
}