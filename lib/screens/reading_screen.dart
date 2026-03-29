import 'package:flutter/material.dart';
import '../models/tarot_card.dart';
import 'card_detail_screen.dart';

class ReadingScreen extends StatefulWidget {
  final int cardCount;

  const ReadingScreen({Key? key, required this.cardCount}) : super(key: key);

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late List<TarotCard> deck;
  late List<TarotCard> selectedCards;
  late List<bool> isRevealed;
  late List<bool> isReversed;
  int _sessionToken = 0;

  @override
  void initState() {
    super.initState();
    deck = TarotDeck.getShuffledDeck();
    selectedCards = [];
    isRevealed = [];
    isReversed = [];
  }

  void _selectCard(int index) {
    if (selectedCards.length < widget.cardCount) {
      setState(() {
        selectedCards.add(deck[index]);
        isRevealed.add(false);
        isReversed.add(DateTime.now().millisecondsSinceEpoch % 2 == 0);
      });

      // Remove the selected card from the deck
      deck.removeAt(index);

      // If all cards are selected, automatically reveal them
      if (selectedCards.length == widget.cardCount) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _autoRevealCards();
        });
      }
    }
  }

  void _autoRevealCards() {
    final int session = _sessionToken;
    for (int i = 0; i < selectedCards.length; i++) {
      Future.delayed(Duration(milliseconds: 300 * i), () {
        if (!mounted || session != _sessionToken) return;
        if (i >= selectedCards.length) return;
        _revealCard(i);
      });
    }
  }

  void _revealCard(int index) {
    if (!mounted || index >= selectedCards.length) return;
    setState(() {
      isRevealed[index] = true;
    });

    // Show card details
    showDialog(
      context: context,
      builder: (context) => CardDetailDialog(
        card: selectedCards[index],
        isReversed: isReversed[index],
      ),
    );
  }

  void _resetReading() {
    setState(() {
      _sessionToken++;
      deck = TarotDeck.getShuffledDeck();
      selectedCards = [];
      isRevealed = [];
      isReversed = [];
    });
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
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                children: [
                  Text(
                    '${widget.cardCount}-Kart Çekiş',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${selectedCards.length}/${widget.cardCount} Kart Seçildi',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Selected Cards Display
            if (selectedCards.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seçilen Kartlar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          selectedCards.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _buildSelectedCard(index),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 40),

            // Card Selection Grid
            if (selectedCards.length < widget.cardCount)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kart Seçiniz',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: deck.length,
                          itemBuilder: (context, index) {
                            return _buildCardButton(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Action Buttons
            if (selectedCards.length == widget.cardCount)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Text(
                      'Kartlara Tıklayarak Açınız',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _resetReading,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Yeni Çekiş',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(int index) {
    return GestureDetector(
      onTap: () => _selectCard(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade700,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.amber,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🂠',
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 5),
            Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedCard(int index) {
    return GestureDetector(
      onTap: () => _revealCard(index),
      child: Container(
        width: 120,
        height: 160,
        decoration: BoxDecoration(
          color: isRevealed[index]
              ? Colors.amber.shade700
              : Colors.deepPurple.shade800,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.amber,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.4),
              blurRadius: 12,
            ),
          ],
        ),
        child: isRevealed[index]
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedCards[index].name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    isReversed[index]
                        ? Icons.rotate_90_degrees_ccw
                        : Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: isReversed[index] ? 3.14159 : 0,
                    child: const Text(
                      '🂠',
                      style: TextStyle(fontSize: 48),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
