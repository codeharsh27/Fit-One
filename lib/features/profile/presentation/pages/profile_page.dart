import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  late Box _settingsBox;

  // Local State for immediate UI updates
  bool _notificationsEnabled = true;
  String _language = "English";
  String _units = "Metric (kg)";

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _settingsBox = Hive.box('settings');
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _notificationsEnabled = _settingsBox.get(
        'notifications',
        defaultValue: true,
      );
      _language = _settingsBox.get('language', defaultValue: "English");
      _units = _settingsBox.get('units', defaultValue: "Metric (kg)");
      // Reload user to ensure latest displayName
      _user?.reload().then((_) {
        if (mounted) setState(() => _user = FirebaseAuth.instance.currentUser);
      });
    });
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
    _loadSettings();
  }

  Future<void> _editProfile() async {
    await context.push('/profile/edit');
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _user?.displayName ?? "Fitness Enthusiast";
    final email = _user?.email ?? "user@example.com";
    final photoUrl = _user?.photoURL;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: "Edit Profile",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFF5500),
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : const NetworkImage(
                                "https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60",
                              ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      "Free Member",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF5500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Section 1: Settings
            _buildSectionTitle("Settings"),
            const SizedBox(height: 16),
            _buildSettingsContainer([
              _buildOption(
                icon: _notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                title: "Notifications",
                onTap: () {
                  _updateSetting('notifications', !_notificationsEnabled);
                  // Need to setState instantly for switch animation if I used a real switch,
                  // but since I'm re-building the whole row, _loadSettings handles it.
                },
                isToggle: true,
                toggleValue: _notificationsEnabled,
              ),
              _buildDivider(),
              _buildOption(
                icon: Icons.language,
                title: "Language",
                value: _language,
                onTap: () => _showSelectionSheet(
                  "Language",
                  ["English", "Spanish", "French", "German"],
                  _language,
                  (val) {
                    _updateSetting('language', val);
                  },
                ),
              ),
              _buildDivider(),
              _buildOption(
                icon: Icons.scale_outlined,
                title: "Units",
                value: _units,
                onTap: () => _showSelectionSheet(
                  "Units",
                  ["Metric (kg)", "Imperial (lbs)"],
                  _units,
                  (val) {
                    _updateSetting('units', val);
                  },
                ),
              ),
            ]),
            const SizedBox(height: 32),

            // Section 2: Legal & Support
            _buildSectionTitle("Support & Legal"),
            const SizedBox(height: 16),
            _buildSettingsContainer([
              _buildOption(
                icon: Icons.help_outline,
                title: "Help Center",
                onTap: _showHelpSheet,
              ),
              _buildDivider(),
              _buildOption(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy Policy",
                onTap: () => _showLegalBottomSheeet(
                  "Privacy Policy",
                  _privacyPolicyText,
                ),
              ),
              _buildDivider(),
              _buildOption(
                icon: Icons.description_outlined,
                title: "Terms & Conditions",
                onTap: () =>
                    _showLegalBottomSheeet("Terms & Conditions", _termsText),
              ),
            ]),
            const SizedBox(height: 40),

            // Logout
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // Clear core settings if needed, but usually we keep them.
                  if (mounted) {
                    context.go('/home'); // Go to onboarding/home
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFF1C1C1E)),
                  ),
                ),
                child: Text(
                  "Log Out",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF453A), // Red
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Version 1.0.0",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey[800],
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSettingsContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    String? value,
    required VoidCallback onTap,
    bool isToggle = false,
    bool toggleValue = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (value != null && !isToggle)
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(width: 8),
              if (isToggle)
                Switch(
                  value: toggleValue,
                  onChanged: (val) => onTap(),
                  activeColor: const Color(0xFFFF5500),
                  activeTrackColor: const Color(0x4DFF5500),
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[800],
                )
              else
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 14,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: Colors.white10,
      indent: 54, // Align with text
    );
  }

  void _showSelectionSheet(
    String title,
    List<String> options,
    String selected,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map(
              (option) => ListTile(
                title: Text(
                  option,
                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                ),
                trailing: option == selected
                    ? const Icon(Icons.check, color: Color(0xFFFF5500))
                    : null,
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showHelpSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Help Center",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildFaqItem(
              "How do I create a routine?",
              "Go to the Workout tab and tap 'New Routine' or 'Start Empty Workout'.",
            ),
            _buildFaqItem(
              "Can I use this offline?",
              "Yes, your active workouts are saved locally, but you need internet for Explore images.",
            ),
            _buildFaqItem(
              "How to delete my account?",
              "Please contact support@tandurast.com to request data deletion.",
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email, color: Color(0xFFFF5500)),
                  const SizedBox(width: 12),
                  Text(
                    "support@tandurast.com",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String q, String a) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            q,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            a,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showLegalBottomSheeet(String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  content,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey[300],
                    height: 1.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Mock Legal Text ---
  static const String _privacyPolicyText = """
**Privacy Policy**

Last updated: January 01, 2025

This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.

**Information Collection and Use**

We gather user data to improve workout recommendations and track progress. This includes:
- Personal Data: Name, Email.
- Usage Data: Workout logs, duration, and exercise history.

**Data Security**

The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure.

**Contact Us**

If you have any questions about this Privacy Policy, You can contact us:
- By email: support@tandurast.com
""";

  static const String _termsText = """
**Terms and Conditions**

Last updated: January 01, 2025

**1. Acceptance of Terms**
By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.

**2. Use of Service**
This app is for personal fitness tracking. You agree not to misuse the services.

**3. Disclaimer**
The fitness information provided is for educational purposes only. Consult a physician before starting any workout program.

**4. Account Security**
You are responsible for safeguarding the password that you use to access the Service.

**5. Changes to Terms**
We reserve the right to modify these terms at any time.
""";
}
