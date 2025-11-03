// lib/models/user_model.dart

import 'package:hive/hive.dart';

part 'user_model.g.dart'; // File ini akan kita generate nanti

// Pastikan typeId unik. Jika FavoriteBook adalah 0, ini 1.
@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String passwordHash;

  User({
    required this.username,
    required this.passwordHash,
  });
}