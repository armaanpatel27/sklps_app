// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sklps_app/screens/authenticate/reset_password.dart';
import 'package:sklps_app/screens/support.dart';
import 'package:sklps_app/services/auth.dart';
import 'package:sklps_app/services/error_handling.dart';
import 'package:sklps_app/shared/size_config.dart';
import 'package:sklps_app/shared/text_filed_validation.dart';

const _kPrimary = Color(0xFF1565C0);

// ── Host screen — owns the toggle state ────────────────────────────────────

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showSignIn = true;

  void _toggle() => setState(() => _showSignIn = !_showSignIn);

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
            // ── Static blue header (does NOT animate) ──────────────
            SizedBox(
              height: size.height * 0.38,
              child: Stack(
                children: [
                  Positioned(
                    top: 4,
                    right: 8,
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.circleQuestion,
                          color: Colors.white38, size: 20),
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => Support(
                                  dialogBox: false, signOutButton: false))),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/sklps_logo.png',
                            height: size.height * 0.2,
                            width: size.height * 0.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'SKLPS',
                          style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Animated white card ────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.06),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeOutCubic)),
                      child: child,
                    ),
                  );
                },
                child: _showSignIn
                    ? _SignInCard(
                        key: const ValueKey('signin'), onToggle: _toggle)
                    : _RegisterCard(
                        key: const ValueKey('register'), onToggle: _toggle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sign-in card ────────────────────────────────────────────────────────────

class _SignInCard extends StatefulWidget {
  final VoidCallback onToggle;
  const _SignInCard({Key? key, required this.onToggle}) : super(key: key);
  @override
  State<_SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends State<_SignInCard> {
  String _email = "";
  String _password = "";
  String _error = "";
  bool _obscurePassword = true;
  bool _isLoading = false;

  final TextFieldValidation _validate = TextFieldValidation();
  final _globalKey = GlobalKey<FormState>();
  final ErrorHandling _errorHandle = ErrorHandling();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;

    return Container(
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
        padding: EdgeInsets.fromLTRB(size.width * 0.08, size.height * 0.045,
            size.width * 0.08, size.height * 0.04),
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Sign in to continue',
                style:
                    GoogleFonts.inter(fontSize: 14, color: Colors.grey[400]),
              ),
              SizedBox(height: size.height * 0.035),

              // Email
              TextFormField(
                style: GoogleFonts.inter(fontSize: 15, color: Colors.black87),
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                decoration: _inputDecoration('Email', Icons.email_outlined),
                validator: (v) => _validate.validateEmail(v?.trim()),
                onChanged: (v) =>
                    setState(() => _email = v.trim().toLowerCase()),
              ),
              const SizedBox(height: 14),

              // Password
              TextFormField(
                style: GoogleFonts.inter(fontSize: 15, color: Colors.black87),
                obscureText: _obscurePassword,
                maxLines: 1,
                decoration: _inputDecoration(
                  'Password',
                  Icons.lock_outline,
                  suffix: IconButton(
                    splashRadius: 18,
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) => _validate.validatePassword(v?.trim()),
                onChanged: (v) => setState(() => _password = v.trim()),
              ),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ResetPasswordScreen())),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: _kPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              // Error
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(_error,
                    style: TextStyle(color: Colors.red[600], fontSize: 13)),
                const SizedBox(height: 8),
              ],

              SizedBox(height: size.height * 0.02),

              // Sign In button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (!_globalKey.currentState!.validate()) {
                            setState(() => _error = "");
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                            _error = "";
                          });
                          try {
                            await authService.signInWithEmailAndPassword(
                                _email, _password);
                          } on FirebaseAuthException catch (e) {
                            setState(
                                () => _error = _errorHandle.errorHandling(e.code));
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    foregroundColor: Colors.white,
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
                      : Text('Sign In',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                ),
              ),

              SizedBox(height: size.height * 0.03),

              // Register link
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Don't have an account? ",
                        style: GoogleFonts.inter(
                            fontSize: 14, color: Colors.grey[500])),
                    GestureDetector(
                      onTap: widget.onToggle,
                      child: Text('Register',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: _kPrimary,
                              fontWeight: FontWeight.w600)),
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

  InputDecoration _inputDecoration(String hint, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
      prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
      suffixIcon: suffix,
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

// ── Register card ───────────────────────────────────────────────────────────

class _RegisterCard extends StatefulWidget {
  final VoidCallback onToggle;
  const _RegisterCard({Key? key, required this.onToggle}) : super(key: key);
  @override
  State<_RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<_RegisterCard> {
  String _email = "";
  String _password = "";
  String _error = "";
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final TextFieldValidation _validate = TextFieldValidation();
  final _globalKey = GlobalKey<FormState>();
  final ErrorHandling _errorHandle = ErrorHandling();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;

    return Container(
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
        padding: EdgeInsets.fromLTRB(size.width * 0.08, size.height * 0.04,
            size.width * 0.08, size.height * 0.04),
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create account',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Sign up to get started',
                style:
                    GoogleFonts.inter(fontSize: 14, color: Colors.grey[400]),
              ),
              SizedBox(height: size.height * 0.03),

              // Email
              TextFormField(
                style: GoogleFonts.inter(fontSize: 15, color: Colors.black87),
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                decoration: _inputDecoration('Email', Icons.email_outlined),
                validator: (v) => _validate.validateEmail(v?.trim()),
                onChanged: (v) =>
                    setState(() => _email = v.trim().toLowerCase()),
              ),
              const SizedBox(height: 14),

              // Password
              TextFormField(
                style: GoogleFonts.inter(fontSize: 15, color: Colors.black87),
                obscureText: _obscurePassword,
                maxLines: 1,
                decoration: _inputDecoration(
                  'Password',
                  Icons.lock_outline,
                  suffix: IconButton(
                    splashRadius: 18,
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) => _validate.validatePassword(v?.trim()),
                onChanged: (v) => setState(() => _password = v.trim()),
              ),
              const SizedBox(height: 14),

              // Confirm password
              TextFormField(
                style: GoogleFonts.inter(fontSize: 15, color: Colors.black87),
                obscureText: _obscureConfirm,
                maxLines: 1,
                decoration: _inputDecoration(
                  'Confirm Password',
                  Icons.lock_outline,
                  suffix: IconButton(
                    splashRadius: 18,
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (v) =>
                    _validate.validateConfirmPassword(v?.trim(), _password),
              ),

              // Error
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(_error,
                    style: TextStyle(color: Colors.red[600], fontSize: 13)),
              ],

              SizedBox(height: size.height * 0.03),

              // Register button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (!_globalKey.currentState!.validate()) {
                            setState(() => _error = "");
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                            _error = "";
                          });
                          try {
                            await authService.registerWithEmailAndPassword(
                                _email, _password);
                          } on FirebaseAuthException catch (e) {
                            setState(() =>
                                _error = _errorHandle.errorHandling(e.code));
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    foregroundColor: Colors.white,
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
                      : Text('Register',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                ),
              ),

              SizedBox(height: size.height * 0.025),

              // Sign in link
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Already have an account? ',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: Colors.grey[500])),
                    GestureDetector(
                      onTap: widget.onToggle,
                      child: Text('Sign In',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: _kPrimary,
                              fontWeight: FontWeight.w600)),
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

  InputDecoration _inputDecoration(String hint, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
      prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
      suffixIcon: suffix,
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
