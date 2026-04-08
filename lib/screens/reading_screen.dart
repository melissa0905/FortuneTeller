import 'dart:math';

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

  final TextEditingController _intentController = TextEditingController();
  bool _intentConfirmed = false;

  @override
  void initState() {
    super.initState();
    deck = TarotDeck.getShuffledDeck();
    selectedCards = [];
    isRevealed = [];
    isReversed = [];
  }

  @override
  void dispose() {
    _intentController.dispose();
    super.dispose();
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
      _intentController.clear();
      _intentConfirmed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool compact = MediaQuery.of(context).size.height < 700;
    final double topPadding = compact ? 20 : 50;
    final double sectionGap = compact ? 20 : 40;
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
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double gridHeight =
                    constraints.maxHeight * (compact ? 0.48 : 0.54);
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

                      // Intent / Question Entry
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Soru / Niyet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (!_intentConfirmed) ...[
                              TextField(
                                controller: _intentController,
                                maxLines: 3,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white12,
                                  hintText:
                                      'Kartları çekerken odaklanmak istediğiniz niyetinizi yazın...',
                                  hintStyle:
                                      const TextStyle(color: Colors.white54),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _intentController.text.trim().isEmpty
                                    ? null
                                    : () {
                                        setState(() {
                                          _intentConfirmed = true;
                                        });
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                ),
                                child: const Text('Niyeti Onayla'),
                              ),
                            ] else ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Seçilen niyet: ${_intentController.text}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _intentConfirmed = false;
                                  });
                                },
                                child: const Text('Niyeti Değiştir',
                                    style: TextStyle(color: Colors.amber)),
                              ),
                            ],
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

                      SizedBox(height: sectionGap),

                      // Card Selection Grid
                      if (!_intentConfirmed)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Kart çekmek için önce niyetinizi onaylayın.',
                              style: TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else if (selectedCards.length < widget.cardCount)
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
                              const SizedBox(height: 15),
                              SizedBox(
                                height: gridHeight,
                                child: _buildCardGrid(),
                              ),
                            ],
                          ),
                        ),

                      // Action Buttons
                      if (selectedCards.length == widget.cardCount)
                        Padding(
                          padding: EdgeInsets.all(compact ? 16 : 30),
                          child: Column(
                            children: [
                              const Text(
                                'Kartlara Tıklayarak Açınız',
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
    const double spacing = 2;
    const double targetSize = 28;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxW = constraints.maxWidth;
        final double maxH = constraints.maxHeight;

        int columns = ((maxW + spacing) / (targetSize + spacing)).floor();
        columns = max(1, columns);
        final int rows = (deck.length / columns).ceil();

        final double sizeByWidth = (maxW - spacing * (columns - 1)) / columns;
        final double sizeByHeight = (maxH - spacing * (rows - 1)) / rows;
        final double cardSize = max(16, min(sizeByWidth, sizeByHeight));
        final double iconSize = max(8, cardSize * 0.5);
        final double numberSize = max(7, cardSize * 0.22);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: 1,
          ),
          itemCount: deck.length,
          itemBuilder: (context, index) {
            return _buildCardButton(
              index,
              width: cardSize,
              height: cardSize,
              iconSize: iconSize,
              numberSize: numberSize,
              borderWidth: 0.8,
              showIndex: false,
            );
          },
        );
      },
    );
  }

  Widget _buildCardButton(
    int index, {
    double? width,
    double? height,
    double iconSize = 32,
    double numberSize = 12,
    double borderWidth = 2,
    bool showIndex = true,
  }) {
    return GestureDetector(
      onTap: () => _selectCard(index),
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade700,
            borderRadius: BorderRadius.zero,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: borderWidth,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxH = constraints.maxHeight;
              final double icon = min(iconSize, maxH * (showIndex ? 0.5 : 0.7));
              final double number = min(numberSize, maxH * 0.18);
              final double gap = max(1, maxH * 0.04);

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🂠',
                    style: TextStyle(fontSize: icon),
                  ),
                  if (showIndex) ...[
                    SizedBox(height: gap),
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: number,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
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
          Container(
            width: 105,
            height: 140,
            decoration: BoxDecoration(
              color: revealed ? null : Colors.deepPurple.shade800,
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(
              //   color: Colors.amber,
              //   width: 2,
              // ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.amber.withValues(alpha: 0.4),
              //     blurRadius: 12,
              //   ),
              // ],
            ),
            child: revealed
                ? Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildCardImage(card, isReversed[index]),
                        ),
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
          const SizedBox(height: 6),
          SizedBox(
            width: 105,
            child: Text(
              revealed ? card.name : '',
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
        fit: BoxFit.cover,
      ),
    );
  }
}
