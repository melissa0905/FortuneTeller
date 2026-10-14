import 'dart:math';

import 'package:flutter/material.dart';
import '../models/tarot_card.dart';
import 'card_detail_screen.dart';
import '../widgets/tarot_card_back.dart';

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

  final Random _random = Random();

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
        isReversed.add(_random.nextBool());
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
        setState(() => isRevealed[i] = true);
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
    final bool compact = MediaQuery.of(context).size.height < 700;
    final double topPadding = compact ? 16 : 24;
    const double sectionGap = 24;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Container(
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
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Padding(
                        padding: EdgeInsets.only(
                            top: topPadding, left: 20, right: 20),
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
                      SizedBox(height: sectionGap),

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

                      if (selectedCards.isNotEmpty)
                        const SizedBox(height: sectionGap),

                      // Card Selection Grid
                      if (selectedCards.length < widget.cardCount)
                        Padding(
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
                              const SizedBox(height: 6),
                              const Text(
                                'İçinden gelen karta dokun. Diğer kartlar için aşağı kaydır.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white60,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildCardGrid(),
                            ],
                          ),
                        ),

                      if (selectedCards.length == widget.cardCount)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children:
                                List.generate(selectedCards.length, (index) {
                              if (!isRevealed[index]) {
                                return const SizedBox.shrink();
                              }
                              final card = selectedCards[index];
                              return Container(
                                key: ValueKey('interpretation-$index'),
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}. ${card.name} · ${isReversed[index] ? 'Ters' : 'Düz'}',
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      card.interpretation(isReversed[index]),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        height: 1.7,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),

                      // Action Buttons
                      if (selectedCards.length == widget.cardCount)
                        Padding(
                          padding: EdgeInsets.all(compact ? 16 : 30),
                          child: Column(
                            children: [
                              const Text(
                                'Ayrıntılar için kartlara dokunabilirsiniz.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.amber,
                                ),
                              ),
                              SizedBox(height: compact ? 12 : 20),
                              ElevatedButton(
                                onPressed: _resetReading,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: compact ? 28 : 40,
                                    vertical: compact ? 12 : 15,
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
                ));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 78).floor().clamp(2, 8);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
            childAspectRatio: 0.6,
          ),
          itemCount: deck.length,
          itemBuilder: (context, index) => Semantics(
            label: 'Kart ${index + 1}',
            button: true,
            child: TarotCardBack(
              key: ValueKey('deck-card-$index'),
              onTap: () => _selectCard(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedCard(int index) {
    final TarotCard card = selectedCards[index];
    final bool revealed = isRevealed[index];
    return GestureDetector(
      onTap: () => _revealCard(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 105,
            height: 175,
            child: revealed
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildCardImage(card, isReversed[index]),
                  )
                : const TarotCardBack(),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 105,
            child: Text(
              revealed ? card.name : '${index + 1}. Kart',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardImage(TarotCard card, bool reversed) {
    return Transform.rotate(
      angle: reversed ? 3.14159 : 0,
      child: Image.asset(
        card.imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}
