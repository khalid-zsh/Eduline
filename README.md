# Eduline

A Flutter-based product management app with offline support, built using GetX state management and a clean feature folder architecture.

---

## Features

- **Authentication** — Login, signup, forgot password, OTP verification, password reset
- **Product Management** — Add, edit, delete, and view products with image upload
- **Offline Support** — Local caching with automatic sync when reconnected
- **Location Aware** — Fetches and displays user location on the home screen
- **Onboarding** — Splash screen and introduction slides for new users
- **Profile** — View and edit user profile

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | GetX |
| HTTP Client | http |
| Local Storage | path / shared_preferences |
| File Picker | file_picker |
| Location | geolocator, geocoding |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/        # API endpoints, route names
│   ├── extensions/       # BuildContext extensions
│   └── theme/            # App colors
│
├── features/
│   ├── auth/             # Login, signup, password reset
│   │   ├── controllers/
│   │   ├── data/
│   │   ├── models/
│   │   └── screens/
│   ├── home/             # Home screen, app bar
│   │   ├── screens/
│   │   └── widgets/
│   ├── product/          # Product CRUD
│   │   ├── controllers/
│   │   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── screens/
│   │   └── widgets/
│   ├── profile/          # User profile
│   │   └── screens/
│   ├── onboarding/       # Splash, intro slides
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── screens/
│   │   └── widgets/
│   └── location/         # Location & language selection
│       └── screens/
│
├── shared/
│   ├── services/         # Auth storage, file picker, preferences
│   └── widgets/          # Reusable UI components
│
├── routes/               # GetX route definitions
└── main.dart
```

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`

### Installation

```bash
# Clone the repository
git clone https://github.com/khalid-zsh/Eduline.git
cd eduline

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## Architecture

This project follows a **feature folder architecture** where every feature (auth, product, home etc.) contains its own controllers, data sources, models, screens, and widgets. Shared utilities live in `core/` and `shared/`.

```
Feature Folder Pattern:
features/
└── product/
    ├── controllers/   ← GetX controllers (business logic)
    ├── data/          ← Remote & local data sources
    ├── models/        ← Data classes
    ├── repositories/  ← Abstract + implementation
    ├── screens/       ← Full page UI
    └── widgets/       ← Feature-specific UI components
```

---

## Branch

| Branch | Description |
|---|---|
| `main` | Stable release |
| `refactor/feature-folder-structure` | Feature folder migration |

---

## Developer

**Khalid** — [@khalid-zsh](https://github.com/khalid-zsh)
