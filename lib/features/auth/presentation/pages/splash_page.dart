import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Artificial delay for branding :)
    await Future.delayed(const Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;

    // Temporary bypass for testing
    if (mounted) context.go('/home');

    /* 
    if (user == null) {
      context.go('/login');
    } else {
      // Check if user has completed onboarding
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists && (doc.data()?['isOnboardingComplete'] == true)) {
          if (mounted) context.go('/home');
        } else {
          if (mounted) context.go('/onboarding');
        }
      } catch (e) {
        // Fallback or error handling
        if (mounted)
          context.go('/login'); // Force re-login on error safe default
      }
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo placeholder
            const Icon(
              Icons.fitness_center,
              size: 80,
              color: Color(0xFFFF5500),
            ),
            const SizedBox(height: 24),
            Text(
              "FitOne",
              style: GoogleFonts.outfit(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Color(0xFFFF5500)),
          ],
        ),
      ),
    );
  }
}
