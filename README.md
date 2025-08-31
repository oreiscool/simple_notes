# Simple Notes

![Flutter](https://img.shields.io/badge/Flutter-3.35.1-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android-green?style=for-the-badge&logo=android)

A clean, minimalist note-taking app built with Flutter. Perfect for quick thoughts, ideas, and reminders.

## Features

- **Create & Edit Notes**: Simple and intuitive note creation
- **Search**: Find your notes quickly with search functionality
- **Pin Notes**: Keep important notes at the top
- **Dark/Light Theme**: Choose your preferred theme
- **Auto-Save**: Your notes are automatically saved as you type
- **Responsive Design**: Works great on all screen sizes
- **Material Design 3**: Modern, clean UI following Material Design principles

## Screenshots

<p align="center">
  <img src="screenshots/01-home-with-notes.png" width="250" alt="Home screen with notes" />
  <img src="screenshots/02-search-results.png" width="250" alt="Search functionality" />
  <img src="screenshots/04-note-editing.png" width="250" alt="Note editing interface" />
</p>

<p align="center">
  <img src="screenshots/05-dark-mode.png" width="250" alt="Dark mode support" />
  <img src="screenshots/06-settings-page.png" width="250" alt="Settings screen" />
  <img src="screenshots/03-empty-state.png" width="250" alt="Empty state design" />
</p>

## Tech Stack

- **Framework**: Flutter 3.35.1
- **State Management**: Riverpod
- **Database**: Drift (SQLite)
- **UI**: Material Design 3
- **Architecture**: Clean Architecture with Provider pattern

## Getting Started

### Prerequisites
- Flutter SDK (3.35.1 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/oreiscool/simple_notes.git
   cd simple_notes
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Building for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

## Project Structure

```
lib/
├── data/           # Database and data layer
├── models/         # Data models
├── pages/          # UI screens
├── provider/       # State management
└── widgets/        # Reusable UI components
```

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with Flutter
- Icons from Material Design
- Inspired by clean, minimalist design principles

---

**Made by Stevie**
