// // lib/screens/tabs/home_tab.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/book_provider.dart';
// import '../../providers/favorite_provider.dart';
// import '../detail_screen.dart';
// import '../../widgets/book_search_delegate.dart';

// class HomeTab extends StatefulWidget {
//   const HomeTab({super.key});

//   @override
//   State<HomeTab> createState() => _HomeTabState();
// }

// class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _animationController.forward();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = Provider.of<BookProvider>(context, listen: false);
//       if (provider.books.isEmpty) {
//         provider.getBooks();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF8B4513), // Saddle brown
//               Color(0xFF654321), // Dark brown
//               Color(0xFF3E2723), // Very dark brown
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Custom AppBar dengan desain klasik
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF5E6D3).withOpacity(0.95),
//                   border: Border(
//                     bottom: BorderSide(color: Color(0xFFD4AF37), width: 3),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Color(0xFFD4AF37),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(
//                         Icons.menu_book_rounded,
//                         color: Color(0xFF3E2723),
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'PERPUSTAKAAN',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w300,
//                               color: Color(0xFF8B4513),
//                               letterSpacing: 2,
//                             ),
//                           ),
//                           Text(
//                             'Novel Klasik',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF3E2723),
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Color(0xFF8B4513).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: IconButton(
//                         icon: Icon(Icons.search_rounded, color: Color(0xFF8B4513)),
//                         tooltip: 'Cari Buku',
//                         onPressed: () {
//                           showSearch(
//                             context: context,
//                             delegate: BookSearchDelegate(),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Body - Daftar Buku
//               Expanded(
//                 child: Consumer<BookProvider>(
//                   builder: (context, bookProvider, child) {
//                     final state = bookProvider.bookListState;

//                     if (state == BookState.loading || state == BookState.initial) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'Memuat koleksi buku...',
//                               style: TextStyle(
//                                 color: Color(0xFFF5E6D3),
//                                 fontSize: 14,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     if (state == BookState.error) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.error_outline, color: Color(0xFFD4AF37), size: 60),
//                             const SizedBox(height: 16),
//                             Text(
//                               'Gagal memuat koleksi buku',
//                               style: TextStyle(
//                                 color: Color(0xFFF5E6D3),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Silakan coba lagi nanti',
//                               style: TextStyle(
//                                 color: Color(0xFFF5E6D3).withOpacity(0.7),
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     if (state == BookState.loaded && bookProvider.books.isEmpty) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.book_outlined, color: Color(0xFFD4AF37), size: 60),
//                             const SizedBox(height: 16),
//                             Text(
//                               'Tidak ada buku yang ditemukan',
//                               style: TextStyle(
//                                 color: Color(0xFFF5E6D3),
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     return FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: ListView.builder(
//                         padding: const EdgeInsets.all(16),
//                         itemCount: bookProvider.books.length,
//                         itemBuilder: (context, index) {
//                           final book = bookProvider.books[index];
//                           return Container(
//                             margin: const EdgeInsets.only(bottom: 16),
//                             decoration: BoxDecoration(
//                               color: Color(0xFFF5E6D3),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: Color(0xFFD4AF37),
//                                 width: 2,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.3),
//                                   blurRadius: 12,
//                                   offset: Offset(0, 6),
//                                 ),
//                               ],
//                             ),
//                             child: Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 borderRadius: BorderRadius.circular(16),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => DetailScreen(bookId: book.id),
//                                     ),
//                                   );
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(12),
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       // Book Cover
//                                       Container(
//                                         width: 80,
//                                         height: 120,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           border: Border.all(
//                                             color: Color(0xFF8B4513),
//                                             width: 2,
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(0.2),
//                                               blurRadius: 6,
//                                               offset: Offset(2, 3),
//                                             ),
//                                           ],
//                                         ),
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(8),
//                                           child: Image.network(
//                                             book.formats.imageJpeg,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return Container(
//                                                 color: Color(0xFF8B4513).withOpacity(0.2),
//                                                 child: Icon(
//                                                   Icons.menu_book,
//                                                   size: 40,
//                                                   color: Color(0xFF8B4513),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 16),

//                                       // Book Info
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               book.title,
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Color(0xFF3E2723),
//                                                 height: 1.3,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Row(
//                                               children: [
//                                                 Icon(
//                                                   Icons.person_outline,
//                                                   size: 16,
//                                                   color: Color(0xFF8B4513),
//                                                 ),
//                                                 const SizedBox(width: 4),
//                                                 Expanded(
//                                                   child: Text(
//                                                     book.firstAuthorName,
//                                                     maxLines: 1,
//                                                     overflow: TextOverflow.ellipsis,
//                                                     style: TextStyle(
//                                                       fontSize: 13,
//                                                       color: Color(0xFF654321),
//                                                       fontStyle: FontStyle.italic,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Container(
//                                               padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8,
//                                                 vertical: 4,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 color: Color(0xFFD4AF37).withOpacity(0.2),
//                                                 borderRadius: BorderRadius.circular(6),
//                                                 border: Border.all(
//                                                   color: Color(0xFFD4AF37),
//                                                   width: 1,
//                                                 ),
//                                               ),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.download_rounded,
//                                                     size: 14,
//                                                     color: Color(0xFF8B4513),
//                                                   ),
//                                                   const SizedBox(width: 4),
//                                                   Text(
//                                                     '${book.downloadCount} downloads',
//                                                     style: TextStyle(
//                                                       fontSize: 11,
//                                                       fontWeight: FontWeight.w600,
//                                                       color: Color(0xFF8B4513),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),

//                                       // Favorite Button
//                                       Consumer<FavoriteProvider>(
//                                         builder: (context, favProvider, child) {
//                                           final bool isFavorited = favProvider.isFavorite(book.id);
                                          
//                                           return Container(
//                                             decoration: BoxDecoration(
//                                               color: isFavorited 
//                                                   ? Colors.red.withOpacity(0.1)
//                                                   : Color(0xFF8B4513).withOpacity(0.1),
//                                               borderRadius: BorderRadius.circular(10),
//                                             ),
//                                             child: IconButton(
//                                               icon: Icon(
//                                                 isFavorited ? Icons.favorite : Icons.favorite_border,
//                                                 color: isFavorited ? Colors.red.shade700 : Color(0xFF8B4513),
//                                                 size: 28,
//                                               ),
//                                               tooltip: isFavorited ? 'Hapus dari favorit' : 'Tambah ke favorit',
//                                               onPressed: () {
//                                                 favProvider.toggleFavorite(book);
//                                                 ScaffoldMessenger.of(context).showSnackBar(
//                                                   SnackBar(
//                                                     content: Row(
//                                                       children: [
//                                                         Icon(
//                                                           isFavorited ? Icons.favorite_border : Icons.favorite,
//                                                           color: Colors.white,
//                                                           size: 20,
//                                                         ),
//                                                         const SizedBox(width: 12),
//                                                         Expanded(
//                                                           child: Text(
//                                                             isFavorited 
//                                                                 ? 'Dihapus dari favorit' 
//                                                                 : 'Ditambahkan ke favorit',
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     backgroundColor: Color(0xFF8B4513),
//                                                     behavior: SnackBarBehavior.floating,
//                                                     shape: RoundedRectangleBorder(
//                                                       borderRadius: BorderRadius.circular(10),
//                                                     ),
//                                                     margin: const EdgeInsets.all(16),
//                                                     duration: const Duration(seconds: 2),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/favorite_provider.dart';
import '../detail_screen.dart';
import '../../widgets/book_search_delegate.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookProvider>(context, listen: false);
      if (provider.books.isEmpty) {
        provider.getBooks();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B4513),
              Color(0xFF654321),
              Color(0xFF3E2723),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFF5E6D3).withOpacity(0.95),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFD4AF37), width: 3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: Color(0xFF3E2723),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PERPUSTAKAAN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF8B4513),
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'Novel Klasik',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF8B4513).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search_rounded, color: Color(0xFF8B4513)),
                        tooltip: 'Cari Buku',
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: BookSearchDelegate(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<BookProvider>(
                  builder: (context, bookProvider, child) {
                    final state = bookProvider.bookListState;

                    if (state == BookState.loading || state == BookState.initial) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Memuat koleksi buku...',
                              style: TextStyle(
                                color: Color(0xFFF5E6D3),
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state == BookState.error) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, color: Color(0xFFD4AF37), size: 60),
                            const SizedBox(height: 16),
                            Text(
                              'Gagal memuat koleksi buku',
                              style: TextStyle(
                                color: Color(0xFFF5E6D3),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Silakan coba lagi nanti',
                              style: TextStyle(
                                color: Color(0xFFF5E6D3).withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state == BookState.loaded && bookProvider.books.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.book_outlined, color: Color(0xFFD4AF37), size: 60),
                            const SizedBox(height: 16),
                            Text(
                              'Tidak ada buku yang ditemukan',
                              style: TextStyle(
                                color: Color(0xFFF5E6D3),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: bookProvider.books.length,
                        itemBuilder: (context, index) {
                          final book = bookProvider.books[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5E6D3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Color(0xFFD4AF37),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(bookId: book.id),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Color(0xFF8B4513),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 6,
                                              offset: Offset(2, 3),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            book.formats.imageJpeg,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Color(0xFF8B4513).withOpacity(0.2),
                                                child: Icon(
                                                  Icons.menu_book,
                                                  size: 40,
                                                  color: Color(0xFF8B4513),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              book.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF3E2723),
                                                height: 1.3,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person_outline,
                                                  size: 16,
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
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFD4AF37).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: Color(0xFFD4AF37),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.download_rounded,
                                                    size: 14,
                                                    color: Color(0xFF8B4513),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${book.downloadCount} downloads',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF8B4513),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Consumer<FavoriteProvider>(
                                        builder: (context, favProvider, child) {
                                          final bool isFavorited = favProvider.isFavorite(book.id);
                                          
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: isFavorited 
                                                  ? Colors.red.withOpacity(0.1)
                                                  : Color(0xFF8B4513).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                isFavorited ? Icons.favorite : Icons.favorite_border,
                                                color: isFavorited ? Colors.red.shade700 : Color(0xFF8B4513),
                                                size: 28,
                                              ),
                                              tooltip: isFavorited ? 'Hapus dari favorit' : 'Tambah ke favorit',
                                              onPressed: () {
                                                favProvider.toggleFavorite(book);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Row(
                                                      children: [
                                                        Icon(
                                                          isFavorited ? Icons.favorite_border : Icons.favorite,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            isFavorited 
                                                                ? 'Dihapus dari favorit' 
                                                                : 'Ditambahkan ke favorit',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor: Color(0xFF8B4513),
                                                    behavior: SnackBarBehavior.floating,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    margin: const EdgeInsets.all(16),
                                                    duration: const Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}