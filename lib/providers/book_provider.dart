// lib/providers/book_provider.dart

import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

enum BookState { initial, loading, loaded, error }

class BookProvider with ChangeNotifier {


  List<Book> _searchResults = [];
  List<Book> get searchResults => _searchResults;

  BookState _searchState = BookState.initial;
  BookState get searchState => _searchState;

  // Mengambil list buku berdasarkan query pencarian
  Future<void> searchBooks(String query) async {
    // Jika query kosong, jangan lakukan pencarian
    if (query.isEmpty) {
      _searchResults = [];
      _searchState = BookState.initial;
      notifyListeners();
      return;
    }

    _searchState = BookState.loading;
    notifyListeners();
    
    try {
      _searchResults = await _apiService.searchBooks(query);
      _searchState = BookState.loaded;
    } catch (e) {
      _searchState = BookState.error;
    }
    notifyListeners();
  }


  final ApiService _apiService = ApiService();

  // Untuk list buku di Home
  List<Book> _books = [];
  List<Book> get books => _books;
  BookState _bookListState = BookState.initial;
  BookState get bookListState => _bookListState;

  // Untuk detail buku
  Book? _selectedBook;
  Book? get selectedBook => _selectedBook;
  BookState _bookDetailState = BookState.initial;
  BookState get bookDetailState => _bookDetailState;

  // Mengambil list buku
  Future<void> getBooks() async {
    _bookListState = BookState.loading;
    notifyListeners();
    try {
      _books = await _apiService.fetchBooks();
      _bookListState = BookState.loaded;
    } catch (e) {
      _bookListState = BookState.error;
    }
    notifyListeners();
  }

  // Mengambil detail satu buku
  Future<void> getBookDetails(int bookId) async {
    _bookDetailState = BookState.loading;
    // Reset buku sebelumnya agar tidak menampilkan data lama
    _selectedBook = null; 
    notifyListeners();
    try {
      _selectedBook = await _apiService.fetchBookDetails(bookId);
      _bookDetailState = BookState.loaded;
    } catch (e) {
      _bookDetailState = BookState.error;
    }
    notifyListeners();
  }
}