import 'package:flutter/material.dart';
import 'reading_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _startReading(BuildContext context, int cardCount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingScreen(cardCount: cardCount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900,
              Colors.purple.shade700,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🔮',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 30),
              const Text(
                'Fortune Teller',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Tarot Reading',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                'Seçiminizi Yapınız',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              _buildReadingButton(
                context,
                'Tek Kart',
                '1',
                1,
                Colors.amber,
              ),
              const SizedBox(height: 20),
              _buildReadingButton(
                context,
                'Üçlü Çekiş',
                '3',
                3,
                Colors.lightBlue,
              ),
              const SizedBox(height: 20),
              _buildReadingButton(
                context,
                'Yedili Çekiş',
                '7',
                7,
                Colors.pink,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingButton(
    BuildContext context,
    String label,
    String number,
    int cardCount,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => _startReading(context, cardCount),
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
