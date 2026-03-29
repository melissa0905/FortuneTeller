# Fortune Teller - Tarot Reading Application

A beautiful Flutter application for tarot card readings with support for single card, 3-card, and 7-card spreads.

## Features

✨ **Multiple Reading Types**
- Tek Kart (Single Card) Reading
- Üçlü Çekiş (3-Card Spread) Reading  
- Yedili Çekiş (7-Card Spread) Reading

🎨 **Beautiful UI**
- Dark theme with gradient backgrounds
- Smooth animations and transitions
- Card flip effects with orientation tracking
- Detailed card information dialogs

🔮 **Complete Tarot Deck**
- 22 Major Arcana cards
- Each card has upright and reversed meanings
- Descriptions and interpretations
- Random card orientation (upright/reversed)

## Getting Started

### Prerequisites
- Flutter SDK (version 3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode or another editor

### Installation

1. Clone the project:
```bash
cd FortuneTeller
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Project Structure

```
FortuneTeller/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── tarot_card.dart       # Tarot card data model
│   └── screens/
│       ├── home_screen.dart      # Reading type selection
│       ├── reading_screen.dart   # Card selection & reading
│       └── card_detail_screen.dart # Card details dialog
├── pubspec.yaml                  # Project dependencies
└── analysis_options.yaml         # Linting rules
```

## How to Use

1. **Launch the app** - You'll see the home screen with three reading options
2. **Select a reading type** - Choose between 1, 3, or 7 cards
3. **Select cards** - Click on the face-down cards to select them for your reading
4. **Reveal cards** - Click on selected cards to reveal their meanings
5. **View details** - A detailed dialog appears showing the card's interpretation
6. **Start new reading** - Tap "Yeni Çekiş" (New Reading) to start over

## Card Information

Each tarot card in the deck includes:
- Card name
- Full description
- Upright (positive) meaning
- Reversed (challenge) meaning

Cards are randomly shuffled and their orientation (upright/reversed) is randomly determined during selection.

## Built With

- **Flutter** - UI framework
- **Material 3** - Design system
- **Dart** - Programming language

## Customization

You can customize:
- Card descriptions and meanings in `lib/models/tarot_card.dart`
- Colors and themes in `lib/screens/home_screen.dart`
- Card layout and styling in `lib/screens/reading_screen.dart`

## Future Enhancements

- Persisting reading history
- Custom spread interpretations
- Audio for card reveals
- Multiple languages support
- Sharing readings

## License

This project is open source and available under the MIT License.

## Author

Created as a Flutter tarot reading application.

---

**Disclaimer**: This application is for entertainment purposes only. Tarot readings should not be taken as professional advice.
