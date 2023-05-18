import 'package:aya_flutter_v2/constants/colors.dart';
import 'package:aya_flutter_v2/screens/lists/lists.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../../services/auth.dart';
import '../profile/profile.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: _currentIndex == 0
            ? const Text('İlanlar')
            : _currentIndex == 1
                ? const Text('Profil')
                : const Text('Anasayfa'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: _auth.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _currentIndex == 0
          ? const Center(
              child: ListPage(),
            )
          : _currentIndex == 1
              ? const Center(
                  child: ProfilePage(),
                )
              : _homeContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottom navigation bar
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.folder,
          Icons.person,
        ],
        activeIndex: 0,
        notchSmoothness: NotchSmoothness.softEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: AppColors.primary,
        activeColor: Colors.white,
        inactiveColor: Colors.white,
      ),
    );
  }

  Widget _homeContent() => Center(child: Text("Home Content"));
}
