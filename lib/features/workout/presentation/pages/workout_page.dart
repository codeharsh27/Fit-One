import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:tandurast/core/data/workout_repository.dart';
import 'package:tandurast/core/data/models/workout_models.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  WorkoutSession? _activeDraft;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDraft();
  }

  Future<void> _checkDraft() async {
    setState(() => _isLoading = true);
    final draft = await WorkoutRepository().getDraft();
    if (mounted) {
      setState(() {
        _activeDraft = draft;
        _isLoading = false;
      });
    }
  }

  Future<void> _onStartRoutine(String title, List<String> exercises) async {
    final draft = await WorkoutRepository().getDraft();

    if (draft != null) {
      // Draft exists
      if (!mounted) return;
      _showDraftConflictDialog(draft, title, exercises);
    } else {
      // Start normally
      await _navigateToActiveWorkout(title, exercises);
      _checkDraft(); // Refresh after return
    }
  }

  Future<void> _navigateToActiveWorkout(
    String? title,
    List<String>? exercises,
  ) async {
    await context.push(
      '/workout/active',
      extra: title != null ? {'title': title, 'exercises': exercises} : null,
    );
  }

  void _showDraftConflictDialog(
    WorkoutSession draft,
    String newTitle,
    List<String> newExercises,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text(
          'Workout In Progress',
          style: GoogleFonts.outfit(color: Colors.white),
        ),
        content: Text(
          'Your "${draft.title}" plan is waiting for you. Do you want to resume it or discard it and start "$newTitle"?',
          style: GoogleFonts.plusJakartaSans(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await WorkoutRepository().clearDraft();
              if (mounted) {
                await _navigateToActiveWorkout(newTitle, newExercises);
                _checkDraft();
              }
            },
            child: Text(
              'Discard',
              style: GoogleFonts.plusJakartaSans(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _navigateToActiveWorkout(
                null,
                null,
              ); // Null extra loads draft
              _checkDraft();
            },
            child: Text(
              'Resume',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFFF5500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Start Empty Workout Logic (existing) ---
  Future<void> _onStartEmptyWorkout() async {
    final draft = await WorkoutRepository().getDraft();

    if (draft != null && mounted) {
      _showDraftConflictDialog(
        draft,
        "Empty Workout",
        [],
      ); // Or separate customized dialog
    } else {
      if (mounted) {
        await context.push('/workout/active');
        _checkDraft();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF5500)),
            )
          : Stack(
              children: [
                // Background Header Gradient (Subtle)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF1C1C1E).withOpacity(0.5),
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Scrollable Content
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    60,
                    20,
                    100,
                  ), // Top padding for Custom App Bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Custom App Bar Area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Workout',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => context.go('/workout/history'),
                                icon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () => context.go('/workout/stats'),
                                icon: const Icon(
                                  Icons.bar_chart_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 1. Start Empty Workout (Hero Card)
                      GestureDetector(
                        onTap: _onStartEmptyWorkout,
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF1C1C1E),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=800&auto=format&fit=crop',
                                    fit: BoxFit.cover,
                                    memCacheWidth: 800,
                                    placeholder: (context, url) => Container(
                                      color: const Color(0xFF2C2C2E),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: const Color(0xFF2C2C2E),
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF5500),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Start Empty Workout',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 2. Routines Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quick Routines',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/workout/new-routine'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C1C1E),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add,
                                    size: 14,
                                    color: Color(0xFFFF5500),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "New Routine",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 3. Routine Cards with Images
                      _buildRoutineCard(
                        title: 'Legs and Abs',
                        subtitle: 'Squat, Leg Curl, Leg Extension...',
                        image:
                            'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=600&auto=format&fit=crop',
                      ),
                      const SizedBox(height: 16),
                      _buildRoutineCard(
                        title: 'Back and Biceps',
                        subtitle: 'Cable Row, Lat Pulldown, Curls...',
                        image:
                            'https://images.unsplash.com/photo-1603287681836-b174ce5074c2?q=80&w=600&auto=format&fit=crop',
                      ),
                      const SizedBox(height: 16),
                      _buildRoutineCard(
                        title: 'Chest Day', // Shortened title for better UI fit
                        subtitle: 'Bench Press, Flys, Pushdowns...',
                        image:
                            'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=600&auto=format&fit=crop',
                        fullTitle: 'Chest Shoulders and Triceps',
                      ),
                    ],
                  ),
                ),

                // Sticky Bottom "Resume" Bar
                if (_activeDraft != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        border: Border(top: BorderSide(color: Colors.white12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon & Text
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5500).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.fitness_center,
                              color: const Color(0xFFFF5500),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _activeDraft!.title.isNotEmpty
                                      ? _activeDraft!.title
                                      : "Active Workout",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "In Progress",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.amber,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Buttons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  // Discard
                                  await WorkoutRepository().clearDraft();
                                  _checkDraft();
                                },
                                child: Text(
                                  "Discard",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  // Resume
                                  await _navigateToActiveWorkout(null, null);
                                  _checkDraft();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5500),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 0,
                                  ),
                                ),
                                child: Text(
                                  "Resume",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildRoutineCard({
    required String title,
    required String subtitle,
    required String image,
    String? fullTitle,
  }) {
    // Determine exercises based on title
    // This logic is kept from before, just UI wrapped
    String actualTitle = fullTitle ?? title;

    return GestureDetector(
      onTap: () {
        List<String> exercises = [];
        if (actualTitle.contains("Legs")) {
          exercises = [
            'Squat (Barbell)',
            'Seated Leg Curl (Machine)',
            'Leg Extension (Machine)',
            'Seated Calf Raise',
            'Plank',
          ];
        } else if (actualTitle.contains("Back")) {
          exercises = [
            'Seated Cable Row - Bar Grip',
            'Lat Pulldown (Cable)',
            'Bicep Curl (Cable)',
            'Back Extension (Hyperextension)',
            'Seated Row (Machine)',
            'Hammer Curl (Dumbbell)',
          ];
        } else if (actualTitle.contains("Chest")) {
          exercises = [
            'Bench Press (Barbell)',
            'Shoulder Press (Dumbbell)',
            'Single Arm Tricep Extension (Dumbbell)',
            'Incline Bench Press (Dumbbell)',
            'Lateral Raise (Dumbbell)',
            'Triceps Rope Pushdown',
          ];
        }
        _onStartRoutine(actualTitle, exercises);
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1C1C1E),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  memCacheWidth: 800,
                  placeholder: (context, url) =>
                      Container(color: const Color(0xFF1C1C1E)),
                  errorWidget: (context, url, error) =>
                      Container(color: const Color(0xFF1C1C1E)),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: Colors.grey[300],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
