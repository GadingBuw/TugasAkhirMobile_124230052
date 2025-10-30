// import 'dart:ui';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   bool _isInitialized = false;

//   // Inisialisasi notifikasi
//   Future<void> initialize() async {
//     if (_isInitialized) return;

//     // Inisialisasi timezone
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

//     // Android initialization settings
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // iOS initialization settings
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _notifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onNotificationTapped,
//     );

//     _isInitialized = true;
//   }

//   // Request permission untuk notifikasi
//   Future<bool> requestPermission() async {
//     if (await Permission.notification.isGranted) {
//       return true;
//     }

//     final status = await Permission.notification.request();
//     return status.isGranted;
//   }

//   // Callback ketika notifikasi di-tap
//   void _onNotificationTapped(NotificationResponse response) {
//     // Handle notifikasi yang di-tap
//     print('Notifikasi di-tap: ${response.payload}');
//   }

//   // Kirim notifikasi segera (untuk pengingat hari ini)
//   Future<void> showImmediateNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'denda_channel', // Channel ID
//       'Pengingat Denda', // Channel name
//       channelDescription: 'Notifikasi pengingat denda pengembalian buku',
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: true,
//       icon: '@mipmap/ic_launcher',
//       color: Color(0xFF2196F3),
//       playSound: true,
//       enableVibration: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.show(
//       0, // Notification ID
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }

//   // Jadwalkan notifikasi untuk tanggal tertentu
//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     String? payload,
//   }) async {
//     final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(
//       scheduledDate,
//       tz.local,
//     );

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'denda_channel',
//       'Pengingat Denda',
//       channelDescription: 'Notifikasi pengingat denda pengembalian buku',
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: true,
//       icon: '@mipmap/ic_launcher',
//       color: Color(0xFF2196F3),
//       playSound: true,
//       enableVibration: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledTZ,
//       details,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       payload: payload,
//     );
//   }

//   // Batalkan notifikasi tertentu
//   Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id);
//   }

//   // Batalkan semua notifikasi
//   Future<void> cancelAllNotifications() async {
//     await _notifications.cancelAll();
//   }

//   // Cek apakah notifikasi sudah dijadwalkan
//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     return await _notifications.pendingNotificationRequests();
//   }
// }