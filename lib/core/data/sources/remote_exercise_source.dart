import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tandurast/features/workout/data/exercise_data.dart';

class RemoteExerciseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _exercises => _firestore.collection('exercises');

  // Fetch details for a specific exercise
  Future<ExerciseDetail?> getExerciseDetail(String name) async {
    try {
      final snapshot = await _exercises
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;

        return ExerciseDetail(
          name: data['name'] ?? name,
          gifUrl: data['gifUrl'] ?? '',
          targetMuscles: List<String>.from(data['targetMuscles'] ?? []),
          instructions: List<String>.from(data['instructions'] ?? []),
          proTips: List<String>.from(data['proTips'] ?? []),
        );
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching exercise details: $e");
      return null;
    }
  }

  // Admin/Seed function to populate Firestore
  Future<void> seedDatabase() async {
    // List of exercises to seed
    final List<ExerciseDetail> seedData = [
      const ExerciseDetail(
        name: "Bench Press",
        gifUrl:
            "https://media.tenor.com/gI-8qCUEko8AAAAC/bench-press-chest.gif",
        targetMuscles: ["Chest", "Triceps", "Front Delts"],
        instructions: [
          "Lie on the bench with your eyes under the bar.",
          "Grip the bar slightly wider than shoulder-width.",
          "Unrack the bar and lower it to your mid-chest.",
          "Press the bar back up until your arms are fully extended.",
        ],
        proTips: [
          "Keep your feet planted firmly on the ground.",
          "Retract your shoulder blades to protect your shoulders.",
          "Don't bounce the bar off your chest.",
        ],
      ),
      const ExerciseDetail(
        name: "Squat",
        gifUrl:
            "https://media.tenor.com/Vbf9QyN9oYIAAAAC/squat-exercise.gif", // Corrected URL
        targetMuscles: ["Quads", "Glutes", "Hamstrings", "Core"],
        instructions: [
          "Stand with feet shoulder-width apart.",
          "Rest the bar on your upper back (traps).",
          "Break at the hips and knees simultaneously.",
          "Lower until your thighs are parallel to the floor.",
          "Drive back up through your mid-foot.",
        ],
        proTips: [
          "Keep your chest up and core braced.",
          "Ensure your knees track over your toes.",
          "Do not let your knees cave inward.",
        ],
      ),
      const ExerciseDetail(
        name: "Deadlift",
        gifUrl:
            "https://media.tenor.com/4J0kMqLqC_kAAAAC/barbell-deadlift.gif", // Example URL
        targetMuscles: ["Back", "Glutes", "Hamstrings"],
        instructions: [
          "Stand with the bar over your mid-foot.",
          "Hinge at the hips to grip the bar.",
          "Bring your shins to the bar and lift your chest.",
          "Pull the bar up by extending your hips and knees.",
        ],
        proTips: [
          "Keep a neutral spine throughout the movement.",
          "Engage your lats to keep the bar close to your body.",
          "Squeeze your glutes at the top.",
        ],
      ),
      // Add more as needed...
    ];

    for (var exercise in seedData) {
      // Use name as ID for easier finding, or let firestore gen ID
      // Using name as ID ensures we don't duplicate easily if re-run
      await _exercises.doc(exercise.name).set({
        'name': exercise.name,
        'gifUrl': exercise.gifUrl,
        'targetMuscles': exercise.targetMuscles,
        'instructions': exercise.instructions,
        'proTips': exercise.proTips,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      debugPrint("Seeded: ${exercise.name}");
    }
  }
}
