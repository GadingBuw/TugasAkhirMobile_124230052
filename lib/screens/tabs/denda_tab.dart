import 'package:flutter/material.dart';
import 'package:library_app/services/notification_service.dart'; // Import notification service

class DendaTab extends StatefulWidget {
  const DendaTab({super.key});

  @override
  State<DendaTab> createState() => _DendaTabState();
}

class _DendaTabState extends State<DendaTab> with SingleTickerProviderStateMixin {
  DateTime? _tanggalTenggat;
  DateTime? _tanggalKembali;
  int? _totalDenda;
  bool _isSchedulingNotification = false; // Track notifikasi

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final Map<String, double> _manualRates = {
    'MYR': 0.00029,
    'USD': 0.000061,
    'EUR': 0.000057,
  };

  final NotificationService _notificationService = NotificationService();

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

  void _hitungDenda() async {
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
      _isSchedulingNotification = true;
    });
    
    _animationController.reset();
    _animationController.forward();

    // Tampilkan SnackBar countdown
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Notifikasi akan dikirim dalam 5 detik...'),
            ),
          ],
        ),
        backgroundColor: Color(0xFF8B4513),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
      ),
    );

    // Schedule notifikasi setelah 5 detik
    if (denda > 0) {
      _notificationService.scheduleDendaNotification(
        totalDenda: denda,
        hariTelat: totalHariTelat,
        tanggalKembali: _formatDate(_tanggalKembali),
      ).then((_) {
        setState(() {
          _isSchedulingNotification = false;
        });
        
        // Tampilkan konfirmasi notifikasi terkirim
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.notifications_active, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Notifikasi pengingat telah dikirim!'),
                  ),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    } else {
      // Jika tidak ada denda, kirim notifikasi tepat waktu setelah 5 detik
      Future.delayed(const Duration(seconds: 5), () {
        _notificationService.showNoDendaNotification(
          tanggalKembali: _formatDate(_tanggalKembali),
        );
        
        setState(() {
          _isSchedulingNotification = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.notifications_active, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Notifikasi pengingat telah dikirim!'),
                  ),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
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
                    // Indikator notifikasi
                    if (_isSchedulingNotification)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF8B4513).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF8B4513),
                            ),
                          ),
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
                          onPressed: _isSchedulingNotification ? null : _hitungDenda,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isSchedulingNotification)
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFF5E6D3),
                                    ),
                                  ),
                                )
                              else
                                Icon(Icons.calculate_rounded, color: Color(0xFFF5E6D3)),
                              const SizedBox(width: 12),
                              Text(
                                _isSchedulingNotification 
                                    ? 'MENGIRIM NOTIFIKASI...' 
                                    : 'HITUNG DENDA',
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
                                            Color(0xFFFFFDF7), // Cream putih tulang
                                            Color(0xFFFAF6EF), // Cream agak kekuningan
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
                                          color: Color(0xFF3E2723),
                                          fontWeight: FontWeight.w600,
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
                                          color: Color(0xFF8B2500), // Coklat merah tua
                                          letterSpacing: 1,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(0.15),
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFEFE5), // Cream pink muda
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Color(0xFFD4AF37), // Gold border
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          '${(_tanggalKembali!.difference(_tanggalTenggat!).inDays)} hari keterlambatan',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF5D3A1A), // Coklat gelap
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              
                              // Footer dengan info notifikasi
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
                                child: Column(
                                  children: [
                                    Row(
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
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.notifications_active,
                                          size: 16,
                                          color: Color(0xFF8B4513),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Notifikasi pengingat akan dikirim',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF654321),
                                          ),
                                        ),
                                      ],
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