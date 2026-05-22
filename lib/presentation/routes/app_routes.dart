import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/books_list_screen.dart';
import '../screens/book_details_screen.dart';
import '../screens/favorites_screen.dart';

final appRoutes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScaffold(),
      routes: [
        GoRoute(
          path: 'book-details',
          name: 'book-details',
          builder: (context, state) {
            final bookId = state.extra as String;
            return BookDetailsScreen(bookId: bookId);
          },
        ),
      ],
    ),
  ],
);

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [const BooksListScreen(), const FavoritesScreen()];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Books'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
