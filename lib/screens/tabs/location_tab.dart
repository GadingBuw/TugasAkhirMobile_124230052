import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationTab extends StatefulWidget {
  const LocationTab({super.key});

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  final MapController _mapController = MapController();
  final LatLng _libraryLocation = const LatLng(-7.7770, 110.4025);
  LatLng? _currentUserLocation;
  bool _isLoading = true;
  String _loadingMessage = 'Mencari lokasi Anda...';
  StreamSubscription<Position>? _positionStream;

  // Color palette dari login screen
  static const Color _brownDark = Color(0xFF3E2723);
  static const Color _brownMedium = Color(0xFF654321);
  static const Color _brownSaddle = Color(0xFF8B4513);
  static const Color _parchment = Color(0xFFF5E6D3);
  static const Color _gold = Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    _centerMapOnUser();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _loadingMessage = 'Layanan lokasi mati. Harap aktifkan GPS.';
      });
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _loadingMessage = 'Izin lokasi ditolak.';
        });
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _loadingMessage =
            'Izin lokasi ditolak permanen. Buka pengaturan aplikasi untuk mengizinkan.';
      });
      return false;
    }

    return true;
  }

  Future<void> _centerMapOnUser() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentUserLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _listenToLocationChanges();
    } catch (e) {
      setState(() {
        _loadingMessage = 'Gagal mendapatkan lokasi: $e';
        _isLoading = false;
      });
    }
  }

  void _listenToLocationChanges() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      if (mounted) {
        setState(() {
          _currentUserLocation = LatLng(position.latitude, position.longitude);
        });
      }
    });
  }

  void _moveToLocation(LatLng location) {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(location, currentZoom);
  }

  void _zoomIn() {
    _mapController.move(
        _mapController.camera.center, _mapController.camera.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(
        _mapController.camera.center, _mapController.camera.zoom - 1);
  }

  void _showLibraryDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: _parchment,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: _gold, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28.0),
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _gold,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _brownSaddle.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: _brownDark,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Perpustakaan Novel",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _brownDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            "Kledokan, Sleman",
                            style: TextStyle(
                              fontSize: 14,
                              color: _brownMedium,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Decorative divider
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _gold,
                                _gold.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.auto_stories, color: _gold, size: 20),
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _gold.withOpacity(0.3),
                                _gold,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                _buildInfoRow(
                  context,
                  Icons.access_time_filled_rounded,
                  "Jam Operasional",
                  "Senin - Jumat: 08:00 - 16:00 WIB\nSabtu: 09:00 - 13:00 WIB\n(Klik untuk lihat konversi zona waktu)",
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _showTimeConversionSheet(context);
                  },
                ),
                const SizedBox(height: 20),

                _buildInfoRow(
                  context,
                  Icons.info_outline_rounded,
                  "Deskripsi",
                  "Menyediakan koleksi novel klasik dan ruang baca yang nyaman di area Kledokan.",
                ),
                const SizedBox(height: 20),

                _buildInfoRow(
                  context,
                  Icons.calendar_month_rounded,
                  "Didirikan",
                  "25 Oktober 2025",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTimeConversionSheet(BuildContext context) {
    const int senJumOpenWIB = 8;
    const int senJumCloseWIB = 16;
    const int sabtuOpenWIB = 9;
    const int sabtuCloseWIB = 13;

    const int witaOffset = 1;
    const int witOffset = 2;
    const int gmtOffset = -7;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: _parchment,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: _gold, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _gold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.schedule, color: _brownDark, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Konversi Jam Operasional",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _brownDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_gold, _gold.withOpacity(0.3)],
                      ),
                    ),
                  ),
                ),

                _buildConversionRow(
                  "WIB (UTC+7)",
                  "Sen-Jum: 08:00 - 16:00",
                  "Sabtu: 09:00 - 13:00",
                ),
                _buildDivider(),

                _buildConversionRow(
                  "WITA (UTC+8)",
                  "Sen-Jum: ${_getConvertedHours(senJumOpenWIB, senJumCloseWIB, witaOffset)}",
                  "Sabtu: ${_getConvertedHours(sabtuOpenWIB, sabtuCloseWIB, witaOffset)}",
                ),
                _buildDivider(),

                _buildConversionRow(
                  "WIT (UTC+9)",
                  "Sen-Jum: ${_getConvertedHours(senJumOpenWIB, senJumCloseWIB, witOffset)}",
                  "Sabtu: ${_getConvertedHours(sabtuOpenWIB, sabtuCloseWIB, witOffset)}",
                ),
                _buildDivider(),

                _buildConversionRow(
                  "London (GMT/UTC+0)",
                  "Sen-Jum: ${_getConvertedHours(senJumOpenWIB, senJumCloseWIB, gmtOffset)}",
                  "Sabtu: ${_getConvertedHours(sabtuOpenWIB, sabtuCloseWIB, gmtOffset)}",
                ),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _brownSaddle.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _gold.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: _brownMedium, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Waktu London adalah estimasi (GMT) tanpa menghitung British Summer Time (BST).",
                          style: TextStyle(
                            fontSize: 11,
                            color: _brownMedium,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              _gold.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour < 0) {
      hour = 24 + hour;
    } else if (hour >= 24) {
      hour = hour % 24;
    }
    return hour.toString().padLeft(2, '0') + ':00';
  }

  String _getConvertedHours(int openWIB, int closeWIB, int offset) {
    String open = _formatHour(openWIB + offset);
    String close = _formatHour(closeWIB + offset);
    return "$open - $close";
  }

  Widget _buildConversionRow(String timezone, String line1, String line2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _brownSaddle.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _gold.withOpacity(0.3)),
            ),
            child: Text(
              timezone,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: _brownDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line1, style: TextStyle(fontSize: 14, color: _brownMedium)),
                const SizedBox(height: 4),
                Text(line2, style: TextStyle(fontSize: 14, color: _brownMedium)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: onTap != null ? _brownSaddle.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: onTap != null ? _gold.withOpacity(0.3) : Colors.transparent,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _gold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _brownSaddle, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: _brownDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: _brownMedium,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right, color: _brownMedium, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_on_outlined, color: _parchment, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Lokasi Perpustakaan',
              style: TextStyle(
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_brownSaddle, _brownMedium],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Container(
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
                      child: CircularProgressIndicator(
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
                      child: Text(
                        _loadingMessage,
                        style: TextStyle(
                          color: _brownDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _libraryLocation,
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.library_app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _libraryLocation,
                          child: GestureDetector(
                            onTap: () => _showLibraryDetailsSheet(context),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _parchment,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: _gold, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.menu_book_rounded,
                                    color: _brownSaddle,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _parchment,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: _gold),
                                  ),
                                  child: Text(
                                    'Perpus',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _brownDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_currentUserLocation != null)
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _currentUserLocation!,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade700,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 16.0,
                  bottom: 16.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildControlButton(
                        icon: Icons.add,
                        onPressed: _zoomIn,
                        heroTag: 'btn_zoom_in',
                      ),
                      const SizedBox(height: 8),
                      _buildControlButton(
                        icon: Icons.remove,
                        onPressed: _zoomOut,
                        heroTag: 'btn_zoom_out',
                      ),
                      const SizedBox(height: 16),
                      _buildControlButton(
                        icon: Icons.my_location,
                        onPressed: () {
                          if (_currentUserLocation != null) {
                            _moveToLocation(_currentUserLocation!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(Icons.info_outline, color: Colors.white),
                                    SizedBox(width: 12),
                                    Text('Lokasi Anda masih dicari...'),
                                  ],
                                ),
                                backgroundColor: _brownMedium,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        heroTag: 'btn_lokasi_saya',
                      ),
                      const SizedBox(height: 8),
                      _buildControlButton(
                        icon: Icons.menu_book_rounded,
                        onPressed: () => _moveToLocation(_libraryLocation),
                        heroTag: 'btn_lokasi_perpus',
                        backgroundColor: _brownSaddle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String heroTag,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: heroTag,
        mini: true,
        backgroundColor: backgroundColor ?? _parchment,
        foregroundColor: backgroundColor != null ? Colors.white : _brownSaddle,
        elevation: 0,
        onPressed: onPressed,
        child: Icon(icon, size: 22),
      ),
    );
  }
}