
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VocabNestApp());
}

class VocabNestApp extends StatelessWidget {
  const VocabNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6554C0);

    return MaterialApp(
      title: 'Vocab Nest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        scaffoldBackgroundColor: const Color(0xFFF7F6FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F6FC),
          foregroundColor: Color(0xFF24213A),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
