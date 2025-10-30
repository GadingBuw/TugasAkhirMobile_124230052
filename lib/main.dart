// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // 1. Import hive_flutter
import 'package:path_provider/path_provider.dart'; // 2. Import path_provider
import 'package:provider/provider.dart';
import 'models/favorite_book.dart'; // 3. Import model favorit
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/favorite_provider.dart'; // 4. Import provider favorit (akan kita buat)
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

// 5. Ubah main menjadi async
Future<void> main() async {
  // 6. Pastikan Flutter terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // 7. Dapatkan direktori dan inisialisasi Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  // 8. Daftarkan Adapter
  Hive.registerAdapter(FavoriteBookAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => BookProvider()),
        // 9. Tambahkan FavoriteProvider
        ChangeNotifierProvider(create: (ctx) => FavoriteProvider()),
      ],
      child: MaterialApp(
        title: 'Perpustakaan Novel',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            switch (auth.authState) {
              case AuthState.authenticated:
                return const HomeScreen();
              case AuthState.unauthenticated:
                return const LoginScreen();
              case AuthState.unknown:
                return const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}

