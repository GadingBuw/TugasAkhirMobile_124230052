import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

enum BookState { initial, loading, loaded, error }

class BookProvider with ChangeNotifier {


  List<Book> _searchResults = [];
  List<Book> get searchResults => _searchResults;

  BookState _searchState = BookState.initial;
  BookState get searchState => _searchState;

  Future<void> searchBooks(String query) async {
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

  List<Book> _books = [];
  List<Book> get books => _books;
  BookState _bookListState = BookState.initial;
  BookState get bookListState => _bookListState;

  Book? _selectedBook;
  Book? get selectedBook => _selectedBook;
  BookState _bookDetailState = BookState.initial;
  BookState get bookDetailState => _bookDetailState;

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

  Future<void> getBookDetails(int bookId) async {
    _bookDetailState = BookState.loading;
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