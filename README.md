# ⭐ RateMaster

RateMaster is a modern Flutter app that lets users discover, rate, and review items across various categories. The app features a clean UI, multi-language support (English & French), and a robust rating system.

---

## Features

- **Browse & Search**: Explore items by category or search by name/tags.
- **Rate & Review**: Submit ratings and comments for items.
- **Personal Stats**: View your review history and statistics.
- **Profile Management**: Edit your profile and manage your account.
- **Dark Mode**: Switch between light and dark themes.
- **Localization**: English and French support.
- **Notifications**: Stay updated with app notifications.

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart](https://dart.dev/get-dart)
- A device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Alwil17/rate-master.git
   cd rate-master
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

- `lib/`
  - `models/` – Data models (Item, Category, Rating, User, etc.)
  - `providers/` – State management (using Provider)
  - `services/` – API and business logic
  - `screens/` – UI screens (Home, Auth, Profile, Items, etc.)
  - `shared/` – Shared widgets, themes, and utilities
  - `l10n/` – Localization files

---

## 🧑‍💻 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

This project is licensed under the MIT License.

---

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Provider](https://pub.dev/packages/provider)
- [GoRouter](https://pub.dev/packages/go_router)
- [EasyLoading](https://pub.dev/packages/flutter_easyloading)