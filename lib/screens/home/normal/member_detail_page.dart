// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const _kPrimary = Color(0xFF1565C0);
const _kTeal = Color(0xFF00897B);
const _kPurple = Color(0xFF7B1FA2);

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

class MemberDetailPage extends StatelessWidget {
  final Map<dynamic, dynamic> user;

  const MemberDetailPage({Key? key, required this.user}) : super(key: key);

  String _v(String key) => user[key]?.toString() ?? '';

  Future<void> _launch(String uri) async {
    try {
      await launchUrl(Uri.parse(uri));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final name = _v('name');
    final email = _v('email');
    final phone = _v('phoneNumber');
    final gaam = _v('gaam');
    final city = _v('city');
    final address = _v('address');
    final state = _v('state');
    final zip = _v('zip');
    final father = _v('father');
    final mother = _v('mother');
    final spouse = _v('spouse');
    final child1 = _v('child1');
    final child2 = _v('child2');
    final child3 = _v('child3');
    final child4 = _v('child4');
    final child5 = _v('child5');

    final location = [gaam, city].where((s) => s.isNotEmpty).join(' · ');
    final color = _avatarColor(name);

    return Scaffold(
      backgroundColor: _kPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Blue header ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.05, size.height * 0.015,
                  size.width * 0.05, size.height * 0.028),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  SizedBox(height: size.height * 0.022),
                  // Avatar + name
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: size.height * 0.055,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: CircleAvatar(
                            radius: size.height * 0.048,
                            backgroundColor: color.withOpacity(0.15),
                            child: Text(
                              _initials(name),
                              style: GoogleFonts.inter(
                                fontSize: size.height * 0.032,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.012),
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (location.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            location,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ],
                    ),
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      size.width * 0.05, size.height * 0.025,
                      size.width * 0.05, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Section(
                        title: 'Contact',
                        icon: Icons.contacts_outlined,
                        color: _kPrimary,
                        children: [
                          _Row(
                            label: 'Email',
                            value: email,
                            icon: Icons.email_outlined,
                            iconColor: _kPrimary,
                            onTap: email.isNotEmpty
                                ? () => _launch('mailto:$email')
                                : null,
                          ),
                          _Row(
                            label: 'Phone',
                            value: phone,
                            icon: Icons.phone_outlined,
                            iconColor: _kPrimary,
                            onTap: phone.isNotEmpty
                                ? () => _launch('tel:+1-$phone')
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _Section(
                        title: 'Location',
                        icon: Icons.location_on_outlined,
                        color: _kTeal,
                        children: [
                          _Row(label: 'Gaam', value: gaam, icon: Icons.location_city_outlined, iconColor: _kTeal),
                          _Row(label: 'Street', value: address, icon: Icons.home_outlined, iconColor: _kTeal),
                          _Row(label: 'City', value: city, icon: Icons.location_on_outlined, iconColor: _kTeal),
                          _Row(label: 'State', value: state, icon: Icons.map_outlined, iconColor: _kTeal),
                          _Row(label: 'Zip', value: zip, icon: Icons.pin_drop_outlined, iconColor: _kTeal),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _Section(
                        title: 'Family',
                        icon: Icons.people_outline,
                        color: _kPurple,
                        children: [
                          _Row(label: 'Father', value: father, icon: Icons.person_outline, iconColor: _kPurple),
                          _Row(label: 'Mother', value: mother, icon: Icons.person_outline, iconColor: _kPurple),
                          if (spouse.isNotEmpty)
                            _Row(label: 'Spouse', value: spouse, icon: Icons.favorite_outline, iconColor: const Color(0xFFE91E63)),
                          if (child1.isNotEmpty)
                            _Row(label: 'Child 1', value: child1, icon: Icons.child_care_outlined, iconColor: _kPurple),
                          if (child2.isNotEmpty)
                            _Row(label: 'Child 2', value: child2, icon: Icons.child_care_outlined, iconColor: _kPurple),
                          if (child3.isNotEmpty)
                            _Row(label: 'Child 3', value: child3, icon: Icons.child_care_outlined, iconColor: _kPurple),
                          if (child4.isNotEmpty)
                            _Row(label: 'Child 4', value: child4, icon: Icons.child_care_outlined, iconColor: _kPurple),
                          if (child5.isNotEmpty)
                            _Row(label: 'Child 5', value: child5, icon: Icons.child_care_outlined, iconColor: _kPurple),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[200],
                      indent: 52),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _Row({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final display = value.isEmpty ? '—' : value;
    final isLink = onTap != null && value.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                display,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isLink ? _kPrimary : const Color(0xFF1A1A2E),
                  decoration: isLink ? TextDecoration.underline : null,
                ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
