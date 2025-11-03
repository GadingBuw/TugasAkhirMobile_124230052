import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  final String _baseUrl = 'https://gutendex.com/books/';

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        return bookListFromJson(response.body);
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Book> fetchBookDetails(int bookId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$bookId/'));
      if (response.statusCode == 200) {
        return bookFromJson(response.body);
      } else {
        throw Exception('Failed to load book details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?search=$query'));
      if (response.statusCode == 200) {
        return bookListFromJson(response.body);
      } else {
        throw Exception('Failed to search books');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}