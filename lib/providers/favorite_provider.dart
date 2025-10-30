import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/book.dart';
import '../models/favorite_book.dart';

class FavoriteProvider with ChangeNotifier {
  late Box<FavoriteBook> _favoriteBox;
  
  List<FavoriteBook> _favorites = [];
  final Set<int> _favoriteIds = {};

  List<FavoriteBook> get favorites => _favorites;

  FavoriteProvider() {
    _init();
  }

  Future<void> _init() async {
    _favoriteBox = await Hive.openBox<FavoriteBook>('favorites');
    _loadFavorites();
  }

  void _loadFavorites() {
    _favorites = _favoriteBox.values.toList();
    _favoriteIds.clear();
    for (var fav in _favorites) {
      _favoriteIds.add(fav.id);
    }
    notifyListeners();
  }

  bool isFavorite(int bookId) {
    return _favoriteIds.contains(bookId);
  }

  Future<void> toggleFavorite(Book book) async {
    if (isFavorite(book.id)) {
      await _favoriteBox.delete(book.id);
      _favorites.removeWhere((fav) => fav.id == book.id);
      _favoriteIds.remove(book.id);
    } else {
      final newFavorite = FavoriteBook(
        id: book.id,
        title: book.title,
        author: book.firstAuthorName,
        imageUrl: book.formats.imageJpeg,
      );
      await _favoriteBox.put(book.id, newFavorite);
      _favorites.add(newFavorite);
      _favoriteIds.add(book.id);
    }
    notifyListeners();
  }

  // --- TAMBAHKAN FUNGSI BARU INI ---
  // Fungsi ini khusus untuk menghapus dari halaman favorit
  Future<void> removeFavorite(int bookId) async {
    if (isFavorite(bookId)) { // Cek apakah masih ada
      await _favoriteBox.delete(bookId);
      _favorites.removeWhere((fav) => fav.id == bookId);
      _favoriteIds.remove(bookId);
      notifyListeners();
    }
  }
  // --- BATAS FUNGSI BARU ---
}
