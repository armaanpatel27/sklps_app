import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklps_app/services/access_data.dart';
import 'package:sklps_app/shared/text_filed_validation.dart';
import '../services/error_handling.dart';

const _kPrimary = Color(0xFF1565C0);

// access to different types of dialog boxes
class CustomDialogBox {
  AccessData accessData = AccessData();
  ErrorHandling errorHandle = ErrorHandling();

  // ── Generic alert dialog ──────────────────────────────────────────────────

  Future<void> showCustomDialogBox(String text, BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.warning_amber_rounded,
                    color: Colors.orange[700], size: 30),
              ),
              const SizedBox(height: 14),
              Text(
                'Alert',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF1A1A2E)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            text,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Add new user dialog ───────────────────────────────────────────────────

  Future<void> addUserDialogBox(String text, BuildContext context) {
    String userName = '';
    String userEmail = '';
    String error = '';

    final TextFieldValidation _validator = TextFieldValidation();
    final _globalKey = GlobalKey<FormState>();

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
                  decoration: BoxDecoration(
                    color: _kPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add_outlined,
                      color: _kPrimary, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  'Add New Member',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF1A1A2E)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter the new member\'s details below',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: Form(
              key: _globalKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Field(
                    hint: 'Full Name',
                    icon: Icons.person_outline,
                    validator: (v) => _validator.validateName(v),
                    onChanged: (v) => userName = v.trim(),
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    hint: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => _validator.validateEmail(v?.trim()),
                    onChanged: (v) => userEmail = v.trim(),
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
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
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
                        backgroundColor: _kPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      onPressed: () async {
                        if (!_globalKey.currentState!.validate()) {
                          newSetState(() => error = '');
                          return;
                        }
                        try {
                          await accessData.addDocument(userName, userEmail);
                          Navigator.of(context).pop();
                        } catch (e) {
                          newSetState(() {
                            if (e.toString() == 'Exception: email-in-use') {
                              error = 'Email is already in use';
                            } else {
                              error = 'Error #1017. Please try again later';
                            }
                          });
                        }
                      },
                      child: Text('Add Member',
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
}

// ── Local field widget ────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String> onChanged;

  const _Field({
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        errorStyle: TextStyle(fontSize: 12, color: Colors.red[600]),
      ),
    );
  }
}
