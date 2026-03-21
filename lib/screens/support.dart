// ignore_for_file: prefer_const_constructors
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklps_app/services/auth.dart';
import 'package:sklps_app/shared/custom_dialog_box.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/size_config.dart';

const _kPrimary = Color(0xFF1565C0);

class Support extends StatefulWidget {
  final bool dialogBox;
  final bool signOutButton;
  final String? dialogText;

  const Support({
    Key? key,
    required this.dialogBox,
    this.dialogText,
    required this.signOutButton,
  }) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  CustomDialogBox dialogBox = CustomDialogBox();

  @override
  void initState() {
    super.initState();
    if (widget.dialogBox) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await dialogBox.showCustomDialogBox(widget.dialogText!, context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return PopScope(
      canPop: !widget.signOutButton,
      child: Scaffold(
      backgroundColor: _kPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Blue header ─────────────────────────────────────────
            SizedBox(
              height: size.height * 0.24,
              child: Stack(
                children: [
                  if (!widget.signOutButton)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white70, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.headset,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Support',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "We're here to help",
                          style: GoogleFonts.inter(
                              fontSize: 13, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── White card ─────────────────────────────────────────
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
                  padding: EdgeInsets.fromLTRB(size.width * 0.06,
                      size.height * 0.035, size.width * 0.06, size.height * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!widget.signOutButton) ...[
                        // ── Contact ──────────────────────────────────
                        _SectionLabel(label: 'Get in Touch'),
                        const SizedBox(height: 12),
                        _ContactCard(
                          name: 'Armaan Patel',
                          email: 'armaan0427@gmail.com',
                          phone: '630-600-1955',
                        ),
                        const SizedBox(height: 10),
                        _ContactCard(
                          name: 'Chetan Patel',
                          email: 'chetan814@gmail.com',
                          phone: '847-800-6543',
                        ),
                        SizedBox(height: size.height * 0.035),

                        // ── Privacy ───────────────────────────────────
                        _SectionLabel(label: 'Privacy'),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.shield_outlined,
                                  color: _kPrimary, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your privacy matters. Access is restricted to '
                                  'registered samaj members only — your data is '
                                  'never visible to anyone outside the community.',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.55,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      if (widget.signOutButton) ...[
                        SizedBox(height: size.height * 0.04),
                        Text(
                          'Access Restricted',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your email is not registered in the Samaj database. Please contact an administrator to get access.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[500],
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () async => await auth.signOut(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kPrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Sign Out',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

// ── Shared section label ────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1A2E),
        letterSpacing: 0.2,
      ),
    );
  }
}

// ── Contact card ────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const _ContactCard(
      {required this.name, required this.email, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _kPrimary.withOpacity(0.1),
                child: const Icon(Icons.person_outline,
                    color: _kPrimary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.email_outlined,
            text: email,
            onTap: () => launchUrl(Uri(scheme: 'mailto', path: email)),
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.phone_outlined,
            text: phone,
            onTap: () => launchUrl(Uri(scheme: 'tel', path: phone)),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  const _InfoRow({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 15, color: onTap != null ? _kPrimary : Colors.grey[500]),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: onTap != null ? _kPrimary : Colors.grey[600],
              decoration: onTap != null ? TextDecoration.underline : null,
              decorationColor: _kPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
