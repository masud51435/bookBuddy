import 'package:bookbuddy/presentation/notifiers/books_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final booksListNotifierProvider =
    StateNotifierProvider<BooksListNotifier, BooksListState>((ref) {
      return BooksListNotifier(ref);
    });
