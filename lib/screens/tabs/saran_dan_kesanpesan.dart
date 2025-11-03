// import 'package:flutter/material.dart';

// class SaranDanKesanPesanTab extends StatefulWidget {
//   const SaranDanKesanPesanTab({super.key});

//   @override
//   State<SaranDanKesanPesanTab> createState() => _SaranDanKesanPesanTabState();
// }

// class _SaranDanKesanPesanTabState extends State<SaranDanKesanPesanTab>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
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
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: AnimatedBuilder(
//               animation: _animationController,
//               builder: (context, child) {
//                 return Transform.translate(
//                   offset: Offset(0, _slideAnimation.value),
//                   child: Opacity(
//                     opacity: _fadeAnimation.value,
//                     child: child,
//                   ),
//                 );
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const SizedBox(height: 20),
                  
//                   // Header dengan Icon
//                   Center(
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Container(
//                           width: 120,
//                           height: 120,
//                           decoration: BoxDecoration(
//                             color: Color(0xFFF5E6D3),
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 blurRadius: 20,
//                                 spreadRadius: 3,
//                               ),
//                             ],
//                             border: Border.all(
//                               color: Color(0xFFD4AF37),
//                               width: 3,
//                             ),
//                           ),
//                         ),
//                         Icon(
//                           Icons.rate_review_rounded,
//                           size: 60,
//                           color: Color(0xFF8B4513),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
                  
//                   // Title
//                   Text(
//                     'SARAN & KESAN',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFFF5E6D3),
//                       letterSpacing: 2,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black.withOpacity(0.5),
//                           offset: Offset(2, 2),
//                           blurRadius: 4,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
                  
//                   // Subtitle
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//                     child: Text(
//                       'Pesan untuk Matakuliah',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFFF5E6D3).withOpacity(0.8),
//                         fontStyle: FontStyle.italic,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
                  
//                   // Card Saran
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFF5E6D3),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.4),
//                           blurRadius: 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                       border: Border.all(
//                         color: Color(0xFFD4AF37),
//                         width: 2,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFD4AF37),
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Color(0xFF8B4513).withOpacity(0.3),
//                                     blurRadius: 8,
//                                     offset: Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Icon(
//                                 Icons.lightbulb_rounded,
//                                 color: Color(0xFF3E2723),
//                                 size: 32,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Text(
//                                 'Saran',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF3E2723),
//                                   letterSpacing: 1,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
                        
//                         // Decorative divider
//                         Container(
//                           height: 2,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color(0xFFD4AF37),
//                                 Color(0xFF8B4513).withOpacity(0.3),
//                                 Color(0xFFD4AF37),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
                        
//                         // Saran Content dengan quote styling
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: Color(0xFF8B4513).withOpacity(0.3),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '"',
//                                 style: TextStyle(
//                                   fontSize: 48,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF8B4513).withOpacity(0.3),
//                                   height: 0.8,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   'Deadline tolong diperpanjang',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Color(0xFF3E2723),
//                                     height: 1.6,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 '"',
//                                 style: TextStyle(
//                                   fontSize: 48,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF8B4513).withOpacity(0.3),
//                                   height: 0.8,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
                  
//                   // Card Kesan Pesan
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFF5E6D3),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.4),
//                           blurRadius: 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                       border: Border.all(
//                         color: Color(0xFFD4AF37),
//                         width: 2,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFD4AF37),
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Color(0xFF8B4513).withOpacity(0.3),
//                                     blurRadius: 8,
//                                     offset: Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Icon(
//                                 Icons.favorite_rounded,
//                                 color: Color(0xFF3E2723),
//                                 size: 32,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Text(
//                                 'Kesan Pesan',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF3E2723),
//                                   letterSpacing: 1,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
                        
//                         // Decorative divider
//                         Container(
//                           height: 2,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color(0xFFD4AF37),
//                                 Color(0xFF8B4513).withOpacity(0.3),
//                                 Color(0xFFD4AF37),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
                        
//                         // Kesan Pesan Content dengan quote styling
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: Color(0xFF8B4513).withOpacity(0.3),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '"',
//                                 style: TextStyle(
//                                   fontSize: 48,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF8B4513).withOpacity(0.3),
//                                   height: 0.8,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   'Matkul Keren',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Color(0xFF3E2723),
//                                     height: 1.6,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 '"',
//                                 style: TextStyle(
//                                   fontSize: 48,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF8B4513).withOpacity(0.3),
//                                   height: 0.8,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';

class SaranDanKesanPesanTab extends StatefulWidget {
  const SaranDanKesanPesanTab({super.key});

  @override
  State<SaranDanKesanPesanTab> createState() => _SaranDanKesanPesanTabState();
}

class _SaranDanKesanPesanTabState extends State<SaranDanKesanPesanTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5E6D3),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ],
                            border: Border.all(
                              color: Color(0xFFD4AF37),
                              width: 3,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.rate_review_rounded,
                          size: 60,
                          color: Color(0xFF8B4513),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Text(
                    'SARAN & KESAN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5E6D3),
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                      'Pesan untuk Matakuliah',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFF5E6D3).withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5E6D3),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xFFD4AF37),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFD4AF37),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF8B4513).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.lightbulb_rounded,
                                color: Color(0xFF3E2723),
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Saran',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFD4AF37),
                                Color(0xFF8B4513).withOpacity(0.3),
                                Color(0xFFD4AF37),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF8B4513).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '"',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B4513).withOpacity(0.3),
                                  height: 0.8,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ketentuan Fitur tolong dipermudah pak :)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3E2723),
                                    height: 1.6,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '"',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B4513).withOpacity(0.3),
                                  height: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5E6D3),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xFFD4AF37),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFD4AF37),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF8B4513).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite_rounded,
                                color: Color(0xFF3E2723),
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Kesan Pesan',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFD4AF37),
                                Color(0xFF8B4513).withOpacity(0.3),
                                Color(0xFFD4AF37),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF8B4513).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '"',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B4513).withOpacity(0.3),
                                  height: 0.8,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Matkul Keren',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3E2723),
                                    height: 1.6,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '"',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B4513).withOpacity(0.3),
                                  height: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}