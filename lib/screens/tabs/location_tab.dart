// import 'dart:async'; // Untuk StreamSubscription (update lokasi real-time)
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart'; // Package untuk peta OpenStreetMap
// import 'package:geolocator/geolocator.dart'; // Package untuk data GPS
// import 'package:latlong2/latlong.dart'; // Package format koordinat untuk flutter_map
// // --- TIDAK PERLU IMPORT TIMEZONE ---

// class LocationTab extends StatefulWidget {
//   const LocationTab({super.key});

//   @override
//   State<LocationTab> createState() => _LocationTabState();
// }

// class _LocationTabState extends State<LocationTab> {
//   // Controller untuk menggerakkan peta
//   final MapController _mapController = MapController();

//   // Koordinat Perpustakaan di Kledokan, Sleman (Titik pusat Kledokan)
//   final LatLng _libraryLocation = const LatLng(-7.7770, 110.4025);

//   // Variabel untuk menyimpan lokasi pengguna (awalnya null)
//   LatLng? _currentUserLocation;

//   bool _isLoading = true;
//   String _loadingMessage = 'Mencari lokasi Anda...';

//   // Stream untuk "mendengarkan" perubahan lokasi pengguna secara real-time
//   StreamSubscription<Position>? _positionStream;

//   @override
//   void initState() {
//     super.initState();
//     _centerMapOnUser(); // Mulai proses saat halaman dibuka
//   }

//   @override
//   void dispose() {
//     // PENTING: Hentikan stream saat halaman ditutup untuk hemat baterai
//     _positionStream?.cancel();
//     super.dispose();
//   }

//   /// Memeriksa dan meminta izin lokasi.
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Cek apakah layanan lokasi (GPS) di HP aktif
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         _loadingMessage = 'Layanan lokasi mati. Harap aktifkan GPS.';
//       });
//       return false;
//     }

//     // Cek izin yang sudah diberikan
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       // Jika belum, minta izin
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _loadingMessage = 'Izin lokasi ditolak.';
//         });
//         return false;
//       }
//     }

//     // Handle jika izin ditolak permanen
//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         _loadingMessage =
//             'Izin lokasi ditolak permanen. Buka pengaturan aplikasi untuk mengizinkan.';
//       });
//       return false;
//     }

//     // Izin diberikan
//     return true;
//   }

//   /// Mendapatkan lokasi awal pengguna dan memulai stream
//   Future<void> _centerMapOnUser() async {
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) {
//       setState(() {
//         _isLoading = false; // <-- Semula: _loadingMessage = false
//       });
//       return;
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         _currentUserLocation = LatLng(position.latitude, position.longitude);
//         _isLoading = false;
//       });

//       // Mulai mendengarkan perubahan lokasi (real-time)
//       _listenToLocationChanges();
//     } catch (e) {
//       setState(() {
//         _loadingMessage = 'Gagal mendapatkan lokasi: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   /// Stream untuk update lokasi real-time
//   void _listenToLocationChanges() {
//     const LocationSettings locationSettings = LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 10, // Update jika pengguna bergerak 10 meter
//     );

//     _positionStream =
//         Geolocator.getPositionStream(locationSettings: locationSettings)
//             .listen((Position position) {
//       if (mounted) {
//         setState(() {
//           _currentUserLocation = LatLng(position.latitude, position.longitude);
//         });
//       }
//     });
//   }

//   // --- Fungsi untuk memindahkan kamera peta ---
//   void _moveToLocation(LatLng location) {
//     // Ambil zoom level saat ini agar tidak ter-reset
//     final currentZoom = _mapController.camera.zoom;
//     _mapController.move(location, currentZoom);
//   }

//   // --- Fungsi untuk Zoom In ---
//   void _zoomIn() {
//     _mapController.move(
//         _mapController.camera.center, _mapController.camera.zoom + 1);
//   }

//   // --- Fungsi untuk Zoom Out ---
//   void _zoomOut() {
//     _mapController.move(
//         _mapController.camera.center, _mapController.camera.zoom - 1);
//   }

//   // --- FUNGSI UNTUK MENAMPILKAN DETAIL PERPUSTAKAAN ---
//   void _showLibraryDetailsSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       // Membuat sudut atas membulat
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (ctx) { // Penting: 'ctx' adalah context dari BottomSheet
//         return Container(
//           padding: const EdgeInsets.all(24.0),
//           // Batasi tinggi panel agar tidak menutupi seluruh layar
//           height: MediaQuery.of(context).size.height * 0.45,
//           child: SingleChildScrollView(
//             // Agar bisa di-scroll jika konten penuh
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 1. Nama Perpustakaan
//                 Text(
//                   "Perpustakaan Gading Kledokan",
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const Divider(height: 24),

//                 // 2. Jam Buka/Tutup [DIMODIFIKASI AGAR BISA DI-TAP]
//                 _buildInfoRow(
//                   context,
//                   Icons.access_time_filled_rounded,
//                   "Jam Operasional",
//                   "Senin - Jumat: 08:00 - 16:00 WIB\nSabtu: 09:00 - 13:00 WIB\n(Klik untuk lihat konversi zona waktu)",
//                   onTap: () {
//                     // Tutup modal saat ini
//                     Navigator.of(ctx).pop(); 
//                     // Buka modal baru untuk konversi
//                     _showTimeConversionSheet(context);
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // 3. Deskripsi
//                 _buildInfoRow(
//                   context,
//                   Icons.info_outline_rounded,
//                   "Deskripsi",
//                   "Ini adalah perpustakaan yang Menyediakan koleksi novel dan ruang baca yang nyaman di area Kledokan.",
//                 ),
//                 const SizedBox(height: 16),

//                 // 4. Info Dibangun
//                 _buildInfoRow(
//                   context,
//                   Icons.calendar_month_rounded,
//                   "Didirikan",
//                   "25 Oktober 2025",
//                 ),
//                 const SizedBox(height: 20), // Spasi di bagian bawah
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // --- [BARU] FUNGSI UNTUK MENAMPILKAN KONVERSI WAKTU ---
//   void _showTimeConversionSheet(BuildContext context) {
//     // 1. Definisikan jam dasar (WIB)
//     const int senJumOpenWIB = 8;
//     const int senJumCloseWIB = 16;
//     const int sabtuOpenWIB = 9;
//     const int sabtuCloseWIB = 13;

//     // 2. Definisikan selisih jam manual
//     const int witaOffset = 1; // WIB + 1
//     const int witOffset = 2; // WIB + 2
//     const int gmtOffset = -7; // WIB - 7 (London GMT)

//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (ctx) {
//         return Container(
//           padding: const EdgeInsets.all(24.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Konversi Jam Operasional",
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const Divider(height: 24),
                
//                 // WIB (Dasar)
//                 _buildConversionRow(
//                   "WIB (UTC+7)",
//                   "Sen-Jum: 08:00 - 16:00",
//                   "Sabtu: 09:00 - 13:00",
//                 ),
//                 const Divider(),
                
//                 // WITA
//                 _buildConversionRow(
//                   "WITA (UTC+8)",
//                   "Sen-Jum: ${_getConvertedHours(senJumOpenWIB, senJumCloseWIB, witaOffset)}",
//                   "Sabtu: ${_getConvertedHours(sabtuOpenWIB, sabtuCloseWIB, witaOffset)}",
//                 ),
//                 const Divider(),
                
//                 // WIT
//                 _buildConversionRow(
//                   "WIT (UTC+9)",
//                   "Sen-Jum: ${_getConvertedHours(senJumOpenWIB, senJumCloseWIB, witOffset)}",
//                   "Sabtu: ${_getConvertedHours(sabtuOpenWIB, sabtuCloseWIB, witOffset)}",
//                 ),
//                 const Divider(),
                
//                 // London
//                 _buildConversionRow(
//                   "London (GMT/UTC+0)",
//                   "Sen-Jum: ${_getConvertedHours(senJumOpenWIB, senJumCloseWIB, gmtOffset)}",
//                   "Sabtu: ${_getConvertedHours(sabtuOpenWIB, sabtuCloseWIB, gmtOffset)}",
//                 ),
//                 const SizedBox(height: 16),
//                 const Center(
//                   child: Text(
//                     "*Waktu London adalah estimasi (GMT)\ntanpa menghitung British Summer Time (BST).",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // --- [BARU] Helper untuk memformat jam (menangani 24:00 atau -1:00) ---
//   String _formatHour(int hour) {
//     if (hour < 0) {
//       hour = 24 + hour; // Cth: -1 menjadi 23
//     } else if (hour >= 24) {
//       hour = hour % 24; // Cth: 24 menjadi 00, 25 menjadi 01
//     }
//     return hour.toString().padLeft(2, '0') + ':00';
//   }

//   // --- [BARU] Helper untuk kalkulasi manual ---
//   String _getConvertedHours(int openWIB, int closeWIB, int offset) {
//     String open = _formatHour(openWIB + offset);
//     String close = _formatHour(closeWIB + offset);
//     return "$open - $close";
//   }

//   // --- [BARU] Widget helper untuk baris di modal konversi ---
//   Widget _buildConversionRow(String timezone, String line1, String line2) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 140, // Beri lebar agar label rapi
//             child: Text(
//               timezone,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(line1, style: const TextStyle(fontSize: 15)),
//                 const SizedBox(height: 4),
//                 Text(line2, style: const TextStyle(fontSize: 15)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Widget helper untuk membuat baris info (agar rapi) ---
//   // --- [DIMODIFIKASI] Menambahkan {VoidCallback? onTap} ---
//   Widget _buildInfoRow(
//     BuildContext context,
//     IconData icon,
//     String title,
//     String subtitle, {
//     VoidCallback? onTap,
//   }) {
//     // Gunakan InkWell jika onTap ada, jika tidak, gunakan Container biasa
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8.0), // Efek ripple yang rapi
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 4.0), // Padding tap area
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: Theme.of(context).primaryColor, size: 24),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style:
//                           const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   const SizedBox(height: 4),
//                   Text(subtitle, style: const TextStyle(fontSize: 14, height: 1.4)),
//                 ],
//               ),
//             ),
//             // Tampilkan ikon panah jika bisa di-tap
//             if (onTap != null) const Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lokasi Perpustakaan (OSM)'),
//       ),
//       body: _isLoading
//           ? Center(
//               // Tampilan saat loading
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircularProgressIndicator(),
//                   const SizedBox(height: 20),
//                   Text(_loadingMessage),
//                 ],
//               ),
//             )
//           // Gunakan Stack untuk menumpuk peta dan tombol
//           : Stack(
//               children: [
//                 FlutterMap(
//                   mapController: _mapController,
//                   options: MapOptions(
//                     // Paksa peta terbuka di lokasi perpustakaan
//                     initialCenter: _libraryLocation,
//                     initialZoom: 15.0,
//                     interactionOptions: const InteractionOptions(
//                       flags: InteractiveFlag.all,
//                     ),
//                   ),
//                   children: [
//                     // 1. Layer Peta (dari OpenStreetMap)
//                     TileLayer(
//                       urlTemplate:
//                           'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                       // Ganti 'com.example.library_app' dengan nama paket aplikasi Anda
//                       userAgentPackageName: 'com.example.library_app',
//                     ),

//                     // 2. Layer Marker (Pin)
//                     MarkerLayer(
//                       markers: [
//                         // --- MARKER PERPUSTAKAAN (SUDAH BISA DI-KLIK) ---
//                         Marker(
//                           width: 80.0,
//                           height: 80.0,
//                           point: _libraryLocation,
//                           // Ganti Tooltip dengan GestureDetector
//                           child: GestureDetector(
//                             onTap: () {
//                               // Panggil fungsi bottom sheet
//                               _showLibraryDetailsSheet(context);
//                             },
//                             child: Tooltip(
//                               message: 'Klik untuk detail\nPerpustakaan Gading',
//                               child: Icon(
//                                 Icons.school, // Ikon perpustakaan
//                                 color: Colors.blue.shade800,
//                                 size: 40.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                         // --- AKHIR MARKER PERPUSTAKAAN ---

//                         // Marker untuk Lokasi Pengguna (hanya tampil jika lokasi ada)
//                         if (_currentUserLocation != null)
//                           Marker(
//                             width: 80.0,
//                             height: 80.0,
//                             point: _currentUserLocation!,
//                             child: const Tooltip(
//                               message: 'Lokasi Anda',
//                               child: Icon(
//                                 Icons.person_pin_circle, // Ikon lokasi Anda
//                                 color: Colors.red,
//                                 size: 40.0,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 // --- KUMPULAN TOMBOL KONTROL ---
//                 Positioned(
//                   right: 16.0,
//                   bottom: 16.0,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       // --- Tombol Zoom In ---
//                       FloatingActionButton(
//                         heroTag: 'btn_zoom_in',
//                         mini: true,
//                         onPressed: _zoomIn,
//                         child: const Icon(Icons.add),
//                       ),
//                       const SizedBox(height: 8),

//                       // --- Tombol Zoom Out ---
//                       FloatingActionButton(
//                         heroTag: 'btn_zoom_out',
//                         mini: true,
//                         onPressed: _zoomOut,
//                         child: const Icon(Icons.remove),
//                       ),
//                       const SizedBox(height: 16), // Pemisah

//                       // --- Tombol Lokasi Saya ---
//                       FloatingActionButton(
//                         heroTag: 'btn_lokasi_saya',
//                         mini: true,
//                         onPressed: () {
//                           if (_currentUserLocation != null) {
//                             _moveToLocation(_currentUserLocation!);
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Lokasi Anda masih dicari...'),
//                               ),
//                             );
//                           }
//                         },
//                         child: const Icon(Icons.my_location),
//                       ),
//                       const SizedBox(height: 8),

//                       // --- Tombol Lokasi Perpus ---
//                       FloatingActionButton(
//                         heroTag: 'btn_lokasi_perpus',
//                         mini: true,
//                         backgroundColor: Colors.blue.shade800,
//                         onPressed: () {
//                           _moveToLocation(_libraryLocation);
//                         },
//                         child: const Icon(Icons.school, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }














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
                            "Perpustakaan Gading",
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