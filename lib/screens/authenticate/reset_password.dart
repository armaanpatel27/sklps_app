// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:sklps_app/services/error_handling.dart';
import 'package:sklps_app/shared/custom_dialog_box.dart';
import 'package:sklps_app/shared/size_config.dart';
import 'package:sklps_app/shared/text_filed_validation.dart';

const _kPrimary = Color(0xFF1565C0);

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String _email = "";
  String _error = "";
  bool _isLoading = false;
  bool _linkSent = false;
  int _countdown = 0;
  Timer? _timer;

  CustomDialogBox dialog = CustomDialogBox();
  ErrorHandling errorHandler = ErrorHandling();
  final TextFieldValidation _validate = TextFieldValidation();
  final _globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _countdown = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown--);
      if (_countdown <= 0) t.cancel();
    });
  }

  Future<void> sendLink() async {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    try {
      final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
      await firebaseAuth.sendPasswordResetEmail(email: _email);
      setState(() {
        _linkSent = true;
        _isLoading = false;
      });
      _startCountdown();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = errorHandler.errorHandling(e.code);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                            Icons.lock_reset_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Reset Password',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "We'll send a link to your email",
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
                  padding: EdgeInsets.fromLTRB(size.width * 0.08,
                      size.height * 0.045, size.width * 0.08, size.height * 0.04),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Forgot your password?',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enter your account email and we\'ll send you a link to reset your password.',
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.grey[500], height: 1.5),
                        ),
                        SizedBox(height: size.height * 0.04),

                        // ── Success state ──────────────────────────
                        if (_linkSent)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Colors.green.shade600, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Reset link sent! Check your inbox.',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (_linkSent) SizedBox(height: size.height * 0.025),

                        // ── Email field ────────────────────────────
                        TextFormField(
                          style: GoogleFonts.inter(
                              fontSize: 15, color: Colors.black87),
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          decoration: _inputDecoration(
                              'Email address', Icons.email_outlined),
                          validator: (v) => _validate.validateEmail(v?.trim()),
                          onChanged: (v) =>
                              setState(() => _email = v.trim().toLowerCase()),
                        ),

                        // ── Error ──────────────────────────────────
                        if (_error.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(_error,
                              style: TextStyle(
                                  color: Colors.red[600], fontSize: 13)),
                        ],

                        SizedBox(height: size.height * 0.03),

                        // ── Send button ────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: (_isLoading || _countdown > 0)
                                ? null
                                : () {
                                    if (!_globalKey.currentState!.validate()) {
                                      setState(() => _error = "");
                                      return;
                                    }
                                    sendLink();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kPrimary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  _countdown > 0 ? _kPrimary.withOpacity(0.6) : null,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2.5),
                                  )
                                : Text(
                                    _countdown > 0
                                        ? 'Resend in ${_countdown}s'
                                        : _linkSent
                                            ? 'Resend link'
                                            : 'Send reset link',
                                    style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
      prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[300]!),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[300]!),
      ),
      errorStyle: const TextStyle(fontSize: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
