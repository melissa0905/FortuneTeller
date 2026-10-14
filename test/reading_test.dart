import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortune_teller/models/tarot_card.dart';
import 'package:fortune_teller/models/tarot_interpretations.dart';
import 'package:fortune_teller/screens/card_detail_screen.dart';
import 'package:fortune_teller/screens/reading_screen.dart';

void main() {
  test('All 78 cards have distinct expanded meanings in both orientations', () {
    expect(TarotDeck.cards.length, 78);
    expect(tarotInterpretations.length, 78);
    final meanings = <String>{};
    for (final card in TarotDeck.cards) {
      for (final reversed in [false, true]) {
        final meaning = card.interpretation(reversed);
        expect(meaning.split(' ').length, greaterThan(30));
        expect(meanings.add(meaning), isTrue);
      }
    }
  });

  for (final count in [1, 3, 7]) {
    testWidgets(
        '$count cards can be selected directly and read without dialogs',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ReadingScreen(cardCount: count),
      ));
      expect(find.byType(TextField), findsNothing);
      for (var i = 0; i < count; i++) {
        final card = find.byKey(const ValueKey('deck-card-0'));
        await tester.ensureVisible(card);
        await tester.tap(card);
        await tester.pump();
      }
      await tester.pump(const Duration(seconds: 3));
      expect(find.byType(Dialog), findsNothing);
      expect(find.text('$count/$count Kart Seçildi'), findsOneWidget);
      final titles = <String>{};
      for (var i = 0; i < count; i++) {
        final reading = find.byKey(ValueKey('interpretation-$i'));
        expect(reading, findsOneWidget);
        final texts = tester
            .widgetList<Text>(find.descendant(
              of: reading,
              matching: find.byType(Text),
            ))
            .toList();
        expect(texts.last.data!.length, greaterThan(200));
        titles.add(texts.first.data!.split('. ').last);
      }
      expect(titles.length, count);
      await tester.ensureVisible(find.text('Yeni Çekiş'));
      await tester.tap(find.text('Yeni Çekiş'));
      await tester.pumpAndSettle();
      expect(find.text('0/$count Kart Seçildi'), findsOneWidget);
      expect(find.byKey(const ValueKey('interpretation-0')), findsNothing);
      expect(find.byKey(const ValueKey('deck-card-0')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Long card details scroll on a small screen', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
          body: CardDetailDialog(
        card: TarotDeck.cards.first,
        isReversed: true,
      )),
    ));
    expect(
        find.text(TarotDeck.cards.first.interpretation(true)), findsOneWidget);
    await tester.ensureVisible(find.text('Kapat'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Deck scrolls to the last card on a small phone', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(
      home: ReadingScreen(cardCount: 1),
    ));
    final first = find.byKey(const ValueKey('deck-card-0'));
    final size = tester.getSize(first);
    expect(size.width, greaterThanOrEqualTo(60));
    expect(size.height, greaterThan(size.width * 1.5));
    final last = find.byKey(const ValueKey('deck-card-77'));
    await tester.ensureVisible(last);
    await tester.tap(last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const ValueKey('interpretation-0')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
