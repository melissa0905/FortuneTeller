import 'package:flutter/material.dart';
import '../models/tarot_card.dart';

class CardDetailDialog extends StatelessWidget {
  final TarotCard card;
  final bool isReversed;

  const CardDetailDialog({
    Key? key,
    required this.card,
    required this.isReversed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.deepPurple.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.amber,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Card Image
            Transform.rotate(
              angle: isReversed ? 3.14159 : 0,
              child: Image.asset(
                card.imagePath,
                width: 120,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    '🃏',
                    style: TextStyle(fontSize: 64),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Card Name
            Text(
              card.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),

            // Suit Badge
            const SizedBox(height: 8),
            Text(
              card.suit,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),

            // Orientation Badge
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isReversed
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.green.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isReversed ? Colors.red : Colors.green,
                ),
              ),
              child: Text(
                isReversed ? 'Ters (Reversed)' : 'Düz (Upright)',
                style: TextStyle(
                  color: isReversed ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Meaning Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReversed ? 'Ters Anlam:' : 'Düz Anlam:',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isReversed ? card.reversed : card.upright,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Alternative Meaning
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReversed ? 'Alternatif Anlam:' : 'Ters Anlam:',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isReversed ? card.upright : card.reversed,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white54,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Close Button
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Kapat',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
