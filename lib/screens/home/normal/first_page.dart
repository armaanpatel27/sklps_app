// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklps_app/services/access_data.dart';
import 'package:sklps_app/services/announcement_helper.dart';

const _kPrimary = Color(0xFF1565C0);

const _avatarColors = [
  Color(0xFF1565C0),
  Color(0xFF00897B),
  Color(0xFF7B1FA2),
  Color(0xFFE65100),
  Color(0xFF2E7D32),
  Color(0xFFC62828),
];

Color _avatarColor(String name) =>
    _avatarColors[name.isNotEmpty ? name.codeUnitAt(0) % _avatarColors.length : 0];

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts[0].isEmpty) return '?';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

String _formatDate(dynamic ts) {
  if (ts == null) return '';
  final date = (ts as Timestamp).toDate();
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final ampm = date.hour >= 12 ? 'PM' : 'AM';
  final min = date.minute.toString().padLeft(2, '0');
  return '${months[date.month - 1]} ${date.day} · $hour:$min $ampm';
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final AccessData _accessData = AccessData();
  final AnnouncementHelper _helper = AnnouncementHelper();
  List<Map<dynamic, dynamic>> _announcements = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await _accessData.getAllDocuments('announcements');
      _helper.sortListByDate(list);
      if (mounted) setState(() { _announcements = list; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() { _isError = true; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _kPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Blue header ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.05, size.height * 0.02,
                  size.width * 0.05, size.height * 0.025),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.campaign_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Announcements',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Stay up to date with the latest news',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── White card ──────────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _kPrimary, strokeWidth: 2.5),
      );
    }
    if (_isError) {
      return _EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Could not load',
        subtitle: 'Pull down to try again',
        iconColor: Colors.red[300]!,
      );
    }
    if (_announcements.isEmpty) {
      return _EmptyState(
        icon: Icons.campaign_outlined,
        title: 'No announcements yet',
        subtitle: 'Check back later for updates',
      );
    }
    return RefreshIndicator(
      color: _kPrimary,
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        itemCount: _announcements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _AnnouncementCard(
          announcement: _announcements[index],
        ),
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _AnnouncementCard extends StatelessWidget {
  final Map<dynamic, dynamic> announcement;
  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    final name = announcement['name']?.toString() ?? '';
    final content = announcement['content']?.toString() ?? '';
    final color = _avatarColor(name);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left accent bar
              Container(width: 5, color: color),

              // Card body
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tinted header
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      color: color.withOpacity(0.07),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: color.withOpacity(0.18),
                            child: Text(
                              _initials(name),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _formatDate(announcement['timestamp']),
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: color,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Text(
                        content,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF3D3D3D),
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (iconColor ?? _kPrimary).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: 40, color: (iconColor ?? _kPrimary).withOpacity(0.7)),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E))),
          const SizedBox(height: 6),
          Text(subtitle,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
