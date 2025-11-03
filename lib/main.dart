import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'models/favorite_book.dart';
import 'models/user_model.dart';
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/favorite_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  Hive.registerAdapter(FavoriteBookAdapter());
  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<User>('users');


  await NotificationService().initialize();

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

        ChangeNotifierProxyProvider<AuthProvider, FavoriteProvider>(
          create: (context) => FavoriteProvider(),

          update: (context, auth, previousFavoriteProvider) {
            
            if (previousFavoriteProvider == null) return FavoriteProvider();

            if (auth.activeUsername != previousFavoriteProvider.currentUsername) {
              previousFavoriteProvider.updateUser(auth.activeUsername);
            }
            return previousFavoriteProvider;
          },
        ),
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