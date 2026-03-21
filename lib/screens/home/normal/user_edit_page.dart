// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/services/edit_user_info.dart';

const _kPrimary = Color(0xFF1565C0);
const _kTeal = Color(0xFF00897B);
const _kPurple = Color(0xFF7B1FA2);

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts[0].isEmpty) return '?';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

class UserEditPage extends StatefulWidget {
  final VoidCallback resetUI;

  const UserEditPage({Key? key, required this.resetUI}) : super(key: key);

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  bool _isLoading = false;

  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _gaam;
  late final TextEditingController _address;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _zip;
  late final TextEditingController _father;
  late final TextEditingController _mother;
  late final TextEditingController _spouse;
  late final TextEditingController _child1;
  late final TextEditingController _child2;
  late final TextEditingController _child3;
  late final TextEditingController _child4;
  late final TextEditingController _child5;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: UserData.name);
    _email = TextEditingController(text: UserData.email);
    _phone = TextEditingController(text: UserData.phoneNumber);
    _gaam = TextEditingController(text: UserData.gaam);
    _address = TextEditingController(text: UserData.address);
    _city = TextEditingController(text: UserData.city);
    _state = TextEditingController(text: UserData.state);
    _zip = TextEditingController(text: UserData.zip);
    _father = TextEditingController(text: UserData.father);
    _mother = TextEditingController(text: UserData.mother);
    _spouse = TextEditingController(text: UserData.spouse);
    _child1 = TextEditingController(text: UserData.child1);
    _child2 = TextEditingController(text: UserData.child2);
    _child3 = TextEditingController(text: UserData.child3);
    _child4 = TextEditingController(text: UserData.child4);
    _child5 = TextEditingController(text: UserData.child5);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _gaam.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _zip.dispose();
    _father.dispose();
    _mother.dispose();
    _spouse.dispose();
    _child1.dispose();
    _child2.dispose();
    _child3.dispose();
    _child4.dispose();
    _child5.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Save Changes',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text('Are you sure you want to save these changes?',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Confirm', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);

    final editInfo = EditInfo(resetUI: widget.resetUI);
    editInfo.newName = _name.text.trim();
    editInfo.newEmail = _email.text.trim();
    editInfo.newPhoneNumber = _phone.text.trim();
    editInfo.newGaam = _gaam.text.trim();
    editInfo.newAddress = _address.text.trim();
    editInfo.newCity = _city.text.trim();
    editInfo.newState = _state.text.trim();
    editInfo.newZip = _zip.text.trim();
    editInfo.newFather = _father.text.trim();
    editInfo.newMother = _mother.text.trim();
    editInfo.newSpouse = _spouse.text.trim();
    editInfo.newChild1 = _child1.text.trim();
    editInfo.newChild2 = _child2.text.trim();
    editInfo.newChild3 = _child3.text.trim();
    editInfo.newChild4 = _child4.text.trim();
    editInfo.newChild5 = _child5.text.trim();

    await editInfo.submitUserChanges(context);
    widget.resetUI();

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final name = _name.text.isNotEmpty ? _name.text : UserData.name;
    final gaam = UserData.gaam;
    final city = UserData.city;
    final location = [gaam, city].where((s) => s.isNotEmpty).join(' · ');

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
                  // Back + Save row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      if (_isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      else
                        GestureDetector(
                          onTap: _submit,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_rounded,
                                    size: 16, color: _kPrimary),
                                const SizedBox(width: 5),
                                Text(
                                  'Save',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _kPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
                            backgroundColor: Colors.white,
                            child: Text(
                              _initials(name),
                              style: GoogleFonts.inter(
                                fontSize: size.height * 0.032,
                                fontWeight: FontWeight.bold,
                                color: _kPrimary,
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
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Editing mode',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: Colors.white70),
                          ),
                        ),
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
                      _EditSection(
                        title: 'Contact',
                        icon: Icons.contacts_outlined,
                        color: _kPrimary,
                        fields: [
                          _EditField(label: 'Name', icon: Icons.person_outline, iconColor: _kPrimary, controller: _name),
                          _EditField(label: 'Email', icon: Icons.email_outlined, iconColor: _kPrimary, controller: _email),
                          _EditField(label: 'Phone', icon: Icons.phone_outlined, iconColor: _kPrimary, controller: _phone),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _EditSection(
                        title: 'Location',
                        icon: Icons.location_on_outlined,
                        color: _kTeal,
                        fields: [
                          _EditField(label: 'Gaam', icon: Icons.location_city_outlined, iconColor: _kTeal, controller: _gaam),
                          _EditField(label: 'Street', icon: Icons.home_outlined, iconColor: _kTeal, controller: _address),
                          _EditField(label: 'City', icon: Icons.location_on_outlined, iconColor: _kTeal, controller: _city),
                          _EditField(label: 'State', icon: Icons.map_outlined, iconColor: _kTeal, controller: _state),
                          _EditField(label: 'Zip', icon: Icons.pin_drop_outlined, iconColor: _kTeal, controller: _zip),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _EditSection(
                        title: 'Family',
                        icon: Icons.people_outline,
                        color: _kPurple,
                        fields: [
                          _EditField(label: 'Father', icon: Icons.person_outline, iconColor: _kPurple, controller: _father),
                          _EditField(label: 'Mother', icon: Icons.person_outline, iconColor: _kPurple, controller: _mother),
                          _EditField(label: 'Spouse', icon: Icons.favorite_outline, iconColor: const Color(0xFFE91E63), controller: _spouse),
                          _EditField(label: 'Child 1', icon: Icons.child_care_outlined, iconColor: _kPurple, controller: _child1),
                          _EditField(label: 'Child 2', icon: Icons.child_care_outlined, iconColor: _kPurple, controller: _child2),
                          _EditField(label: 'Child 3', icon: Icons.child_care_outlined, iconColor: _kPurple, controller: _child3),
                          _EditField(label: 'Child 4', icon: Icons.child_care_outlined, iconColor: _kPurple, controller: _child4),
                          _EditField(label: 'Child 5', icon: Icons.child_care_outlined, iconColor: _kPurple, controller: _child5),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: _isLoading ? null : _submit,
                          child: Text(
                            'Save Changes',
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                                fontSize: 15, color: Colors.grey[500]),
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

// ── Data model ────────────────────────────────────────────────────────────────

class _EditField {
  final String label;
  final IconData icon;
  final Color iconColor;
  final TextEditingController controller;

  const _EditField({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.controller,
  });
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _EditSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_EditField> fields;

  const _EditSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.fields,
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
              for (int i = 0; i < fields.length; i++) ...[
                _EditRow(field: fields[i]),
                if (i < fields.length - 1)
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

class _EditRow extends StatelessWidget {
  final _EditField field;
  const _EditRow({required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: field.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(field.icon, size: 16, color: field.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: field.controller,
              style: GoogleFonts.inter(
                  fontSize: 14, color: const Color(0xFF1A1A2E)),
              decoration: InputDecoration(
                labelText: field.label,
                labelStyle:
                    GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: _kPrimary, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
