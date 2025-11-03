import 'dart:convert';

List<Book> bookListFromJson(String str) =>
    List<Book>.from(json.decode(str)['results'].map((x) => Book.fromJson(x)));

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

class Book {
  final int id;
  final String title;
  final List<Author> authors;
  final List<String> subjects;
  final Formats formats;
  final int downloadCount;
  final String? summary; 

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.subjects,
    required this.formats,
    required this.downloadCount,
    this.summary,
  });

  factory Book.fromJson(Map<String, dynamic> json) {

    var authorsList = json['authors'] as List? ?? [];
    var subjectsList = json['subjects'] as List? ?? [];

    return Book(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      authors: authorsList.map((x) => Author.fromJson(x)).toList(),
      subjects: subjectsList.map((x) => x.toString()).toList(),
      formats: Formats.fromJson(json['formats']),
      downloadCount: json['download_count'] ?? 0,

      summary: json['summaries'] != null && (json['summaries'] as List).isNotEmpty
          ? (json['summaries'] as List).first
          : (json['description']), 
    );
  }


  String get firstAuthorName =>
      authors.isNotEmpty ? authors.first.name : 'Unknown Author';
}

class Author {
  final String name;

  Author({required this.name});

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        name: json['name'] ?? 'Unknown',
      );
}

class Formats {
  final String imageJpeg;

  Formats({required this.imageJpeg});

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        imageJpeg: json['image/jpeg'] ?? 'https://via.placeholder.com/150',
      );
}