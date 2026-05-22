# BookBuddy 📚

A professional Flutter mobile app for browsing and managing your favorite books from Google Books API, built with clean architecture, Riverpod state management, and support for multiple app flavors.

## Features

✨ **Core Features**
- 📖 Browse thousands of books from Google Books API
- 🔍 Search books by title and author  
- 📄 Infinite scroll pagination (loads 10 books at a time)
- 🔄 Pull-to-refresh functionality
- ❤️ Save favorite books with local persistence (Hive)
- 📊 Detailed book information display
- ⚠️ Comprehensive error handling
- 🎯 Loading states with indicators

## Architecture

**Clean Layered Architecture** with three independent layers:
- **Presentation**: UI, screens, Riverpod providers
- **Domain**: Entities, usecases, repository interfaces (business logic)
- **Data**: Models, datasources, repository implementations

**Tech Stack**:
- **State Management**: Riverpod (compile-time safe)
- **Local Storage**: Hive (fast, type-safe)
- **Networking**: Dio (with interceptors)
- **Navigation**: GoRouter
- **Serialization**: json_serializable

## Installation

### Prerequisites
- Flutter SDK 3.12.0+
- Dart 3.12.0+
- Internet connection

### Setup

```bash
# Clone repo
git clone <repo-url>
cd bookbuddy

# Get dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

### Running Different Flavors

```bash
# Development (default)
flutter run -t lib/main_dev.dart

# Staging
flutter run -t lib/main_staging.dart

# Production  
flutter run -t lib/main_prod.dart
```

## Project Structure

```
lib/
├── config/           # Flavor & app configuration
├── core/             # Errors, logging, network
├── data/             # Models, datasources, repositories
├── domain/           # Entities, usecases, repository interfaces
├── presentation/     # Screens, widgets, providers, routes
├── main_*.dart       # Flavor entry points
└── main.dart         # Default (dev)
```

## Key Features Explained

### 📚 Books Browsing
- Loads 10 books per page from Google Books API
- Infinite scroll with "Load More" button
- Pull-to-refresh to reload from page 1

### 🔍 Search
- Real-time search by title/author
- Debounced to prevent API spam
- Clear button to reset search

### ❤️ Favorites
- Save books locally with Hive
- Dedicated Favorites tab
- Persists across app restarts

### 📖 Book Details
- Full information display
- Responsive image with fallback
- Add/remove from favorites

### ⚠️ Error Handling
- Network error messages with retry
- Timeout handling (30 sec)
- Empty state messages

## State Management (Riverpod)

Key providers:
```dart
// Dependency injection
final bookRepositoryProvider = Provider<BookRepository>(...);

// Async data
final booksProvider = FutureProvider.autoDispose<List<BookEntity>>(...);

// State  
final searchQueryProvider = StateProvider((ref) => '');

// Computed
final currentBooksProvider = FutureProvider.autoDispose<List<BookEntity>>(...);
```

Usage in widgets:
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);
    return books.when(
      data: (books) => ListView(...),
      loading: () => LoadingWidget(),
      error: (err, _) => AppErrorWidget(message: err.toString()),
    );
  }
}
```

## API Integration

**Google Books API v1**
- Endpoint: `https://www.googleapis.com/books/v1`
- Free tier: ~1000 requests/day
- API Key in: `lib/config/app_config.dart` (Replace with your own key for production)

Query example:
```
GET /volumes?q=flutter&pageIndex=0&maxResults=10&key=API_KEY
```

## Local Storage

Favorites stored in Hive box `'favorites'`:
```dart
// Add favorite
await box.put(bookId, bookId);

// Remove favorite  
await box.delete(bookId);

// Check if favorite
bool isFav = box.containsKey(bookId);
```

Persists across app restarts.

## App Flavors

| Flavor | Purpose | Debug |
|--------|---------|-------|
| dev | Development | ✅ Yes |
| staging | Pre-production | ✅ Yes |
| production | Live release | ❌ No |

Customize in `lib/config/flavors.dart`.

## Error Handling

Exception → Failure → UI flow:

```dart
try {
  data = await api.fetchBooks()
} on NetworkException catch (e) {
  return ResultFailure(NetworkFailure(e.message));
}
```

Handled errors:
- Network failures
- Timeouts (30s)
- Server errors
- Parse errors
- Not found

## Testing Workflow

### ✅ Happy Path
1. Launch app → Books load
2. Scroll → "Load More" loads next page
3. Pull down → Refreshes list
4. Search → Filters results
5. Tap book → Details open
6. Heart icon → Adds to favorites
7. Favorites tab → Shows saved books

### ⚠️ Error Cases
1. No internet → "Network error" with retry
2. Timeout → "Request timed out"
3. Empty search → "No books found"
4. No favorites → "No favorites yet"

## Troubleshooting

**Build fails**:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Books not loading**:
- Check internet connection
- Verify API key validity
- Check rate limits

**Favorites not saving**:
- Verify Hive initialization in main_*.dart
- Check app permissions
- Rebuild with `flutter clean`

## Project Quality

✅ Clean architecture separation
✅ Type-safe code (sealed classes)
✅ Null-safety compliant
✅ Comprehensive error handling
✅ Professional code style
✅ Auto-dispose patterns for efficiency

## Future Enhancements

- 📚 Reading lists
- ⭐ Personal ratings & reviews  
- 🌙 Dark theme
- 📱 Responsive design improvements
- 🔔 Recommendations
- 📖 Offline reading

## License

MIT License - Open source

## Support

For issues or questions, please open a GitHub issue.

---

**Built with ❤️ using Flutter & Riverpod**
