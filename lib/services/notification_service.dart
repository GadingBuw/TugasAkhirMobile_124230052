import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) async {
    final String? payload = response.payload;
    if (payload != null) {
      print('Notification payload: $payload');
    }
  }

  Future<void> showDendaNotification({
    required int totalDenda,
    required int hariTelat,
    required String tanggalKembali,
  }) async {
    String formattedDenda = totalDenda.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'denda_channel', 
      'Pengingat Denda', 
      channelDescription: 'Notifikasi pengingat pembayaran denda keterlambatan buku',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF8B4513),
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, 
      '📚 Pengingat Pengembalian Buku',
      'Hari ini adalah hari pengembalian buku. Anda memiliki denda keterlambatan sebesar Rp $formattedDenda ($hariTelat hari keterlambatan). Segera lakukan pembayaran!',
      notificationDetails,
      payload: 'denda_$totalDenda',
    );
  }

  Future<void> scheduleDendaNotification({
    required int totalDenda,
    required int hariTelat,
    required String tanggalKembali,
  }) async {
    await Future.delayed(const Duration(seconds: 5));
    
    await showDendaNotification(
      totalDenda: totalDenda,
      hariTelat: hariTelat,
      tanggalKembali: tanggalKembali,
    );
  }

  Future<void> showNoDendaNotification({
    required String tanggalKembali,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'denda_channel',
      'Pengingat Denda',
      channelDescription: 'Notifikasi pengingat pembayaran denda keterlambatan buku',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF4CAF50),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      '✅ Tepat Waktu!',
      'Selamat! Anda mengembalikan buku tepat waktu. Tidak ada denda yang perlu dibayar. Terima kasih atas kedisiplinan Anda!',
      notificationDetails,
      payload: 'no_denda',
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}