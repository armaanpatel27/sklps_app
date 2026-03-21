//purpose: verify email UI and controls reset email process in backend
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklps_app/screens/authenticate/verify_screen.dart';
import 'package:sklps_app/screens/error_screen.dart';
import '../../services/auth.dart';

class SendEmail extends StatefulWidget {
  //controls flow of app --> if true then Navigator.pop or else screen sticks after logging in
  final bool isNavigator;

  const SendEmail({Key? key, required this.isNavigator}) : super(key: key);

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  final _auth = AuthService();

  bool _isEmailVerified = false;
  int _countdown = 0;
  Timer? timer;
  Timer? timer2;

  @override
  void initState() {
    _isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!_isEmailVerified) {
      sendEmail();
      _startCountdown();
      timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => checkIfVerified(),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    timer2?.cancel();
    setState(() => _countdown = 30);
    timer2 = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown--);
      if (_countdown <= 0) t.cancel();
    });
  }

  Future? sendEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await user.sendEmailVerification();
    } catch (e) {
      print(e.toString());
      return ErrorScreen(errorCode: "#1004");
    }
  }

  Future? checkIfVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    if (mounted) {
      setState(() {
        _isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmailVerified) {
      timer?.cancel();
      timer2?.cancel();
      return VerifyScreen();
    }

    final size = MediaQuery.of(context).size;
    const kBlue = Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: kBlue,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────
            SizedBox(
              height: size.height * 0.32,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mark_email_unread_outlined,
                          size: 48,
                          color: kBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Verify your email',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── White card ────────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    size.width * 0.07,
                    size.height * 0.04,
                    size.width * 0.07,
                    size.height * 0.04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check your inbox',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We sent a verification link to\n${FirebaseAuth.instance.currentUser?.email ?? ''}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[500],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Status pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBlue.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Waiting for verification…',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: kBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Resend button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _countdown > 0
                              ? null
                              : () {
                                  _startCountdown();
                                  sendEmail();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Verification email sent!',
                                        style: GoogleFonts.inter(),
                                      ),
                                      backgroundColor: kBlue,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBlue,
                            disabledBackgroundColor:
                                kBlue.withOpacity(0.6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _countdown > 0
                                ? 'Resend in ${_countdown}s'
                                : 'Resend Email',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Sign out button
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            timer?.cancel();
                            timer2?.cancel();
                            if (widget.isNavigator) {
                              Navigator.of(context).pop();
                            }
                            await _auth.signOut();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Sign Out',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
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
