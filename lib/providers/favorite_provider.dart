import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/book.dart';
import '../models/favorite_book.dart';

class FavoriteProvider with ChangeNotifier {
  Box<FavoriteBook>? _favoriteBox;

  List<FavoriteBook> _favorites = [];
  final Set<int> _favoriteIds = {};

  List<FavoriteBook> get favorites => _favorites;

  String? _currentUsername;
  String? get currentUsername => _currentUsername;

  Future<void> updateUser(String? newUsername) async {
    if (_currentUsername == newUsername) return;

    _currentUsername = newUsername;

    if (newUsername == null) {
      if (_favoriteBox != null && _favoriteBox!.isOpen) {
        await _favoriteBox!.close();
      }
      _favoriteBox = null;
      _favorites = [];
      _favoriteIds.clear();
      notifyListeners();
      return;
    }

    if (_favoriteBox != null && _favoriteBox!.isOpen) {
      await _favoriteBox!.close();
    }

    _favoriteBox =
        await Hive.openBox<FavoriteBook>('favorites_$newUsername');
    _loadFavorites(); 
  }

  void _loadFavorites() {
    if (_favoriteBox == null) return;
    _favorites = _favoriteBox!.values.toList();
    _favoriteIds.clear();
    for (var fav in _favorites) {
      _favoriteIds.add(fav.id);
    }
    notifyListeners();
  }

  bool isFavorite(int bookId) {
    if (_favoriteBox == null) return false;
    return _favoriteIds.contains(bookId);
  }

  Future<void> toggleFavorite(Book book) async {
    if (_favoriteBox == null || !_favoriteBox!.isOpen) return;

    if (isFavorite(book.id)) {
      await _favoriteBox!.delete(book.id);
      _favorites.removeWhere((fav) => fav.id == book.id);
      _favoriteIds.remove(book.id);
    } else {
      final newFavorite = FavoriteBook(
        id: book.id,
        title: book.title,
        author: book.firstAuthorName,
        imageUrl: book.formats.imageJpeg,
      );
      await _favoriteBox!.put(book.id, newFavorite);
      _favorites.add(newFavorite);
      _favoriteIds.add(book.id);
    }
    notifyListeners();
  }

  Future<void> removeFavorite(int bookId) async {
    if (_favoriteBox == null || !_favoriteBox!.isOpen) return;

    if (isFavorite(bookId)) {
      await _favoriteBox!.delete(bookId);
      _favorites.removeWhere((fav) => fav.id == bookId);
      _favoriteIds.remove(bookId);
      notifyListeners();
    }
  }
}