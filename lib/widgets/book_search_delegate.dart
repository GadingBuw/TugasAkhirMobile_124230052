// lib/widgets/book_search_delegate.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../screens/detail_screen.dart';

class BookSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Cari judul atau penulis...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF8B4513), // Saddle brown
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFF5E6D3)),
        titleTextStyle: TextStyle(
          color: Color(0xFFF5E6D3),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xFFF5E6D3).withOpacity(0.6),
          fontSize: 16,
        ),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: Color(0xFFF5E6D3),
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFD4AF37).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.clear_rounded,
                color: Color(0xFFF5E6D3),
                size: 20,
              ),
            ),
            onPressed: () {
              query = '';
            },
          ),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFD4AF37).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFFF5E6D3),
            size: 20,
          ),
        ),
        onPressed: () {
          close(context, null);
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    
    if (query.isNotEmpty) {
      bookProvider.searchBooks(query);
    }

    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildEmptyState();
    }
    
    return _buildPromptState();
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8B4513).withOpacity(0.1),
            Color(0xFF654321).withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFFF5E6D3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8B4513).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                border: Border.all(
                  color: Color(0xFFD4AF37),
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.search_rounded,
                size: 60,
                color: Color(0xFF8B4513),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Jelajahi Koleksi Kami',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Ketik judul buku atau nama penulis untuk menemukan novel favorit Anda',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF654321),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Decorative divider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFFD4AF37),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    color: Color(0xFFD4AF37),
                    size: 20,
                  ),
                ),
                Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFD4AF37),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8B4513).withOpacity(0.1),
            Color(0xFF654321).withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xFFF5E6D3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFFD4AF37),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF8B4513).withOpacity(0.2),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.keyboard_return_rounded,
                size: 48,
                color: Color(0xFF8B4513),
              ),
              const SizedBox(height: 16),
              Text(
                'Tekan Enter untuk Mencari',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'atau ketik lebih lanjut untuk melihat saran',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF654321),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        final state = provider.searchState;

        if (state == BookState.loading) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8B4513).withOpacity(0.1),
                  Color(0xFF654321).withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5E6D3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFD4AF37), width: 3),
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Mencari buku...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF654321),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state == BookState.error) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8B4513).withOpacity(0.1),
                  Color(0xFF654321).withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFFF5E6D3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade300, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal Melakukan Pencarian',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Silakan coba lagi',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF654321),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state == BookState.loaded && provider.searchResults.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8B4513).withOpacity(0.1),
                  Color(0xFF654321).withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFFF5E6D3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFD4AF37), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF8B4513).withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 64,
                      color: Color(0xFF8B4513).withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Buku Tidak Ditemukan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Buku "$query" tidak tersedia di koleksi kami',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF654321),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state == BookState.loaded) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8B4513).withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.searchResults.length,
              itemBuilder: (context, index) {
                final book = provider.searchResults[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5E6D3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFD4AF37).withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF8B4513).withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 50,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFFD4AF37),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          book.formats.imageJpeg,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Color(0xFF8B4513).withOpacity(0.2),
                              child: Icon(
                                Icons.menu_book_rounded,
                                color: Color(0xFF8B4513),
                                size: 28,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: Color(0xFF8B4513),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              book.firstAuthorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF654321),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFD4AF37).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    onTap: () {
                      close(context, null);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(bookId: book.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }

        return _buildEmptyState();
      },
    );
  }
}