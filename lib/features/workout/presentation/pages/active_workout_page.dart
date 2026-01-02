import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tandurast/core/data/models/workout_models.dart';
import 'package:tandurast/core/data/workout_repository.dart';
import 'package:tandurast/features/workout/data/explore_data.dart';

// --- Local Models for Active Session State ---
class ActiveSet {
  final int setNumber;
  String weight;
  String reps;
  bool isCompleted;

  ActiveSet({
    required this.setNumber,
    this.weight = "0",
    this.reps = "0",
    this.isCompleted = false,
  });
}

class ActiveExercise {
  final String name;
  final List<ActiveSet> sets;
  final String? note; // Added note field
  final int defaultRestTime;

  ActiveExercise({
    required this.name,
    required this.sets,
    this.note,
    this.defaultRestTime = 90,
  });
}

class ActiveWorkoutPage extends StatefulWidget {
  const ActiveWorkoutPage({super.key});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  // Session State
  DateTime? _startTime;
  Duration _duration = Duration.zero;
  Timer? _timer;
  final List<ActiveExercise> _exercises = [];
  String _workoutTitle = "Active Workout";

  // Rest Timer State
  Timer? _restTimer;
  final ValueNotifier<int> _restTimerNotifier = ValueNotifier(0);

  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    // Defer processing extra data until after build to access context safely if needed,
    // though initState is safe for basic property access.
    // However, GoRouterState is best accessed in didChangeDependencies or post-frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWorkout();
    });
    _startTimer();
  }

  void _initializeWorkout() {
    final extra = GoRouterState.of(context).extra;
    if (extra != null && extra is Map<String, dynamic>) {
      setState(() {
        _workoutTitle = extra['title'] ?? "Active Workout";
        final exercisesList = extra['exercises'];

        _exercises.clear();

        if (exercisesList is List) {
          for (var item in exercisesList) {
            if (item is RoutineExercise) {
              // Parse "8-12" -> "8"
              String reps = item.reps.split('-').first.trim();
              // Parse "60 kg" -> "60"
              String weight = item.weight.replaceAll(RegExp(r'[a-zA-Z\s]'), '');
              int setsCount = int.tryParse(item.sets) ?? 3;

              _exercises.add(
                ActiveExercise(
                  name: item.name,
                  defaultRestTime: item.restTime,
                  sets: List.generate(
                    setsCount,
                    (index) => ActiveSet(
                      setNumber: index + 1,
                      weight: weight,
                      reps: reps,
                    ),
                  ),
                ),
              );
            } else if (item is String) {
              _exercises.add(
                ActiveExercise(
                  name: item,
                  sets: [
                    ActiveSet(setNumber: 1, weight: "0", reps: "0"),
                    ActiveSet(setNumber: 2, weight: "0", reps: "0"),
                    ActiveSet(setNumber: 3, weight: "0", reps: "0"),
                  ],
                ),
              );
            }
          }
        }
      });
    } else {
      _checkAndLoadDraft();
    }
  }

  Future<void> _checkAndLoadDraft() async {
    final draft = await WorkoutRepository().getDraft();
    if (draft != null && mounted) {
      setState(() {
        _workoutTitle = draft.title;
        // Restore exercises
        _exercises.clear();
        for (var e in draft.exercises) {
          _exercises.add(
            ActiveExercise(
              name: e.name,
              sets: e.sets
                  .map(
                    (s) => ActiveSet(
                      setNumber: s.setNum,
                      reps: s.reps,
                      weight: s.weight.replaceAll(RegExp(r'[a-zA-Z\s]'), ''),
                      isCompleted: s.isCompleted,
                    ),
                  )
                  .toList(),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    if (!_isFinished && _exercises.isNotEmpty) {
      _saveDraft();
    }
    super.dispose();
  }

  void _saveDraft() {
    final draft = WorkoutSession(
      title: _workoutTitle,
      duration: _formattedDuration,
      volume: "0 kg",
      exercises: _exercises
          .map(
            (e) => ExerciseLog(
              e.name,
              e.sets
                  .map(
                    (s) => SetLog(
                      s.setNumber,
                      s.reps,
                      s.weight,
                      isCompleted: s.isCompleted,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
      date: DateTime.now(),
      isInProgress: true,
    );
    WorkoutRepository().saveDraft(draft);
  }

  void _startTimer() {
    _startTime ??= DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _duration = DateTime.now().difference(_startTime!);
      });
    });
  }

  // Rest Timer State
  // _restTimer and _isResting are re-used from top state if they exist,
  // but better to consolidate.
  // I will just keep the new implementations here close to usage or move to top.
  // Let's rely on cleaning up the top.

  void _startRestTimer([int durationSeconds = 120]) {
    _restTimer?.cancel();
    _restTimerNotifier.value = durationSeconds;

    // Show Modal Bottom Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Resting...",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: _restTimerNotifier,
              builder: (context, seconds, _) {
                final m = seconds ~/ 60;
                final s = seconds % 60;
                final timeStr = "${m}:${s.toString().padLeft(2, '0')}";
                return Text(
                  timeStr,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _restTimerNotifier.value += 30;
                  },
                  child: Text(
                    "+30s",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFFF5500),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                SizedBox(
                  height: 48,
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop(); // Close sheet
                      _stopRestTimer();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      "Skip Rest",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ).whenComplete(() {
      // Ensure timer stops if sheet is dismissed by other means (tap outside)
      if (_restTimerNotifier.value > 0) _stopRestTimer();
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_restTimerNotifier.value <= 0) {
        timer.cancel();
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Close sheet automatically when done
        }
        _stopRestTimer();
      } else {
        _restTimerNotifier.value--;
      }
    });
  }

  void _stopRestTimer() {
    _restTimer?.cancel();
    // We don't need to setState here unless some other UI depends on _isResting
    // The sheet is closed separately.
  }

  String get _formattedDuration {
    final twoDigitSeconds = _duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    if (_duration.inHours > 0) {
      return "${_duration.inHours}h ${_duration.inMinutes.remainder(60)}m";
    }
    return "${_duration.inMinutes}m ${twoDigitSeconds}s";
  }

  String get _formattedDurationCompact {
    final m = _duration.inMinutes;
    final s = _duration.inSeconds.remainder(60);
    if (m > 0) return "${m}m ${s}s";
    return "${s}s";
  }

  void _addExercise() async {
    final result = await context.push<String>('/workout/exercise-select');
    if (result != null) {
      setState(() {
        _exercises.add(
          ActiveExercise(
            name: result,
            sets: [ActiveSet(setNumber: 1, weight: "0", reps: "0")],
          ),
        );
      });
    }
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      final ex = _exercises[exerciseIndex];
      final previousSet = ex.sets.last;
      ex.sets.add(
        ActiveSet(
          setNumber: ex.sets.length + 1,
          weight: previousSet.weight,
          reps: previousSet.reps,
        ),
      );
    });
  }

  Future<void> _finishWorkout() async {
    if (_exercises.isEmpty) {
      context.pop();
      return;
    }

    List<ExerciseLog> historyExercises = _exercises.map((e) {
      return ExerciseLog(
        e.name,
        e.sets
            .where((s) => s.isCompleted)
            .map(
              (s) => SetLog(
                s.setNumber,
                s.reps,
                "${s.weight} kg",
                isCompleted: true,
              ),
            )
            .toList(),
      );
    }).toList();

    int totalVolume = 0;
    for (var ex in _exercises) {
      for (var s in ex.sets) {
        if (s.isCompleted) {
          totalVolume +=
              (int.tryParse(s.weight) ?? 0) * (int.tryParse(s.reps) ?? 0);
        }
      }
    }

    final newSession = WorkoutSession(
      title: _workoutTitle,
      duration: _formattedDuration,
      volume: "$totalVolume kg",
      exercises: historyExercises,
      date: DateTime.now(),
    );

    WorkoutRepository().addWorkout(newSession);
    _isFinished = true;
    WorkoutRepository().clearDraft();

    if (mounted) context.pop();
  }

  int get _completedSets {
    int count = 0;
    for (var ex in _exercises) {
      for (var s in ex.sets) {
        if (s.isCompleted) count++;
      }
    }
    return count;
  }

  int get _totalVolume {
    int vol = 0;
    for (var ex in _exercises) {
      for (var s in ex.sets) {
        if (s.isCompleted) {
          vol += (int.tryParse(s.weight) ?? 0) * (int.tryParse(s.reps) ?? 0);
        }
      }
    }
    return vol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Log Workout", // Changed title as per request
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          Icon(Icons.timer_outlined, color: Colors.grey, size: 20),
          SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: _finishWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF007AFF,
                  ), // Blue Finish Button
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), // More rectangular
                  ),
                ),
                child: Text(
                  "Finish",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSessionStats(),
          Expanded(
            child: _exercises.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: _exercises.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _exercises.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Add Exercise Button (Blue)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _addExercise,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF007AFF,
                                    ), // Blue
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Add Exercise",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Settings & Discard Row
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {}, // Settings action
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF1C1C1E,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Settings",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          context.pop(), // Discard action
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF1C1C1E,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Discard Workout",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(
                                            0xFFFF453A,
                                          ), // Red text
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      }
                      return _buildExerciseCard(index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addExercise,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
            ),
            child: const Text("Add First Exercise"),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStats() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _buildStatItem("Duration", _formattedDurationCompact),
          const SizedBox(width: 40),
          _buildStatItem("Volume", "${_totalVolume} kg"),
          const SizedBox(width: 40),
          _buildStatItem("Sets", "$_completedSets"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style:
              GoogleFonts.outfit(
                // White text
                color: Colors
                    .blue, // Blue value as in some UI parts, or keep white? Image has Blue time, White volume.
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ).copyWith(
                color: label == "Duration"
                    ? const Color(0xFF0A84FF)
                    : Colors.white,
              ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(int exerciseIndex) {
    final exercise = _exercises[exerciseIndex];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // Minimal margin
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  // Placeholder for icon
                  child: Icon(
                    Icons.fitness_center,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    exercise.name,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF0A84FF), // Blue Title
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.more_vert, color: Colors.grey, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Sets Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                SizedBox(width: 32, child: Text("SET", style: _headerStyle)),
                Expanded(
                  child: Text(
                    "PREVIOUS",
                    style: _headerStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "KG",
                    style: _headerStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "REPS",
                    style: _headerStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 32,
                  child: Icon(Icons.check, size: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Sets Logic
          ...exercise.sets.asMap().entries.map((entry) {
            final index = entry.key;
            final set = entry.value;
            final isEven = index % 2 == 0;
            return Container(
              color: isEven
                  ? const Color(0xFF101012)
                  : Colors
                        .black, // Alternating colors ? Or just slightly clearer
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      "${set.setNumber}",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "-",
                      style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // KG Input
                  Expanded(
                    child: Center(
                      child: Container(
                        height: 28,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          initialValue: set.weight == "0" ? "" : set.weight,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: "0",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                          ),
                          onChanged: (v) => set.weight = v.isEmpty ? "0" : v,
                        ),
                      ),
                    ),
                  ),

                  // REPS Input
                  Expanded(
                    child: Center(
                      child: Container(
                        height: 28,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          initialValue: set.reps == "0" ? "" : set.reps,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: "0",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                          ),
                          onChanged: (v) => set.reps = v.isEmpty ? "0" : v,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 32,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            set.isCompleted = !set.isCompleted;
                            if (set.isCompleted)
                              _startRestTimer(exercise.defaultRestTime);
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: set.isCompleted
                                ? Colors.grey[700]
                                : Colors.grey[800],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: set.isCompleted
                              ? Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Add Set Button matches the dark theme in image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: GestureDetector(
              onTap: () => _addSet(exerciseIndex),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "+ Add Set",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Divider(color: Colors.white10),
        ],
      ),
    );
  }

  TextStyle get _headerStyle => GoogleFonts.plusJakartaSans(
    color: Colors.grey,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}
