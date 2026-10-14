import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/tarot_card_back.dart';
import 'reading_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _gold = Color(0xFFE1C48D);

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
      backgroundColor: const Color(0xFF160D2B),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.4, -0.55),
            radius: 1.3,
            colors: [Color(0xFF432461), Color(0xFF160D2B)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Fortune Teller',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                          color: Color(0xFFF6EEDF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tarot Reading',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 3.5,
                        color: _gold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _WelcomeCards(),
                    const SizedBox(height: 20),
                    const Text(
                      'Kartların hikâyesi\nseninle başlasın.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                        height: 1.25,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF6EEDF),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Kendine bir an ayır, sezgilerine kulak ver. '
                        'Sana yakın gelen kartları seç ve sembollerin dünyasını keşfet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.65,
                          color: Color(0xFFBEB0CF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Color(0xFF574165))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'AÇILIMINI SEÇ',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 2,
                              color: _gold,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Color(0xFF574165))),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _readingOption(
                        context, 1, 'Tek Kart', 'Bir kart, bir anlık ilham',
                        featured: true),
                    const SizedBox(height: 10),
                    _readingOption(context, 3, 'Üçlü Çekiş',
                        'Üç sembolle daha geniş bir bakış'),
                    const SizedBox(height: 10),
                    _readingOption(context, 7, 'Yedili Çekiş',
                        'Kartların dünyasına derin bir yolculuk'),
                    const SizedBox(height: 24),
                    const Text(
                      '✧  Her seçim, kendine ayırdığın bir an.  ✧',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: Color(0xFF9B88AD),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _readingOption(
    BuildContext context,
    int count,
    String title,
    String subtitle, {
    bool featured = false,
  }) {
    return Material(
      color: featured ? const Color(0xFF483051) : const Color(0xFF2B1D3D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: featured ? const Color(0xFFB99A64) : const Color(0xFF513C64),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _startReading(context, count),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF231530),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: const Color(0xFF846B50)),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: _gold,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF6EEDF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Color(0xFFBEB0CF),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: _gold),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeCards extends StatelessWidget {
  const _WelcomeCards();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 248,
        height: 164,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 230,
              height: 150,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0x306E4A8B), Color(0x006E4A8B)],
                ),
              ),
            ),
            Positioned(
              left: 39,
              top: 18,
              child: Transform.rotate(
                angle: -math.pi / 9,
                child: const SizedBox(
                  width: 76,
                  height: 126,
                  child: TarotCardBack(),
                ),
              ),
            ),
            Positioned(
              right: 39,
              top: 18,
              child: Transform.rotate(
                angle: math.pi / 9,
                child: const SizedBox(
                  width: 76,
                  height: 126,
                  child: TarotCardBack(),
                ),
              ),
            ),
            const Positioned(
              top: 4,
              child: SizedBox(
                width: 84,
                height: 140,
                child: TarotCardBack(),
              ),
            ),
            const Positioned(
              left: 9,
              top: 31,
              child:
                  Icon(Icons.auto_awesome, size: 15, color: Color(0xFFD9B779)),
            ),
            const Positioned(
              right: 6,
              bottom: 22,
              child:
                  Icon(Icons.auto_awesome, size: 12, color: Color(0xFFD9B779)),
            ),
          ],
        ),
      ),
    );
  }
}
