// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklps_app/screens/home/admin/admin_first_page.dart';
import 'admin_account.dart';
import 'admin_search.dart';

const _kPrimary = Color(0xFF1565C0);

class AdminHomeWrapper extends StatefulWidget {
  const AdminHomeWrapper({Key? key}) : super(key: key);

  @override
  State<AdminHomeWrapper> createState() => _AdminHomeWrapperState();
}

class _AdminHomeWrapperState extends State<AdminHomeWrapper> {
  int currentIndex = 0;

  void onTap(int index) => setState(() => currentIndex = index);

  final List<Widget> pages = [
    AdminFirstPage(),
    AdminSearch(),
    AdminAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}

// ── Floating nav bar ────────────────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.campaign_outlined,
                activeIcon: Icons.campaign_rounded,
                label: 'Home',
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search_rounded,
                label: 'Search',
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: selected ? _kPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                selected ? activeIcon : icon,
                color: selected ? Colors.white : Colors.grey[400],
                size: 22,
              ),
            ),
            if (selected) ...[
              const SizedBox(height: 3),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: _kPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
