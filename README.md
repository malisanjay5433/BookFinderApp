# 📚 BookFinder App

A Flutter application that allows users to search for books, view detailed information, and save their favorite books locally using SQLite. Built with Clean Architecture principles and Riverpod for state management.

## ✨ Features

### 🔍 **Book Search**
- Search for books by title using Google Books API
- Display search results with book covers, titles, authors, and publication dates
- Pagination support for loading more results
- Pull-to-refresh functionality

### 📖 **Book Details**
- Comprehensive book information display
- Animated book cover with rotation and scale effects
- Book description, ratings, and metadata
- Save/unsave books to favorites with visual feedback

### ❤️ **Favorites Management**
- Dedicated "My Favorites" screen
- View all saved books in a beautiful list
- Delete books from favorites with confirmation
- Navigate to detailed view of saved books
- Save date tracking

### 🏗️ **Architecture & State Management**
- **Clean Architecture** with Domain, Data, and Presentation layers
- **Riverpod** for efficient state management
- **SQLite** for local data persistence
- **Dio** for HTTP requests with proper error handling

## 📸 Screenshots
<img width="300" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-01 at 18 09 16" src="https://github.com/user-attachments/assets/a9f0e1f3-5e67-4800-be19-2261c9157abf" />
<img width="300" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-01 at 18 09 47" src="https://github.com/user-attachments/assets/c25701e8-e341-4083-a680-a038ec1ae9c3" />
<img width="300" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-01 at 18 09 19" src="https://github.com/user-attachments/assets/83657606-2db5-4187-9e98-e42539330265" />
<img width="300" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-02 at 00 07 16" src="https://github.com/user-attachments/assets/b59cf6e1-a872-4a1d-8e65-ca9826f08c18" />
<img width="300" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-02 at 00 07 01" src="https://github.com/user-attachments/assets/4cfb4b0c-bed8-4a83-b823-8be739876ff4" />
<img width="300" height="2220" alt="Screenshot_20250902_003118" src="https://github.com/user-attachments/assets/d49340f6-bdc0-448b-82d7-d86b02da4bae" />
<img width="300" height="2220" alt="Screenshot_20250902_003059" src="https://github.com/user-attachments/assets/0b639a28-a631-4b8d-9b86-bfcdc76b6445" />

## 🛠️ Technologies Used

- **Flutter** - UI Toolkit for cross-platform development
- **Riverpod** - State management and dependency injection
- **Dio** - HTTP client for API requests
- **SQLite (sqflite)** - Local database for book storage
- **Path** - File path manipulation

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (comes with Flutter)
- iOS 12.0+ or Android API 21+

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/bookfinderapp.git
   cd bookfinderapp
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

### iOS Setup

If you encounter iOS build issues:

1. **Update deployment target:**
   ```bash
   cd ios
   rm -rf Pods Podfile.lock
   pod install
   cd ..
   ```

2. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # API constants and configuration
│   ├── database/           # SQLite database helper
│   ├── errors/             # Custom error types
│   ├── network/            # HTTP client setup
│   └── utils/              # Result wrapper and utilities
└── features/
    └── book_search/
        ├── data/
        │   ├── datasources/    # Remote and local data sources
        │   ├── models/         # Data transfer objects
        │   └── repositories/   # Repository implementations
        ├── domain/
        │   ├── entities/       # Business entities
        │   ├── repositories/   # Repository interfaces
        │   └── usecases/       # Business logic
        └── presentation/
            ├── pages/          # UI screens
            ├── providers/      # Riverpod providers
            └── widgets/        # Reusable UI components
```

## 🎯 Key Features Implementation

### Clean Architecture
- **Domain Layer**: Entities, repositories, and use cases
- **Data Layer**: Models, data sources, and repository implementations
- **Presentation Layer**: UI components, pages, and state management

### State Management
- **Riverpod Providers**: Dependency injection and state management
- **AsyncValue**: Proper loading, error, and data states
- **StateNotifier**: Reactive state updates

### Local Storage
- **SQLite Database**: Persistent book storage
- **CRUD Operations**: Save, read, update, delete books
- **Data Models**: Proper entity-to-model mapping

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🛣️ Roadmap

### Completed Features ✅
- [x] Basic book search functionality
- [x] Book details screen with animations
- [x] SQLite local storage
- [x] Favorites management
- [x] Clean architecture implementation
- [x] Riverpod state management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request



## 🙏 Acknowledgments

- Google Books API for book data
- Flutter team for the amazing framework
- Riverpod for excellent state management
- The Flutter community for inspiration and support

---

**Made with ❤️ using Flutter**
