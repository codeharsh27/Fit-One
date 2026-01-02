class ExploreData {
  // --- Programs ---
  static final List<WorkoutProgram> programs = [
    WorkoutProgram(
      id: 'ppl_beginner',
      title: "Push Pull Legs",
      description: "The gold standard split for building muscle mass.",
      level: "Beginner",
      goal: "Muscle Gain",
      equipment: "Full Gym",
      routines: [
        WorkoutRoutine(
          name: "Push A (Chest/Shoulders/Tri)",
          exercises: [
            RoutineExercise(
              name: "Bench Press",
              sets: "3",
              reps: "8-12",
              weight: "60 kg",
              restTime: 120,
            ),
            RoutineExercise(
              name: "Overhead Press",
              sets: "3",
              reps: "8-10",
              weight: "40 kg",
              restTime: 120,
            ),
            RoutineExercise(
              name: "Incline Dumbbell Press",
              sets: "3",
              reps: "10-12",
              weight: "25 kg",
              restTime: 90,
            ),
            RoutineExercise(
              name: "Lateral Raises",
              sets: "3",
              reps: "15-20",
              weight: "10 kg",
              restTime: 60,
            ),
            RoutineExercise(
              name: "Tricep Pushdowns",
              sets: "3",
              reps: "12-15",
              weight: "20 kg",
              restTime: 60,
            ),
          ],
        ),
        WorkoutRoutine(
          name: "Pull A (Back/Bicep)",
          exercises: [
            RoutineExercise(
              name: "Barbell Row",
              sets: "3",
              reps: "8-12",
              weight: "60 kg",
              restTime: 120,
            ),
            RoutineExercise(
              name: "Lat Pulldowns",
              sets: "3",
              reps: "10-12",
              weight: "50 kg",
              restTime: 90,
            ),
            RoutineExercise(
              name: "Face Pulls",
              sets: "3",
              reps: "15-20",
              weight: "15 kg",
              restTime: 60,
            ),
            RoutineExercise(
              name: "Barbell Curls",
              sets: "3",
              reps: "10-12",
              weight: "30 kg",
              restTime: 90,
            ),
            RoutineExercise(
              name: "Hammer Curls",
              sets: "3",
              reps: "12-15",
              weight: "15 kg",
              restTime: 60,
            ),
          ],
        ),
        WorkoutRoutine(
          name: "Legs A (Quads/Hams)",
          exercises: [
            RoutineExercise(
              name: "Squat",
              sets: "3",
              reps: "6-10",
              weight: "80 kg",
              restTime: 180,
            ),
            RoutineExercise(
              name: "Romanian Deadlift",
              sets: "3",
              reps: "8-12",
              weight: "70 kg",
              restTime: 120,
            ),
            RoutineExercise(
              name: "Leg Press",
              sets: "3",
              reps: "10-12",
              weight: "150 kg",
              restTime: 120,
            ),
            RoutineExercise(
              name: "Leg Curls",
              sets: "3",
              reps: "12-15",
              weight: "40 kg",
              restTime: 60,
            ),
            RoutineExercise(
              name: "Calf Raises",
              sets: "4",
              reps: "15-20",
              weight: "40 kg",
              restTime: 60,
            ),
          ],
        ),
      ],
      colorCode: 0xFF2196F3, // Blue
    ),
    WorkoutProgram(
      id: 'full_body_inter',
      title: "Full Body",
      description: "High frequency training for overall strength.",
      level: "Intermediate",
      goal: "Strength",
      equipment: "Full Gym",
      routines: [
        WorkoutRoutine(
          name: "Full Body A",
          exercises: [
            RoutineExercise(
              name: "Squat",
              sets: "3",
              reps: "5",
              weight: "100 kg",
              restTime: 180,
            ),
            RoutineExercise(
              name: "Bench Press",
              sets: "3",
              reps: "6-10",
              weight: "70 kg",
              restTime: 120,
            ),
            RoutineExercise(
              name: "Bent Over Row",
              sets: "3",
              reps: "8-12",
              weight: "60 kg",
              restTime: 120,
            ),
            RoutineExercise(
              name: "Overhead Press",
              sets: "3",
              reps: "8-10",
              weight: "40 kg",
              restTime: 90,
            ),
          ],
        ),
        WorkoutRoutine(
          name: "Full Body B",
          exercises: [
            RoutineExercise(
              name: "Deadlift",
              sets: "1",
              reps: "5",
              weight: "120 kg",
              restTime: 180,
            ),
            RoutineExercise(
              name: "Pull Ups",
              sets: "3",
              reps: "AMRAP",
              weight: "BW",
              restTime: 120,
            ),
            RoutineExercise(
              name: "Dips",
              sets: "3",
              reps: "10",
              weight: "BW",
              restTime: 90,
            ),
            RoutineExercise(
              name: "Lunges",
              sets: "3",
              reps: "12",
              weight: "20 kg",
              restTime: 60,
            ),
          ],
        ),
      ],
      colorCode: 0xDD000000, // Black/Dark
    ),
    WorkoutProgram(
      id: 'upper_lower',
      title: "Upper Lower",
      description: "Balanced 4-day split for size and strength.",
      level: "Intermediate",
      goal: "Muscle Gain",
      equipment: "Gym",
      routines: [
        WorkoutRoutine(
          name: "Upper Power",
          exercises: [
            RoutineExercise(
              name: "Bench Press",
              sets: "3",
              reps: "5",
              weight: "80 kg",
              restTime: 180,
            ),
            RoutineExercise(
              name: "Barbell Row",
              sets: "3",
              reps: "8",
              weight: "70 kg",
              restTime: 120,
            ),
            RoutineExercise(
              name: "Overhead Press",
              sets: "3",
              reps: "8",
              weight: "50 kg",
              restTime: 120,
            ),
          ],
        ),
        WorkoutRoutine(
          name: "Lower Power",
          exercises: [
            RoutineExercise(
              name: "Squat",
              sets: "3",
              reps: "5",
              weight: "100 kg",
              restTime: 180,
            ),
            RoutineExercise(
              name: "Deadlift",
              sets: "3",
              reps: "5",
              weight: "120 kg",
              restTime: 180,
            ),
            RoutineExercise(
              name: "Leg Press",
              sets: "3",
              reps: "10",
              weight: "180 kg",
              restTime: 120,
            ),
          ],
        ),
      ],
      colorCode: 0xFFFF5500, // Orange
    ),
  ];

  // --- Category Exercises (Expert Curated) ---
  static final Map<String, List<Map<String, String>>> categoryExercises = {
    "At home": [
      {
        "name": "Push-ups",
        "muscle": "Chest",
        "image":
            "https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=500&q=80",
      },
      {
        "name": "Bodyweight Squats",
        "muscle": "Legs",
        "image":
            "https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=500&q=80",
      },
      {
        "name": "Lunges",
        "muscle": "Legs",
        "image":
            "https://images.unsplash.com/photo-1434682881908-b43d0467b798?w=500&q=80",
      },
      {
        "name": "Plank",
        "muscle": "Core",
        "image":
            "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=500&q=80",
      },
    ],
    "Dumbbells Only": [
      {
        "name": "Goblet Squat",
        "muscle": "Legs",
        "image":
            "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=500&q=80",
      },
      {
        "name": "Dumbbell Press",
        "muscle": "Chest",
        "image":
            "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=500&q=80",
      },
      {
        "name": "Dumbbell Row",
        "muscle": "Back",
        "image":
            "https://images.unsplash.com/photo-1603287681836-e56695f21917?w=500&q=80",
      },
      {
        "name": "DB Shoulder Press",
        "muscle": "Shoulders",
        "image":
            "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=500&q=80",
      },
    ],
    "Travel": [
      {
        "name": "Burpees",
        "muscle": "Full Body",
        "image":
            "https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=500?q=80",
      },
      {
        "name": "Mountain Climbers",
        "muscle": "Core",
        "image":
            "https://images.unsplash.com/photo-1434682881908-b43d0467b798?w=500&q=80",
      },
    ],
    "Cardio & HIIT": [
      {
        "name": "Jump Rope",
        "muscle": "Cardio",
        "image":
            "https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=500?q=80",
      },
      {
        "name": "Sprints",
        "muscle": "Legs",
        "image":
            "https://images.unsplash.com/photo-1538805060504-6303c05171d5?w=500&q=80",
      },
    ],
    "Gym Strength": [
      {
        "name": "Deadlift",
        "muscle": "Back",
        "image":
            "https://images.unsplash.com/photo-1603287681836-e56695f21917?w=500&q=80",
      },
      {
        "name": "Bench Press",
        "muscle": "Chest",
        "image":
            "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=500&q=80",
      },
    ],
    "Band/Mobility": [
      {
        "name": "Band Pull Aparts",
        "muscle": "Shoulders/Post",
        "image":
            "https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=500&q=80",
      },
      {
        "name": "Cat-Cow Stretch",
        "muscle": "Spine",
        "image":
            "https://images.unsplash.com/photo-1544367563-12123d8965cd?w=500&q=80",
      },
      {
        "name": "Hip Flexor Stretch",
        "muscle": "Hips",
        "image":
            "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=500&q=80",
      },
      {
        "name": "Band Squats",
        "muscle": "Legs",
        "image":
            "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=500&q=80",
      },
    ],
  };
}

class WorkoutProgram {
  final String id;
  final String title;
  final String description;
  final String level;
  final String goal;
  final String equipment;
  final List<WorkoutRoutine> routines;
  final int colorCode;

  WorkoutProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.goal,
    required this.equipment,
    required this.routines,
    required this.colorCode,
  });
}

class WorkoutRoutine {
  final String name;
  final List<RoutineExercise> exercises;

  WorkoutRoutine({required this.name, required this.exercises});
}

class RoutineExercise {
  final String name;
  final String sets;
  final String reps;
  final String weight;
  final int restTime; // in seconds

  RoutineExercise({
    required this.name,
    this.sets = "3",
    this.reps = "10",
    this.weight = "20 kg",
    this.restTime = 90,
  });
}
