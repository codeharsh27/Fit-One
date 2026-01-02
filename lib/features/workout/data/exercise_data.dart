class ExerciseDetail {
  final String name;
  final String gifUrl; // Using a URL for now, can be asset path
  final List<String> targetMuscles;
  final List<String> instructions;
  final List<String> proTips;

  const ExerciseDetail({
    required this.name,
    required this.gifUrl,
    required this.targetMuscles,
    required this.instructions,
    required this.proTips,
  });
}

class ExerciseData {
  static const Map<String, ExerciseDetail> _details = {
    "Bench Press": ExerciseDetail(
      name: "Bench Press",
      gifUrl: "https://media.tenor.com/gI-8qCUEko8AAAAC/bench-press-chest.gif",
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
    "Squat": ExerciseDetail(
      name: "Squat",
      gifUrl: "https://media.giphy.com/media/dummy/squat.gif",
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
    "Deadlift": ExerciseDetail(
      name: "Deadlift",
      gifUrl: "https://media.giphy.com/media/dummy/deadlift.gif",
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
  };

  static ExerciseDetail getDetails(String exerciseName) {
    // Return specific details or a fallback generic one
    return _details[exerciseName] ??
        ExerciseDetail(
          name: exerciseName,
          gifUrl: "",
          targetMuscles: ["Full Body"],
          instructions: [
            "Prepare for the movement securely.",
            "Execute with controlled tempo.",
            "Focus on muscle contraction.",
            "Return to starting position safely.",
          ],
          proTips: [
            "Maintain proper form over heavy weight.",
            "Breathe rhythmically.",
            "Stop if you feel sharp pain.",
          ],
        );
  }
}
