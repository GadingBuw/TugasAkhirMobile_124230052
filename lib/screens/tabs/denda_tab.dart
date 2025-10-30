// import 'package:flutter/material.dart';

// class DendaTab extends StatefulWidget {
//   const DendaTab({super.key});

//   @override
//   State<DendaTab> createState() => _DendaTabState();
// }

// class _DendaTabState extends State<DendaTab> {
//   // Variabel untuk menyimpan tanggal yang dipilih
//   DateTime? _tanggalTenggat;
//   DateTime? _tanggalKembali;

//   // Variabel untuk menyimpan hasil perhitungan
//   int? _totalDenda; // Ini akan menjadi basis IDR

//   // --- Kurs Manual (Hardcoded) ---
//   // Estimasi: 1 IDR = X Mata Uang Asing
//   // Anda bisa mengubah nilai ini kapan saja.
//   final Map<String, double> _manualRates = {
//     'MYR': 0.00029, // 1 IDR = 0.00029 MYR
//     'USD': 0.000061, // 1 IDR = 0.000061 USD
//     'EUR': 0.000057, // 1 IDR = 0.000057 EUR
//   };
//   // --- Tidak ada lagi variabel _isLoadingRates atau _apiError ---

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // Tidak perlu memanggil API lagi
//   // }

//   // --- Tidak ada lagi fungsi _fetchExchangeRates ---

//   // Fungsi untuk menampilkan format tanggal
//   String _formatDate(DateTime? dt) {
//     if (dt == null) {
//       return 'Belum dipilih';
//     }
//     return "${dt.day}-${dt.month}-${dt.year}";
//   }

//   // Fungsi untuk memilih Tanggal
//   Future<DateTime?> _pilihTanggal(BuildContext context) async {
//     final DateTime? tanggal = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     return tanggal;
//   }

//   // Fungsi untuk menghitung denda
//   void _hitungDenda() {
//     if (_tanggalTenggat == null || _tanggalKembali == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Harap pilih tanggal tenggat DAN tanggal kembali!'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     if (_tanggalKembali!.isBefore(_tanggalTenggat!)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Tanggal kembali tidak boleh sebelum tanggal tenggat!'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       setState(() {
//         _totalDenda = null;
//       });
//       return;
//     }

//     final Duration selisih = _tanggalKembali!.difference(_tanggalTenggat!);
//     final int totalHariTelat = selisih.inDays;
//     final int denda = totalHariTelat * 1000;

//     setState(() {
//       _totalDenda = denda;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hitung Denda Keterlambatan'),
//       ),
//       // --- Logika loading/error dihapus, body utama dikembalikan ---
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // --- Input Tanggal Tenggat ---
//             _buildPickerCard(
//               context: context,
//               title: 'Tenggat Peminjaman',
//               timeText: _formatDate(_tanggalTenggat),
//               onTap: () async {
//                 final waktu = await _pilihTanggal(context);
//                 if (waktu != null) {
//                   setState(() {
//                     _tanggalTenggat = waktu;
//                     _totalDenda = null;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 16),

//             // --- Input Tanggal Kembali ---
//             _buildPickerCard(
//               context: context,
//               title: 'Tanggal Pengembalian',
//               timeText: _formatDate(_tanggalKembali),
//               onTap: () async {
//                 final waktu = await _pilihTanggal(context);
//                 if (waktu != null) {
//                   setState(() {
//                     _tanggalKembali = waktu;
//                     _totalDenda = null;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 30),

//             // --- Tombol Hitung ---
//             ElevatedButton.icon(
//               icon: const Icon(Icons.calculate_rounded),
//               label: const Text('HITUNG DENDA'),
//               onPressed: _hitungDenda,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 textStyle:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 30),

//             // --- Hasil Perhitungan ---
//             if (_totalDenda != null) ...[
//               Center(
//                 child: Text(
//                   'Total Denda yang Harus Dibayar:',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // --- Hasil IDR ---
//               Center(
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.blue.shade200),
//                   ),
//                   child: Text(
//                     'Rp $_totalDenda', // Denda dalam IDR
//                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue.shade900,
//                         ),
//                   ),
//                 ),
//               ),
//               if (_totalDenda == 0)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Center(
//                     child: Text(
//                       'Tepat waktu, tidak ada denda!',
//                       style: TextStyle(color: Colors.green),
//                     ),
//                   ),
//                 ),

//               // --- Bagian Konversi (menggunakan _manualRates) ---
//               if (_totalDenda! > 0) ...[
//                 const SizedBox(height: 24),
//                 const Divider(),
//                 const SizedBox(height: 16),
//                 Center(
//                   child: Text(
//                     'Estimasi Konversi Kurs:',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Card(
//                   elevation: 1,
//                   color: Colors.grey.shade50,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         _buildCurrencyRow(
//                           'MYR',
//                           'RM',
//                           _manualRates['MYR']!, // Ambil dari map manual
//                         ),
//                         const Divider(height: 16),
//                         _buildCurrencyRow(
//                           'USD',
//                           '\$',
//                           _manualRates['USD']!, // Ambil dari map manual
//                         ),
//                         const Divider(height: 16),
//                         _buildCurrencyRow(
//                           'EUR',
//                           '€',
//                           _manualRates['EUR']!, // Ambil dari map manual
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
                
//               ]
//             ]
//           ],
//         ),
//       ),
//     );
//   }

//   // --- Widget helper untuk baris konversi (Tidak berubah) ---
//   Widget _buildCurrencyRow(String currencyCode, String symbol, double rate) {
//     // Lakukan kalkulasi konversi
//     final double convertedValue = _totalDenda! * rate;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           '$currencyCode ($symbol)',
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         Text(
//           // Tampilkan 2 angka di belakang koma untuk mata uang asing
//           convertedValue.toStringAsFixed(2),
//           style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87),
//         ),
//       ],
//     );
//   }

//   // Widget helper untuk card input (Tidak berubah)
//   Widget _buildPickerCard({
//     required BuildContext context,
//     required String title,
//     required String timeText,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 2,
//       child: ListTile(
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//         leading: Icon(
//           Icons.calendar_today_rounded,
//           color: Theme.of(context).primaryColor,
//           size: 30,
//         ),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(
//           timeText,
//           style: TextStyle(
//             fontSize: 16,
//             color: timeText == 'Belum dipilih'
//                 ? Colors.grey.shade600
//                 : Colors.black87,
//           ),
//         ),
//         trailing: const Icon(Icons.edit_calendar_rounded),
//         onTap: onTap,
//       ),
//     );
//   }
// }














import 'package:flutter/material.dart';

class DendaTab extends StatefulWidget {
  const DendaTab({super.key});

  @override
  State<DendaTab> createState() => _DendaTabState();
}

class _DendaTabState extends State<DendaTab> with SingleTickerProviderStateMixin {
  // Variabel untuk menyimpan tanggal yang dipilih
  DateTime? _tanggalTenggat;
  DateTime? _tanggalKembali;

  // Variabel untuk menyimpan hasil perhitungan
  int? _totalDenda;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Kurs Manual
  final Map<String, double> _manualRates = {
    'MYR': 0.00029,
    'USD': 0.000061,
    'EUR': 0.000057,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan format tanggal
  String _formatDate(DateTime? dt) {
    if (dt == null) {
      return 'Belum dipilih';
    }
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
  }

  // Fungsi untuk memilih Tanggal
  Future<DateTime?> _pilihTanggal(BuildContext context) async {
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF8B4513),
              onPrimary: Color(0xFFF5E6D3),
              surface: Color(0xFFF5E6D3),
              onSurface: Color(0xFF3E2723),
            ),
          ),
          child: child!,
        );
      },
    );
    return tanggal;
  }

  // Fungsi untuk menghitung denda
  void _hitungDenda() {
    if (_tanggalTenggat == null || _tanggalKembali == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Harap pilih tanggal tenggat DAN tanggal kembali!'),
              ),
            ],
          ),
          backgroundColor: Color(0xFF8B4513),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    if (_tanggalKembali!.isBefore(_tanggalTenggat!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Tanggal kembali tidak boleh sebelum tanggal tenggat!'),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      setState(() {
        _totalDenda = null;
      });
      return;
    }

    final Duration selisih = _tanggalKembali!.difference(_tanggalTenggat!);
    final int totalHariTelat = selisih.inDays;
    final int denda = totalHariTelat * 1000;

    setState(() {
      _totalDenda = denda;
    });
    
    _animationController.reset();
    _animationController.forward();
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
          child: Column(
            children: [
              // Custom AppBar
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
                        Icons.account_balance_wallet_rounded,
                        color: Color(0xFF3E2723),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KALKULATOR DENDA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF8B4513),
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'Keterlambatan Buku',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5E6D3).withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFFD4AF37), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFD4AF37).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFFD4AF37),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF8B4513),
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informasi Denda',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3E2723),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Denda keterlambatan:\nRp 1.000 per hari',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF654321),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tanggal Tenggat Card
                      _buildDateCard(
                        title: 'Tanggal Tenggat Peminjaman',
                        icon: Icons.event_available_rounded,
                        date: _tanggalTenggat,
                        dateText: _formatDate(_tanggalTenggat),
                        onTap: () async {
                          final waktu = await _pilihTanggal(context);
                          if (waktu != null) {
                            setState(() {
                              _tanggalTenggat = waktu;
                              _totalDenda = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Icon Arrow Down
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFD4AF37).withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: Color(0xFFD4AF37),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tanggal Kembali Card
                      _buildDateCard(
                        title: 'Tanggal Pengembalian Buku',
                        icon: Icons.event_busy_rounded,
                        date: _tanggalKembali,
                        dateText: _formatDate(_tanggalKembali),
                        onTap: () async {
                          final waktu = await _pilihTanggal(context);
                          if (waktu != null) {
                            setState(() {
                              _tanggalKembali = waktu;
                              _totalDenda = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 30),

                      // Tombol Hitung
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF8B4513), Color(0xFF654321)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF8B4513).withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _hitungDenda,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calculate_rounded, color: Color(0xFFF5E6D3)),
                              const SizedBox(width: 12),
                              Text(
                                'HITUNG DENDA',
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
                      ),
                      const SizedBox(height: 30),

                      // Hasil Perhitungan
                      if (_totalDenda != null) ...[
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            children: [
                              // Header Hasil
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5E6D3).withOpacity(0.95),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  border: Border.all(color: Color(0xFFD4AF37), width: 2),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _totalDenda == 0 
                                          ? Icons.check_circle_rounded 
                                          : Icons.receipt_long_rounded,
                                      color: _totalDenda == 0 
                                          ? Colors.green.shade700 
                                          : Color(0xFF8B4513),
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _totalDenda == 0 
                                          ? 'Tidak Ada Denda!' 
                                          : 'Total Denda',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3E2723),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Hasil IDR
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: _totalDenda == 0
                                      ? LinearGradient(
                                          colors: [
                                            Colors.green.shade50,
                                            Colors.green.shade100,
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            Color(0xFFD4AF37).withOpacity(0.1),
                                            Color(0xFFD4AF37).withOpacity(0.2),
                                          ],
                                        ),
                                  border: Border(
                                    left: BorderSide(color: Color(0xFFD4AF37), width: 2),
                                    right: BorderSide(color: Color(0xFFD4AF37), width: 2),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    if (_totalDenda == 0) ...[
                                      Icon(
                                        Icons.sentiment_very_satisfied_rounded,
                                        color: Colors.green.shade700,
                                        size: 48,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Tepat Waktu!',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tidak ada keterlambatan\nTerima kasih atas kedisiplinan Anda',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green.shade900,
                                          height: 1.5,
                                        ),
                                      ),
                                    ] else ...[
                                      Text(
                                        'Jumlah yang harus dibayar:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF654321),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Rp ${_totalDenda!.toString().replaceAllMapped(
                                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                          (Match m) => '${m[1]}.',
                                        )}',
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF8B4513),
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF8B4513).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Color(0xFF8B4513).withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          '${(_tanggalKembali!.difference(_tanggalTenggat!).inDays)} hari keterlambatan',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF654321),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              
                              // Footer
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5E6D3).withOpacity(0.95),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  border: Border.all(color: Color(0xFFD4AF37), width: 2),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 16,
                                      color: Color(0xFF8B4513),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Dihitung pada ${_formatDate(DateTime.now())}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF654321),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Konversi Mata Uang
                        if (_totalDenda! > 0) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5E6D3).withOpacity(0.95),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Color(0xFFD4AF37), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.currency_exchange_rounded,
                                      color: Color(0xFF8B4513),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Estimasi Konversi Kurs',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3E2723),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildCurrencyRow('Ringgit Malaysia', 'MYR', 'RM', _manualRates['MYR']!),
                                const SizedBox(height: 12),
                                Divider(color: Color(0xFFD4AF37).withOpacity(0.5)),
                                const SizedBox(height: 12),
                                _buildCurrencyRow('US Dollar', 'USD', '\$', _manualRates['USD']!),
                                const SizedBox(height: 12),
                                Divider(color: Color(0xFFD4AF37).withOpacity(0.5)),
                                const SizedBox(height: 12),
                                _buildCurrencyRow('Euro', 'EUR', '€', _manualRates['EUR']!),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Date Card
  Widget _buildDateCard({
    required String title,
    required IconData icon,
    required DateTime? date,
    required String dateText,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5E6D3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: date != null ? Color(0xFFD4AF37) : Color(0xFF8B4513).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: date != null 
                        ? Color(0xFFD4AF37).withOpacity(0.2)
                        : Color(0xFF8B4513).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: date != null ? Color(0xFFD4AF37) : Color(0xFF8B4513).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Color(0xFF8B4513),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF654321),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: date != null ? Color(0xFF3E2723) : Color(0xFF8B4513).withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit_calendar_rounded,
                  color: Color(0xFF8B4513),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk Currency Row
  Widget _buildCurrencyRow(String currencyName, String currencyCode, String symbol, double rate) {
    final double convertedValue = _totalDenda! * rate;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currencyName,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF654321),
                ),
              ),
              Text(
                currencyCode,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFD4AF37).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color(0xFFD4AF37).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            '$symbol ${convertedValue.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B4513),
            ),
          ),
        ),
      ],
    );
  }
}