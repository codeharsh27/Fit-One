import 'package:hive_flutter/hive_flutter.dart';
import 'package:tandurast/core/data/models/workout_models.dart';

class WorkoutRepository {
  static final WorkoutRepository _instance = WorkoutRepository._internal();
  factory WorkoutRepository() => _instance;
  WorkoutRepository._internal();

  late Box<WorkoutSession> _box;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _box = await Hive.openBox<WorkoutSession>('workouts');
    // We reuse the same box or open a new one?
    // Let's use a separate key in the same box or a separate box.
    // Separate box is cleaner for 'single draft'.
    // Actually, Hive objects are tied to boxes. To properly separate, let's just use a special key 'draft' in the same box?
    // No, 'workouts' box stores historical sessions (List-like usually).
    // Let's open a 'drafts' box.
    await Hive.openBox<WorkoutSession>('drafts');

    _isInitialized = true;

    // Add mock data if empty
    if (_box.isEmpty) {
      _addMockData();
    }
  }

  void _addMockData() {
    final now = DateTime.now();
    _box.add(
      WorkoutSession(
        title: "Chest & Triceps Hypertrophy",
        duration: "1h 15m",
        volume: "12,400 kg",
        date: now,
        exercises: [
          ExerciseLog("Bench Press (Barbell)", [
            SetLog(1, "12", "60 kg"),
            SetLog(2, "10", "80 kg"),
          ]),
          ExerciseLog("Incline Dumbbell Press", [SetLog(1, "12", "30 kg")]),
        ],
      ),
    );
  }

  // Helper to maintain existing API for history page (grouped by date key)
  Map<String, List<WorkoutSession>> get history {
    if (!_isInitialized) return {};

    final map = <String, List<WorkoutSession>>{};
    for (var session in _box.values) {
      // Filter out drafts if they accidentally get in here, though drafts are in separate box now.
      // But let's be safe.
      if (session.isInProgress) continue;

      final key =
          "${session.date.year}-${session.date.month}-${session.date.day}";
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(session);
    }
    return map;
  }

  Future<void> addWorkout(WorkoutSession session) async {
    if (!_isInitialized) await init();
    await _box.add(session);
  }

  // Draft Methods
  Future<void> saveDraft(WorkoutSession session) async {
    if (!_isInitialized) await init();
    final draftBox = Hive.box<WorkoutSession>('drafts');
    await draftBox.put('current_draft', session);
  }

  Future<WorkoutSession?> getDraft() async {
    if (!_isInitialized) await init();
    final draftBox = Hive.box<WorkoutSession>('drafts');
    return draftBox.get('current_draft');
  }

  Future<void> clearDraft() async {
    if (!_isInitialized) await init();
    final draftBox = Hive.box<WorkoutSession>('drafts');
    await draftBox.delete('current_draft');
  }
}
