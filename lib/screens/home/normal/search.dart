// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklps_app/services/search_helper.dart';
import 'package:sklps_app/shared/text_formatting.dart';

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

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchHelper searchHelper = SearchHelper();
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onChanged(String text) async {
    text = text.trim();
    setState(() => _query = text);
    if (text.length < 3) {
      searchHelper.resetState();
      searchHelper.returnedUsersMap = [];
      setState(() {});
    } else {
      final formatted = TextFormatting().formatEnteredText(text);
      await searchHelper.performSearch(formatted, context);
      setState(() {});
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
            // ── Blue header with search bar ─────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.05, size.height * 0.02,
                  size.width * 0.05, size.height * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Members',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Search by name, gaam, or location',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: Colors.white60),
                  ),
                  SizedBox(height: size.height * 0.018),
                  // Search bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextFormField(
                      controller: _controller,
                      textAlignVertical: TextAlignVertical.center,
                      style: GoogleFonts.inter(
                          fontSize: 15, color: Colors.black87),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 15),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: Colors.grey[400], size: 22),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear,
                                    color: Colors.grey[400], size: 18),
                                onPressed: () {
                                  _controller.clear();
                                  _onChanged('');
                                },
                              )
                            : null,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: _onChanged,
                    ),
                  ),
                ],
              ),
            ),

            // ── White results card ──────────────────────────────────
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
    // Idle state
    if (_query.isEmpty) {
      return _EmptyState(
        icon: Icons.people_outline_rounded,
        title: 'Find a member',
        subtitle: 'Start typing to search the directory',
      );
    }

    // Too short
    if (_query.length < 3) {
      return _EmptyState(
        icon: Icons.search_rounded,
        title: 'Keep typing…',
        subtitle: 'Enter at least 3 characters',
        iconColor: Colors.grey[400]!,
      );
    }

    // No results
    if (searchHelper.returnedUsersMap.isEmpty) {
      return _EmptyState(
        icon: Icons.person_search_outlined,
        title: 'No members found',
        subtitle: 'Try a different name, gaam, or city',
        iconColor: Colors.grey[400]!,
      );
    }

    // Results
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: searchHelper.returnedUsersMap.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final user = searchHelper.returnedUsersMap[index];
        return _MemberCard(
          name: user['name'] ?? '',
          gaam: user['gaam'] ?? '',
          city: user['city'] ?? '',
          onTap: () => searchHelper.showPopUp(context, index),
        );
      },
    );
  }
}

// ── Shared widgets ───────────────────────────────────────────────────────────

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

class _MemberCard extends StatelessWidget {
  final String name;
  final String gaam;
  final String city;
  final VoidCallback onTap;

  const _MemberCard({
    required this.name,
    required this.gaam,
    required this.city,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _avatarColor(name);
    final location = [gaam, city].where((s) => s.isNotEmpty).join(' · ');

    return Material(
      color: const Color(0xFFF7F8FA),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.15),
                child: Text(
                  _initials(name),
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        location,
                        style: GoogleFonts.inter(
                            fontSize: 13, color: Colors.grey[500]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey[400], size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
