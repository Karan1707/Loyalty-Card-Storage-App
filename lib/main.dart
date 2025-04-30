import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/card_provider.dart';
import 'screens/home_screen.dart';
import 'models/loyalty_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(LoyaltyCardAdapter());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardProvider()..init(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Loyalty Card Storage',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            primary: const Color(0xFF6C63FF),
            secondary: const Color(0xFF4CAF50),
            tertiary: const Color(0xFFFF9800),
            surface: Colors.white,
            background: const Color(0xFFF8F9FA),
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 28,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            shadowColor: Colors.black.withOpacity(0.1),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: CircleBorder(),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
            displayMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFF424242),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Color(0xFF616161),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF6C63FF),
            size: 24,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.grey[800],
            contentTextStyle: const TextStyle(color: Colors.white),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0xFFE0E0E0),
            thickness: 1,
            space: 0,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFF6C63FF).withOpacity(0.1),
            labelStyle: const TextStyle(
              color: Color(0xFF6C63FF),
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
} 