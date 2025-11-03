// // lib/screens/login_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   // --- TAMBAHAN ---
//   final _confirmPasswordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isPasswordVisible = false;
//   // --- TAMBAHAN ---
//   bool _isLoginMode = true;

//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     // --- TAMBAHAN ---
//     _confirmPasswordController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final bool success = await authProvider.login(
//       _usernameController.text,
//       _passwordController.text,
//     );

//     if (mounted && !success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.error_outline, color: Colors.white),
//               SizedBox(width: 12),
//               Expanded(child: Text('Username atau Password salah!')),
//             ],
//           ),
//           backgroundColor: Colors.red.shade700,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//     }
//   }

//   // --- FUNGSI BARU ---
//   Future<void> _handleRegister() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     // Validasi password konfirmasi
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.error_outline, color: Colors.white),
//               SizedBox(width: 12),
//               Expanded(child: Text('Password dan konfirmasi tidak cocok!')),
//             ],
//           ),
//           backgroundColor: Colors.orange.shade700,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//       return;
//     }

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final bool success = await authProvider.register(
//       _usernameController.text,
//       _passwordController.text,
//     );

//     if (mounted && !success) {
//       // Ini berarti username sudah digunakan
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.error_outline, color: Colors.white),
//               SizedBox(width: 12),
//               Expanded(child: Text('Username tersebut sudah digunakan!')),
//             ],
//           ),
//           backgroundColor: Colors.red.shade700,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//     }
//     // Jika sukses, AuthProvider akan otomatis memindahkan state
//   }
//   // --- BATAS FUNGSI BARU ---

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
//               Color(0xFF8B4513), // Saddle brown - warna kayu tua
//               Color(0xFF654321), // Dark brown
//               Color(0xFF3E2723), // Very dark brown
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: AnimatedBuilder(
//                 animation: _animationController,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, _slideAnimation.value),
//                     child: Opacity(
//                       opacity: _fadeAnimation.value,
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Decorative bookshelf illustration
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         // Background circle with book texture
//                         Container(
//                           width: 160,
//                           height: 160,
//                           decoration: BoxDecoration(
//                             color: Color(0xFFF5E6D3), // Parchment color
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 blurRadius: 30,
//                                 spreadRadius: 5,
//                               ),
//                             ],
//                             border: Border.all(
//                               color: Color(0xFFD4AF37), // Gold border
//                               width: 3,
//                             ),
//                           ),
//                         ),
//                         // Multiple books icon
//                         Column(
//                           children: [
//                             Icon(
//                               Icons.menu_book_rounded,
//                               size: 70,
//                               color: Color(0xFF8B4513),
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFD4AF37),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Text(
//                                 'LIBRARY',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF3E2723),
//                                   letterSpacing: 2,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),

//                     // Title with elegant typography
//                     Text(
//                       'PERPUSTAKAAN',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w300,
//                         color: Color(0xFFD4AF37),
//                         letterSpacing: 4,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Novel Klasik',
//                       style: TextStyle(
//                         fontSize: 36,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFFF5E6D3),
//                         letterSpacing: 1.5,
//                         shadows: [
//                           Shadow(
//                             color: Colors.black.withOpacity(0.5),
//                             offset: Offset(2, 2),
//                             blurRadius: 4,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 6),
//                       decoration: BoxDecoration(
//                         border: Border(
//                           top: BorderSide(color: Color(0xFFD4AF37), width: 1),
//                           bottom: BorderSide(color: Color(0xFFD4AF37), width: 1),
//                         ),
//                       ),
//                       child: Text(
//                         'Gerbang Menuju Dunia Literasi',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFFF5E6D3).withOpacity(0.9),
//                           fontStyle: FontStyle.italic,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 40),

//                     // Login Form Card - Wood texture style
//                     Container(
//                       padding: const EdgeInsets.all(28),
//                       decoration: BoxDecoration(
//                         color: Color(0xFFF5E6D3), // Parchment/old paper color
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.4),
//                             blurRadius: 30,
//                             offset: const Offset(0, 15),
//                           ),
//                         ],
//                         border: Border.all(
//                           color: Color(0xFFD4AF37),
//                           width: 2,
//                         ),
//                       ),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             // Header
//                             Row(
//                               children: [
//                                 // --- PERUBAHAN ---
//                                 Icon(
//                                     _isLoginMode
//                                         ? Icons.auto_stories
//                                         : Icons.person_add_alt_1,
//                                     color: Color(0xFF8B4513),
//                                     size: 24),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   // --- PERUBAHAN ---
//                                   _isLoginMode
//                                       ? 'Portal Masuk Anggota'
//                                       : 'Daftar Akun Baru',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF3E2723),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 24),

//                             // Username Field
//                             TextFormField(
//                               controller: _usernameController,
//                               style: TextStyle(
//                                   fontSize: 16, color: Color(0xFF3E2723)),
//                               decoration: InputDecoration(
//                                 labelText: 'Nama Pengguna',
//                                 labelStyle: TextStyle(color: Color(0xFF8B4513)),
//                                 hintText: 'Masukkan username',
//                                 hintStyle: TextStyle(
//                                     color: Color(0xFF8B4513).withOpacity(0.5)),
//                                 prefixIcon: Icon(
//                                   Icons.person_outline_rounded,
//                                   color: Color(0xFF8B4513),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Color(0xFFD4AF37), width: 2),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Color(0xFF8B4513).withOpacity(0.5),
//                                       width: 2),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     color: Color(0xFF8B4513),
//                                     width: 2.5,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.white.withOpacity(0.7),
//                               ),
//                               validator: (value) =>
//                                   value!.isEmpty ? 'Username tidak boleh kosong' : null,
//                             ),
//                             const SizedBox(height: 18),

//                             // Password Field
//                             TextFormField(
//                               controller: _passwordController,
//                               obscureText: !_isPasswordVisible,
//                               style: TextStyle(
//                                   fontSize: 16, color: Color(0xFF3E2723)),
//                               decoration: InputDecoration(
//                                 labelText: 'Kata Sandi',
//                                 labelStyle: TextStyle(color: Color(0xFF8B4513)),
//                                 hintText: 'Masukkan password',
//                                 hintStyle: TextStyle(
//                                     color: Color(0xFF8B4513).withOpacity(0.5)),
//                                 prefixIcon: Icon(
//                                   Icons.lock_outline_rounded,
//                                   color: Color(0xFF8B4513),
//                                 ),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _isPasswordVisible
//                                         ? Icons.visibility_rounded
//                                         : Icons.visibility_off_rounded,
//                                     color: Color(0xFF8B4513).withOpacity(0.7),
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       _isPasswordVisible = !_isPasswordVisible;
//                                     });
//                                   },
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Color(0xFFD4AF37), width: 2),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Color(0xFF8B4513).withOpacity(0.5),
//                                       width: 2),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     color: Color(0xFF8B4513),
//                                     width: 2.5,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.white.withOpacity(0.7),
//                               ),
//                               validator: (value) =>
//                                   value!.isEmpty ? 'Password tidak boleh kosong' : null,
//                             ),

//                             // --- BLOK BARU (MENGGANTIKAN SIZEDBOX(28)) ---
//                             AnimatedSize(
//                               duration: const Duration(milliseconds: 300),
//                               curve: Curves.easeInOut,
//                               child: Visibility(
//                                 visible: !_isLoginMode,
//                                 child: Column(
//                                   children: [
//                                     const SizedBox(height: 18),
//                                     TextFormField(
//                                       controller: _confirmPasswordController,
//                                       obscureText: !_isPasswordVisible,
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           color: Color(0xFF3E2723)),
//                                       decoration: InputDecoration(
//                                         labelText: 'Konfirmasi Kata Sandi',
//                                         labelStyle:
//                                             TextStyle(color: Color(0xFF8B4513)),
//                                         hintText: 'Ulangi password',
//                                         hintStyle: TextStyle(
//                                             color: Color(0xFF8B4513)
//                                                 .withOpacity(0.5)),
//                                         prefixIcon: Icon(
//                                           Icons.lock_outline_rounded,
//                                           color: Color(0xFF8B4513),
//                                         ),
//                                         border: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           borderSide: BorderSide(
//                                               color: Color(0xFFD4AF37),
//                                               width: 2),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           borderSide: BorderSide(
//                                               color: Color(0xFF8B4513)
//                                                   .withOpacity(0.5),
//                                               width: 2),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           borderSide: BorderSide(
//                                             color: Color(0xFF8B4513),
//                                             width: 2.5,
//                                           ),
//                                         ),
//                                         filled: true,
//                                         fillColor:
//                                             Colors.white.withOpacity(0.7),
//                                       ),
//                                       validator: (value) {
//                                         if (_isLoginMode) return null;
//                                         if (value == null || value.isEmpty) {
//                                           return 'Konfirmasi tidak boleh kosong';
//                                         }
//                                         if (value != _passwordController.text) {
//                                           return 'Password tidak cocok';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             // --- BATAS BLOK BARU ---

//                             const SizedBox(height: 28),

//                             // Login Button
//                             Consumer<AuthProvider>(
//                               builder: (context, auth, child) {
//                                 if (auth.isLoading) {
//                                   return Container(
//                                     height: 56,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           Color(0xFF8B4513),
//                                           Color(0xFF654321),
//                                         ],
//                                       ),
//                                       borderRadius: BorderRadius.circular(12),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Color(0xFF8B4513)
//                                               .withOpacity(0.5),
//                                           blurRadius: 12,
//                                           offset: const Offset(0, 6),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 Color(0xFFF5E6D3)),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                                 return Container(
//                                   height: 56,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Color(0xFF8B4513),
//                                         Color(0xFF654321),
//                                       ],
//                                     ),
//                                     borderRadius: BorderRadius.circular(12),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color:
//                                             Color(0xFF8B4513).withOpacity(0.5),
//                                         blurRadius: 12,
//                                         offset: const Offset(0, 6),
//                                       ),
//                                     ],
//                                   ),
//                                   child: ElevatedButton(
//                                     // --- PERUBAHAN ---
//                                     onPressed: _isLoginMode
//                                         ? _handleLogin
//                                         : _handleRegister,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.transparent,
//                                       shadowColor: Colors.transparent,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         // --- PERUBAHAN ---
//                                         Icon(
//                                             _isLoginMode
//                                                 ? Icons.login_rounded
//                                                 : Icons.person_add,
//                                             color: Color(0xFFF5E6D3)),
//                                         const SizedBox(width: 8),
//                                         Text(
//                                           // --- PERUBAHAN ---
//                                           _isLoginMode
//                                               ? 'MASUK PERPUSTAKAAN'
//                                               : 'DAFTAR & MASUK',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             letterSpacing: 1,
//                                             color: Color(0xFFF5E6D3),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // --- BLOK BARU ---
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           _isLoginMode
//                               ? 'Belum punya akun?'
//                               : 'Sudah punya akun?',
//                           style: TextStyle(
//                               color: Color(0xFFF5E6D3).withOpacity(0.7)),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             setState(() {
//                               _isLoginMode = !_isLoginMode;
//                             });
//                           },
//                           child: Text(
//                             _isLoginMode ? 'Daftar di sini' : 'Login di sini',
//                             style: TextStyle(
//                               color: Color(0xFFD4AF37),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // --- BATAS BLOK BARU ---

//                     // Footer quote
//                     Text(
//                       '"Membaca adalah jendela dunia"',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Color(0xFFF5E6D3).withOpacity(0.7),
//                         fontSize: 12,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoginMode = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool success = await authProvider.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Username atau Password salah!')),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Password dan konfirmasi tidak cocok!')),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool success = await authProvider.register(
      _usernameController.text,
      _passwordController.text,
    );

    if (mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Username tersebut sudah digunakan!')),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5E6D3),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                            border: Border.all(
                              color: Color(0xFFD4AF37),
                              width: 3,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              size: 70,
                              color: Color(0xFF8B4513),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFD4AF37),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'LIBRARY',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'PERPUSTAKAAN',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFFD4AF37),
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Novel Klasik',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5E6D3),
                        letterSpacing: 1.5,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFFD4AF37), width: 1),
                          bottom: BorderSide(color: Color(0xFFD4AF37), width: 1),
                        ),
                      ),
                      child: Text(
                        'Gerbang Menuju Dunia Literasi',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFF5E6D3).withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5E6D3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFFD4AF37),
                          width: 2,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Icon(
                                    _isLoginMode
                                        ? Icons.auto_stories
                                        : Icons.person_add_alt_1,
                                    color: Color(0xFF8B4513),
                                    size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  _isLoginMode
                                      ? 'Portal Masuk Anggota'
                                      : 'Daftar Akun Baru',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E2723),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _usernameController,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF3E2723)),
                              decoration: InputDecoration(
                                labelText: 'Nama Pengguna',
                                labelStyle: TextStyle(color: Color(0xFF8B4513)),
                                hintText: 'Masukkan username',
                                hintStyle: TextStyle(
                                    color: Color(0xFF8B4513).withOpacity(0.5)),
                                prefixIcon: Icon(
                                  Icons.person_outline_rounded,
                                  color: Color(0xFF8B4513),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color(0xFFD4AF37), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8B4513).withOpacity(0.5),
                                      width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF8B4513),
                                    width: 2.5,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.7),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Username tidak boleh kosong' : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF3E2723)),
                              decoration: InputDecoration(
                                labelText: 'Kata Sandi',
                                labelStyle: TextStyle(color: Color(0xFF8B4513)),
                                hintText: 'Masukkan password',
                                hintStyle: TextStyle(
                                    color: Color(0xFF8B4513).withOpacity(0.5)),
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFF8B4513),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: Color(0xFF8B4513).withOpacity(0.7),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color(0xFFD4AF37), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8B4513).withOpacity(0.5),
                                      width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF8B4513),
                                    width: 2.5,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.7),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Password tidak boleh kosong' : null,
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Visibility(
                                visible: !_isLoginMode,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 18),
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      obscureText: !_isPasswordVisible,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF3E2723)),
                                      decoration: InputDecoration(
                                        labelText: 'Konfirmasi Kata Sandi',
                                        labelStyle:
                                            TextStyle(color: Color(0xFF8B4513)),
                                        hintText: 'Ulangi password',
                                        hintStyle: TextStyle(
                                            color: Color(0xFF8B4513)
                                                .withOpacity(0.5)),
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: Color(0xFF8B4513),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Color(0xFFD4AF37),
                                              width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Color(0xFF8B4513)
                                                  .withOpacity(0.5),
                                              width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Color(0xFF8B4513),
                                            width: 2.5,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor:
                                            Colors.white.withOpacity(0.7),
                                      ),
                                      validator: (value) {
                                        if (_isLoginMode) return null;
                                        if (value == null || value.isEmpty) {
                                          return 'Konfirmasi tidak boleh kosong';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Password tidak cocok';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Consumer<AuthProvider>(
                              builder: (context, auth, child) {
                                if (auth.isLoading) {
                                  return Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF8B4513),
                                          Color(0xFF654321),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF8B4513)
                                              .withOpacity(0.5),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFFF5E6D3)),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF8B4513),
                                        Color(0xFF654321),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF8B4513).withOpacity(0.5),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoginMode
                                        ? _handleLogin
                                        : _handleRegister,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                            _isLoginMode
                                                ? Icons.login_rounded
                                                : Icons.person_add,
                                            color: Color(0xFFF5E6D3)),
                                        const SizedBox(width: 8),
                                        Text(
                                          _isLoginMode
                                              ? 'MASUK PERPUSTAKAAN'
                                              : 'DAFTAR & MASUK',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            color: Color(0xFFF5E6D3),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLoginMode
                              ? 'Belum punya akun?'
                              : 'Sudah punya akun?',
                          style: TextStyle(
                              color: Color(0xFFF5E6D3).withOpacity(0.7)),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoginMode = !_isLoginMode;
                            });
                          },
                          child: Text(
                            _isLoginMode ? 'Daftar di sini' : 'Login di sini',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '"Membaca adalah jendela dunia"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF5E6D3).withOpacity(0.7),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}