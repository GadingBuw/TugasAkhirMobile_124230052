// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/book.dart'; // 1. Import model Book
// import '../providers/book_provider.dart';
// import '../providers/favorite_provider.dart'; // 2. Import FavoriteProvider

// class DetailScreen extends StatefulWidget {
//   final int bookId;
//   const DetailScreen({super.key, required this.bookId});

//   @override
//   State<DetailScreen> createState() => _DetailScreenState();
// }

// class _DetailScreenState extends State<DetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<BookProvider>(context, listen: false)
//           .getBookDetails(widget.bookId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 3. Pindahkan Consumer ke level tertinggi
//     return Consumer<BookProvider>(
//       builder: (context, bookProvider, child) {
//         final state = bookProvider.bookDetailState;
//         final Book? book = bookProvider.selectedBook; // Jadikan nullable

//         // 4. Handle loading/error state dengan Scaffold
//         if (state == BookState.loading || state == BookState.initial || book == null) {
//           return Scaffold(
//             appBar: AppBar(),
//             body: const Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (state == BookState.error) {
//           return Scaffold(
//             appBar: AppBar(title: const Text('Error')),
//             body: const Center(child: Text('Gagal memuat detail buku.')),
//           );
//         }

//         // 5. Build Scaffold utama setelah book dipastikan tidak null
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Detail Buku'),
//             // 6. Tambahkan Tombol Like/Unlike di AppBar
//             actions: [
//               Consumer<FavoriteProvider>(
//                 builder: (context, favProvider, child) {
//                   final bool isFavorited = favProvider.isFavorite(book.id);
//                   return IconButton(
//                     icon: Icon(
//                       isFavorited ? Icons.favorite : Icons.favorite_border,
//                       color: isFavorited ? Colors.red : null,
//                     ),
//                     tooltip: isFavorited ? 'Unlike' : 'Like',
//                     onPressed: () {
//                       // Gunakan 'book' dari BookProvider
//                       favProvider.toggleFavorite(book);
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(width: 8), // Sedikit padding
//             ],
//           ),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 1. Cover Buku
//                 Center(
//                   child: Hero(
//                     tag: 'book-cover-${book.id}',
//                     child: Image.network(
//                       book.formats.imageJpeg,
//                       height: 250,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Icon(Icons.book, size: 250);
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // 2. Judul
//                 Text(
//                   book.title,
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 8),

//                 // 3. Penulis
//                 Text(
//                   'Oleh: ${book.firstAuthorName}',
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontStyle: FontStyle.italic,
//                         color: Colors.grey[700],
//                       ),
//                 ),
//                 const SizedBox(height: 8),

//                 // 4. Download Count
//                 Row(
//                   children: [
//                     const Icon(Icons.download_rounded, size: 16, color: Colors.grey),
//                     const SizedBox(width: 4),
//                     Text(
//                       '${book.downloadCount} downloads',
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 const Divider(height: 30),

//                 // 5. Summary (jika ada)
//                 if (book.summary != null && book.summary!.isNotEmpty) ...[
//                   Text(
//                     'Ringkasan',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     book.summary!,
//                     textAlign: TextAlign.justify,
//                     style: const TextStyle(fontSize: 15, height: 1.5),
//                   ),
//                   const Divider(height: 30),
//                 ],

//                 // 6. Subjek/Genre
//                 Text(
//                   'Genre/Subjek',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 const SizedBox(height: 8),
//                 if (book.subjects.isEmpty)
//                   const Text('Tidak ada informasi subjek.')
//                 else
//                   Wrap(
//                     spacing: 8.0,
//                     runSpacing: 4.0,
//                     children: book.subjects
//                         .take(10)
//                         .map((subject) => Chip(
//                               label: Text(subject),
//                               backgroundColor: Colors.blue.shade50,
//                             ))
//                         .toList(),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../providers/favorite_provider.dart';

class DetailScreen extends StatefulWidget {
  final int bookId;
  const DetailScreen({super.key, required this.bookId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Color palette
  static const Color _brownDark = Color(0xFF3E2723);
  static const Color _brownMedium = Color(0xFF654321);
  static const Color _brownSaddle = Color(0xFF8B4513);
  static const Color _parchment = Color(0xFFF5E6D3);
  static const Color _gold = Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false)
          .getBookDetails(widget.bookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final state = bookProvider.bookDetailState;
        final Book? book = bookProvider.selectedBook;

        // Loading State
        if (state == BookState.loading || state == BookState.initial || book == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_brownSaddle, _brownMedium],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_brownSaddle, _brownMedium, _brownDark],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _parchment,
                        shape: BoxShape.circle,
                        border: Border.all(color: _gold, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(_brownSaddle),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: _parchment,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _gold, width: 2),
                      ),
                      child: const Text(
                        'Memuat detail buku...',
                        style: TextStyle(
                          color: _brownDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Error State
        if (state == BookState.error) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_brownSaddle, _brownMedium],
                  ),
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _brownSaddle.withOpacity(0.1),
                    _parchment.withOpacity(0.3),
                    Colors.white,
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _parchment,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _gold, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade700),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal Memuat Detail Buku',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _brownDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Success State - Main Content
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Detail Buku',
              style: TextStyle(
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_brownSaddle, _brownMedium],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              Consumer<FavoriteProvider>(
                builder: (context, favProvider, child) {
                  final bool isFavorited = favProvider.isFavorite(book.id);
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: _parchment.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.red.shade400 : _parchment,
                        size: 26,
                      ),
                      tooltip: isFavorited ? 'Unlike' : 'Like',
                      onPressed: () {
                        favProvider.toggleFavorite(book);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  isFavorited ? Icons.heart_broken : Icons.favorite,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  isFavorited
                                      ? 'Dihapus dari favorit'
                                      : 'Ditambahkan ke favorit',
                                ),
                              ],
                            ),
                            backgroundColor: _brownMedium,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _brownSaddle.withOpacity(0.05),
                  _parchment.withOpacity(0.2),
                  Colors.white,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover Section with decorative frame
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _brownSaddle.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'book-cover-${book.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _gold, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book.formats.imageJpeg,
                              height: 280,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 280,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: _parchment,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.menu_book_rounded,
                                    size: 100,
                                    color: _brownSaddle,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content Section
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _parchment,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _gold, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: _brownSaddle.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                book.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _brownDark,
                                  height: 1.3,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Decorative divider
                              Container(
                                height: 2,
                                width: 60,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [_gold, Colors.transparent],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Author
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: _gold.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.person_outline_rounded,
                                      size: 18,
                                      color: _brownSaddle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      book.firstAuthorName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: _brownMedium,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Download Count
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: _gold.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.download_rounded,
                                      size: 18,
                                      color: _brownSaddle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${book.downloadCount} downloads',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _brownMedium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Summary Section
                        if (book.summary != null && book.summary!.isNotEmpty) ...[
                          _buildSectionTitle('Ringkasan'),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _gold.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _brownSaddle.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              book.summary!,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                color: _brownMedium,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Genre/Subject Section
                        _buildSectionTitle('Genre & Subjek'),
                        const SizedBox(height: 12),
                        if (book.subjects.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: _parchment.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _gold.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Tidak ada informasi subjek.',
                              style: TextStyle(
                                color: _brownMedium,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        else
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: book.subjects
                                .take(10)
                                .map((subject) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _brownSaddle.withOpacity(0.1),
                                            _gold.withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _gold.withOpacity(0.4),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.label_outline_rounded,
                                            size: 16,
                                            color: _brownSaddle,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            subject,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: _brownDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_gold, _brownSaddle],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _brownDark,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}