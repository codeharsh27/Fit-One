import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ExerciseSelectionPage extends StatefulWidget {
  const ExerciseSelectionPage({super.key});

  @override
  State<ExerciseSelectionPage> createState() => _ExerciseSelectionPageState();
}

class _ExerciseSelectionPageState extends State<ExerciseSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allExercises = [
    "Bench Press",
    "Squat",
    "Deadlift",
    "Overhead Press",
    "Barbell Row",
    "Pull Ups",
    "Dumbbell Bicep Curl",
    "Tricep Pushdown",
    "Lat Pulldown",
    "Leg Press",
    "Leg Extension",
    "Leg Curl",
    "Calf Raises",
    "Lateral Raises",
    "Face Pulls",
    "Hammer Curls",
    "Incline Dumbbell Press",
    "Dumbbell Flys",
    "Push-ups",
    "Plank",
    "Lunges",
    "Romanian Deadlift",
    "Front Squat",
    "Dips",
    "Chin Ups",
    "Skullcrushers",
    "Preacher Curls",
    "Cable Crossovers",
    "Seated Row",
    "T-Bar Row",
    "Shrugs",
    "Arnold Press",
    "Bulgarian Split Squat",
    "Hip Thrust",
    "Glute Bridge",
    "Mountain Climbers",
    "Burpees",
    "Jump Rope",
    "Box Jumps",
    "Kettlebell Swing",
  ];

  List<String> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    _filteredExercises = _allExercises;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredExercises = _allExercises
          .where(
            (exercise) => exercise.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Select Exercise",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search exercises...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1C1C1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredExercises.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.white12, height: 1),
              itemBuilder: (context, index) {
                final exercise = _filteredExercises[index];
                return ListTile(
                  title: Text(
                    exercise,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFFFF5500),
                  ),
                  onTap: () {
                    context.pop(exercise);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
