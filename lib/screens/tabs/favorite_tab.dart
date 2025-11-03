// // lib/screens/tabs/favorites_tab.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/favorite_provider.dart';
// import '../detail_screen.dart';

// class FavoritesTab extends StatefulWidget {
//   const FavoritesTab({super.key});

//   @override
//   State<FavoritesTab> createState() => _FavoritesTabState();
// }

// class _FavoritesTabState extends State<FavoritesTab> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<FavoriteProvider>();

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
//                         Icons.favorite_rounded,
//                         color: Colors.red.shade700,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'KOLEKSI FAVORIT',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w300,
//                               color: Color(0xFF8B4513),
//                               letterSpacing: 2,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 'Buku Kesukaan',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF3E2723),
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               if (provider.favorites.isNotEmpty)
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                                   decoration: BoxDecoration(
//                                     color: Colors.red.shade700,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Text(
//                                     '${provider.favorites.length}',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Body - Daftar Favorit atau Empty State
//               Expanded(
//                 child: provider.favorites.isEmpty
//                     ? _buildEmptyState()
//                     : _buildFavoritesList(provider),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Empty State - Ketika belum ada favorit
//   Widget _buildEmptyState() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Decorative empty illustration
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 160,
//                   height: 160,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5E6D3).withOpacity(0.3),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Color(0xFFD4AF37).withOpacity(0.5),
//                       width: 3,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5E6D3).withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.favorite_border_rounded,
//                     size: 70,
//                     color: Color(0xFFD4AF37),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
            
//             Text(
//               'Belum Ada Buku Favorit',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFFF5E6D3),
//                 letterSpacing: 0.5,
//               ),
//             ),
//             const SizedBox(height: 12),
            
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 40),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Color(0xFFF5E6D3).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: Color(0xFFD4AF37).withOpacity(0.3),
//                   width: 1,
//                 ),
//               ),
//               child: Text(
//                 'Mulailah menambahkan buku favorit Anda dengan menekan tombol ❤️ pada buku yang Anda suka',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFFF5E6D3).withOpacity(0.8),
//                   height: 1.5,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   // List Favorit
//   Widget _buildFavoritesList(FavoriteProvider provider) {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: provider.favorites.length,
//         itemBuilder: (context, index) {
//           final favoriteBook = provider.favorites[index];
          
//           return TweenAnimationBuilder<double>(
//             duration: Duration(milliseconds: 300 + (index * 50)),
//             tween: Tween(begin: 0.0, end: 1.0),
//             builder: (context, value, child) {
//               return Transform.translate(
//                 offset: Offset(0, 20 * (1 - value)),
//                 child: Opacity(
//                   opacity: value,
//                   child: child,
//                 ),
//               );
//             },
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Color(0xFFF5E6D3),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: Color(0xFFD4AF37),
//                   width: 2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(16),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DetailScreen(bookId: favoriteBook.id),
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Book Cover with heart badge
//                         Stack(
//                           children: [
//                             Container(
//                               width: 80,
//                               height: 120,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: Color(0xFF8B4513),
//                                   width: 2,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.2),
//                                     blurRadius: 6,
//                                     offset: Offset(2, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.network(
//                                   favoriteBook.imageUrl,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Container(
//                                       color: Color(0xFF8B4513).withOpacity(0.2),
//                                       child: Icon(
//                                         Icons.menu_book,
//                                         size: 40,
//                                         color: Color(0xFF8B4513),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                             // Heart badge
//                             Positioned(
//                               top: -4,
//                               right: -4,
//                               child: Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.shade700,
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Color(0xFFF5E6D3),
//                                     width: 2,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.3),
//                                       blurRadius: 4,
//                                       offset: Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Icon(
//                                   Icons.favorite,
//                                   color: Colors.white,
//                                   size: 16,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 16),

//                         // Book Info
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 favoriteBook.title,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF3E2723),
//                                   height: 1.3,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.person_outline,
//                                     size: 16,
//                                     color: Color(0xFF8B4513),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Expanded(
//                                     child: Text(
//                                       favoriteBook.author,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Color(0xFF654321),
//                                         fontStyle: FontStyle.italic,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 12),
                              
//                               // Action buttons row
//                               Row(
//                                 children: [
//                                   // Lihat Detail button
//                                   Expanded(
//                                     child: Container(
//                                       height: 36,
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Color(0xFF8B4513),
//                                             Color(0xFF654321),
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.circular(8),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Color(0xFF8B4513).withOpacity(0.3),
//                                             blurRadius: 6,
//                                             offset: Offset(0, 3),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Material(
//                                         color: Colors.transparent,
//                                         child: InkWell(
//                                           borderRadius: BorderRadius.circular(8),
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => DetailScreen(bookId: favoriteBook.id),
//                                               ),
//                                             );
//                                           },
//                                           child: Center(
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 Icon(
//                                                   Icons.visibility_rounded,
//                                                   size: 16,
//                                                   color: Color(0xFFF5E6D3),
//                                                 ),
//                                                 const SizedBox(width: 6),
//                                                 Text(
//                                                   'Lihat Detail',
//                                                   style: TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Color(0xFFF5E6D3),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
                                  
//                                   // Remove button
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.red.shade50,
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         color: Colors.red.shade700,
//                                         width: 1.5,
//                                       ),
//                                     ),
//                                     child: IconButton(
//                                       icon: Icon(
//                                         Icons.favorite,
//                                         color: Colors.red.shade700,
//                                         size: 20,
//                                       ),
//                                       tooltip: 'Hapus dari Favorit',
//                                       padding: EdgeInsets.zero,
//                                       constraints: BoxConstraints(
//                                         minWidth: 36,
//                                         minHeight: 36,
//                                       ),
//                                       onPressed: () {
//                                         // Show confirmation dialog
//                                         showDialog(
//                                           context: context,
//                                           builder: (BuildContext dialogContext) {
//                                             return AlertDialog(
//                                               backgroundColor: Color(0xFFF5E6D3),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(20),
//                                                 side: BorderSide(
//                                                   color: Color(0xFFD4AF37),
//                                                   width: 2,
//                                                 ),
//                                               ),
//                                               title: Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.favorite_border,
//                                                     color: Colors.red.shade700,
//                                                   ),
//                                                   const SizedBox(width: 8),
//                                                   Text(
//                                                     'Hapus Favorit?',
//                                                     style: TextStyle(
//                                                       color: Color(0xFF3E2723),
//                                                       fontWeight: FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               content: Text(
//                                                 'Apakah Anda yakin ingin menghapus "${favoriteBook.title}" dari daftar favorit?',
//                                                 style: TextStyle(
//                                                   color: Color(0xFF654321),
//                                                 ),
//                                               ),
//                                               actions: [
//                                                 TextButton(
//                                                   onPressed: () {
//                                                     Navigator.of(dialogContext).pop();
//                                                   },
//                                                   child: Text(
//                                                     'Batal',
//                                                     style: TextStyle(
//                                                       color: Color(0xFF8B4513),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 ElevatedButton(
//                                                   onPressed: () {
//                                                     context.read<FavoriteProvider>().removeFavorite(favoriteBook.id);
//                                                     Navigator.of(dialogContext).pop();
                                                    
//                                                     ScaffoldMessenger.of(context).showSnackBar(
//                                                       SnackBar(
//                                                         content: Row(
//                                                           children: [
//                                                             Icon(
//                                                               Icons.check_circle,
//                                                               color: Colors.white,
//                                                               size: 20,
//                                                             ),
//                                                             const SizedBox(width: 12),
//                                                             Expanded(
//                                                               child: Text('Dihapus dari favorit'),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         backgroundColor: Colors.red.shade700,
//                                                         behavior: SnackBarBehavior.floating,
//                                                         shape: RoundedRectangleBorder(
//                                                           borderRadius: BorderRadius.circular(10),
//                                                         ),
//                                                         margin: const EdgeInsets.all(16),
//                                                         duration: const Duration(seconds: 2),
//                                                       ),
//                                                     );
//                                                   },
//                                                   style: ElevatedButton.styleFrom(
//                                                     backgroundColor: Colors.red.shade700,
//                                                     shape: RoundedRectangleBorder(
//                                                       borderRadius: BorderRadius.circular(10),
//                                                     ),
//                                                   ),
//                                                   child: Text(
//                                                     'Hapus',
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_provider.dart';
import '../detail_screen.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();

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
                        Icons.favorite_rounded,
                        color: Colors.red.shade700,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KOLEKSI FAVORIT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF8B4513),
                              letterSpacing: 2,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Buku Kesukaan',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (provider.favorites.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade700,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${provider.favorites.length}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: provider.favorites.isEmpty
                    ? _buildEmptyState()
                    : _buildFavoritesList(provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5E6D3).withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFD4AF37).withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5E6D3).withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 70,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            Text(
              'Belum Ada Buku Favorit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF5E6D3),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF5E6D3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFD4AF37).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Mulailah menambahkan buku favorit Anda dengan menekan tombol ❤️ pada buku yang Anda suka',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFF5E6D3).withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(FavoriteProvider provider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.favorites.length,
        itemBuilder: (context, index) {
          final favoriteBook = provider.favorites[index];
          
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 50)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
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
                        builder: (context) => DetailScreen(bookId: favoriteBook.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
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
                                  favoriteBook.imageUrl,
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
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade700,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFFF5E6D3),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favoriteBook.title,
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
                                      favoriteBook.author,
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
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF8B4513),
                                            Color(0xFF654321),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF8B4513).withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(8),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DetailScreen(bookId: favoriteBook.id),
                                              ),
                                            );
                                          },
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.visibility_rounded,
                                                  size: 16,
                                                  color: Color(0xFFF5E6D3),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Lihat Detail',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFF5E6D3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.red.shade700,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: Colors.red.shade700,
                                        size: 20,
                                      ),
                                      tooltip: 'Hapus dari Favorit',
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 36,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext dialogContext) {
                                            return AlertDialog(
                                              backgroundColor: Color(0xFFF5E6D3),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                                side: BorderSide(
                                                  color: Color(0xFFD4AF37),
                                                  width: 2,
                                                ),
                                              ),
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.red.shade700,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Hapus Favorit?',
                                                    style: TextStyle(
                                                      color: Color(0xFF3E2723),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: Text(
                                                'Apakah Anda yakin ingin menghapus "${favoriteBook.title}" dari daftar favorit?',
                                                style: TextStyle(
                                                  color: Color(0xFF654321),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(dialogContext).pop();
                                                  },
                                                  child: Text(
                                                    'Batal',
                                                    style: TextStyle(
                                                      color: Color(0xFF8B4513),
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context.read<FavoriteProvider>().removeFavorite(favoriteBook.id);
                                                    Navigator.of(dialogContext).pop();
                                                    
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.check_circle,
                                                              color: Colors.white,
                                                              size: 20,
                                                            ),
                                                            const SizedBox(width: 12),
                                                            Expanded(
                                                              child: Text('Dihapus dari favorit'),
                                                            ),
                                                          ],
                                                        ),
                                                        backgroundColor: Colors.red.shade700,
                                                        behavior: SnackBarBehavior.floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        margin: const EdgeInsets.all(16),
                                                        duration: const Duration(seconds: 2),
                                                      ),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red.shade700,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Hapus',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}