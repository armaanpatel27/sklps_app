// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/screens/home/normal/user_edit_page.dart';
import 'package:sklps_app/shared/size_config.dart';
import '../../../services/auth.dart';
import '../../../services/error_handling.dart';
import '../../support.dart';

const _kPrimary = Color(0xFF1565C0);

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  void resetUI() => setState(() {});

  String password = "";
  String error = "";

  ErrorHandling errorHandle = ErrorHandling();

  // ── Dialog for Change Email / Delete Account ─────────────────────────────

  showDialogBox(String text,
      Future<dynamic> Function(dynamic, dynamic) fun) {
    const title = 'Delete Account';
    const icon = Icons.delete_outline;
    final iconBg = Colors.red.shade50;
    final iconColor = Colors.red[600]!;
    final btnColor = Colors.red[600]!;
    const btnLabel = 'Delete Account';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (newContext, newSetState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            titlePadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(height: 14),
                Text(title,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color(0xFF1A1A2E)),
                    textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(text,
                    style: GoogleFonts.inter(
                        fontSize: 13, color: Colors.grey[500]),
                    textAlign: TextAlign.center),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogField(
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  obscure: true,
                  onChanged: (v) => setState(() => password = v.trim()),
                ),
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            size: 14, color: Colors.red[600]),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(error,
                              style: TextStyle(
                                  color: Colors.red[600], fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        newSetState(() => error = '');
                      },
                      child: Text('Cancel',
                          style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      onPressed: () async {
                        try {
                          await fun(null, password);
                          Navigator.of(context).pop();
                        } on FirebaseAuthException catch (e) {
                          newSetState(() =>
                              error = errorHandle.errorHandling(e.code));
                        } catch (e) {
                          newSetState(() {
                            error = 'Error #1015. Please try again later';
                          });
                        }
                      },
                      child: Text(btnLabel,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);
    final bool canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: _kPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Blue header ───────────────────────────────────────
            SizedBox(
              height: size.height * 0.28,
              child: Stack(
                children: [
                  // Settings menu — top right
                  Positioned(
                    top: 4,
                    right: 4,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.settings_outlined,
                          color: Colors.white70, size: 24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            Future.delayed(
                                Duration.zero,
                                () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => UserEditPage(
                                            resetUI: resetUI))));
                            break;
                          case 'support':
                            Future.delayed(
                                Duration.zero,
                                () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => Support(
                                            dialogBox: false,
                                            signOutButton: false))));
                            break;
                          case 'signout':
                            authService.signOut();
                            break;
                          case 'delete':
                            Future.delayed(Duration.zero, () => showDialogBox(
                                'Enter your password to delete your account',
                                authService.deleteAccount));
                            break;
                        }
                      },
                      itemBuilder: (_) => [
                        _menuItem('edit', Icons.edit_outlined, 'Edit Info'),
                        _menuItem('support', Icons.help_outline, 'Support'),
                        _menuItem('signout', Icons.logout, 'Sign Out'),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: Colors.red[400]),
                            const SizedBox(width: 10),
                            Text('Delete Account',
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: Colors.red[400])),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  // Avatar + name
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: size.height * 0.065,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: CircleAvatar(
                            radius: size.height * 0.058,
                            backgroundColor: Colors.white,
                            child: Text(
                              _initials(UserData.name),
                              style: GoogleFonts.inter(
                                fontSize: size.height * 0.038,
                                fontWeight: FontWeight.bold,
                                color: _kPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          UserData.name,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (UserData.gaam.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            UserData.gaam,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.white60),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── White card ────────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      size.width * 0.05,
                      size.height * 0.025,
                      size.width * 0.05,
                      100), // bottom pad clears floating nav
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileSection(
                        title: 'Contact',
                        icon: Icons.contacts_outlined,
                        color: _kPrimary,
                        rows: [
                          _ProfileRow(label: 'Email', value: UserData.email, icon: Icons.email_outlined, iconColor: _kPrimary),
                          _ProfileRow(label: 'Phone', value: UserData.phoneNumber, icon: Icons.phone_outlined, iconColor: _kPrimary),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _ProfileSection(
                        title: 'Location',
                        icon: Icons.location_on_outlined,
                        color: const Color(0xFF00897B),
                        rows: [
                          _ProfileRow(label: 'Gaam', value: UserData.gaam, icon: Icons.location_city_outlined, iconColor: const Color(0xFF00897B)),
                          _ProfileRow(label: 'Street', value: UserData.address, icon: Icons.home_outlined, iconColor: const Color(0xFF00897B)),
                          _ProfileRow(label: 'City', value: UserData.city, icon: Icons.location_on_outlined, iconColor: const Color(0xFF00897B)),
                          _ProfileRow(label: 'State', value: UserData.state, icon: Icons.map_outlined, iconColor: const Color(0xFF00897B)),
                          _ProfileRow(label: 'Zip', value: UserData.zip, icon: Icons.pin_drop_outlined, iconColor: const Color(0xFF00897B)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _ProfileSection(
                        title: 'Family',
                        icon: Icons.people_outline,
                        color: const Color(0xFF7B1FA2),
                        rows: [
                          _ProfileRow(label: 'Father', value: UserData.father, icon: Icons.person_outline, iconColor: const Color(0xFF7B1FA2)),
                          _ProfileRow(label: 'Mother', value: UserData.mother, icon: Icons.person_outline, iconColor: const Color(0xFF7B1FA2)),
                          if (UserData.spouse.isNotEmpty)
                            _ProfileRow(label: 'Spouse', value: UserData.spouse, icon: Icons.favorite_outline, iconColor: const Color(0xFFE91E63)),
                          if (UserData.child1.isNotEmpty)
                            _ProfileRow(label: 'Child 1', value: UserData.child1, icon: Icons.child_care_outlined, iconColor: const Color(0xFF7B1FA2)),
                          if (UserData.child2.isNotEmpty)
                            _ProfileRow(label: 'Child 2', value: UserData.child2, icon: Icons.child_care_outlined, iconColor: const Color(0xFF7B1FA2)),
                          if (UserData.child3.isNotEmpty)
                            _ProfileRow(label: 'Child 3', value: UserData.child3, icon: Icons.child_care_outlined, iconColor: const Color(0xFF7B1FA2)),
                          if (UserData.child4.isNotEmpty)
                            _ProfileRow(label: 'Child 4', value: UserData.child4, icon: Icons.child_care_outlined, iconColor: const Color(0xFF7B1FA2)),
                          if (UserData.child5.isNotEmpty)
                            _ProfileRow(label: 'Child 5', value: UserData.child5, icon: Icons.child_care_outlined, iconColor: const Color(0xFF7B1FA2)),
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

// ── Helpers ──────────────────────────────────────────────────────────────────

PopupMenuItem<String> _menuItem(String value, IconData icon, String label) {
  return PopupMenuItem(
    value: value,
    child: Row(children: [
      Icon(icon, size: 18, color: Colors.grey[700]),
      const SizedBox(width: 10),
      Text(label,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[800])),
    ]),
  );
}

class _DialogField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final bool obscure;
  final ValueChanged<String> onChanged;

  const _DialogField(
      {required this.hint, this.icon, this.obscure = false, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      maxLines: 1,
      onChanged: onChanged,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: icon != null ? Icon(icon, size: 18, color: Colors.grey[400]) : null,
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts[0].isEmpty) return '';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_ProfileRow> rows;

  const _ProfileSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.rows,
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
              for (int i = 0; i < rows.length; i++) ...[
                rows[i],
                if (i < rows.length - 1)
                  Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[200],
                      indent: 52,
                      endIndent: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _ProfileRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final display = value.isEmpty ? '—' : value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              display,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: display == '—'
                    ? Colors.grey[400]
                    : const Color(0xFF1A1A2E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
