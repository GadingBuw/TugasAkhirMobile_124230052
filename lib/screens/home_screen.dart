import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/location_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/favorite_tab.dart'; 
import 'tabs/denda_tab.dart';
import 'tabs/saran_dan_kesanpesan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    FavoritesTab(), 
    DendaTab(),
    LocationTab(),
    ProfileTab(),
    SaranDanKesanPesanTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B4513), // Saddle brown
              Color(0xFF654321), // Dark brown
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5E6D3).withOpacity(0.95),
                  border: Border.all(
                    color: Color(0xFFD4AF37),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: _buildNavIcon(Icons.home_rounded, 0),
                      activeIcon: _buildActiveNavIcon(Icons.home_rounded, 0),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildNavIcon(Icons.favorite_rounded, 1),
                      activeIcon: _buildActiveNavIcon(Icons.favorite_rounded, 1),
                      label: 'Favorit',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildNavIcon(Icons.monetization_on_rounded, 2),
                      activeIcon: _buildActiveNavIcon(Icons.monetization_on_rounded, 2),
                      label: 'Denda',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildNavIcon(Icons.location_on_rounded, 3),
                      activeIcon: _buildActiveNavIcon(Icons.location_on_rounded, 3),
                      label: 'Lokasi',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildNavIcon(Icons.person_rounded, 4),
                      activeIcon: _buildActiveNavIcon(Icons.person_rounded, 4),
                      label: 'Profil',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildNavIcon(Icons.rate_review_rounded, 5),
                      activeIcon: _buildActiveNavIcon(Icons.rate_review_rounded, 5),
                      label: 'Saran',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Color(0xFF8B4513),
                  unselectedItemColor: Color(0xFF8B4513).withOpacity(0.4),
                  backgroundColor: Colors.transparent,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  selectedFontSize: 11,
                  unselectedFontSize: 10,
                  selectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: _onItemTapped,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk icon tidak aktif
  Widget _buildNavIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _selectedIndex == index 
            ? Color(0xFFD4AF37).withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 24,
      ),
    );
  }

  // Widget untuk icon aktif dengan efek highlight
  Widget _buildActiveNavIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD4AF37),
            Color(0xFFB8942A),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD4AF37).withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 24,
        color: Color(0xFF3E2723),
      ),
    );
  }
}