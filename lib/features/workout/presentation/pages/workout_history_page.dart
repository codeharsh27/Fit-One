import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tandurast/core/data/workout_repository.dart';

import 'package:tandurast/core/data/models/workout_models.dart';

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({super.key});

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Repository access
  final _repository = WorkoutRepository();

  @override
  void initState() {
    super.initState();
    _initRepo();
  }

  void _initRepo() async {
    await _repository.init();
    if (mounted) setState(() {});
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDay = day;
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + offset, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String dateKey =
        "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}";
    final List<WorkoutSession> selectedWorkouts =
        _repository.history[dateKey] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'History',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Calendar Widget Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E), // Grey background
                borderRadius: BorderRadius.circular(20),
              ),
              child: _buildCalendar(),
            ),

            const SizedBox(height: 10),

            // 2. Selected Date Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDateTitle(_selectedDay),
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (selectedWorkouts.isNotEmpty)
                    Text(
                      "${selectedWorkouts.length} Workouts",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: const Color(0xFFFF5500),
                      ),
                    ),
                ],
              ),
            ),

            // 3. Detailed List
            selectedWorkouts.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.fitness_center_outlined,
                            size: 48,
                            color: Colors.white24,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Rest Day",
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              color: Colors.white38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No workouts recorded",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white24,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true, // Allow scrolling
                    physics:
                        const NeverScrollableScrollPhysics(), // Scroll handled by parent SingleChildScrollView
                    itemCount: selectedWorkouts.length,
                    itemBuilder: (context, index) {
                      return _buildDetailCard(selectedWorkouts[index]);
                    },
                  ),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedDay.year,
      _focusedDay.month,
    );
    final firstDayOffset =
        DateTime(_focusedDay.year, _focusedDay.month, 1).weekday -
        1; // Mon=1 -> 0

    return Column(
      children: [
        // Month Navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () => _changeMonth(-1),
            ),
            Text(
              _formatMonthYear(_focusedDay),
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () => _changeMonth(1),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Week Days
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map(
                (d) => SizedBox(
                  width: 30,
                  child: Center(
                    child: Text(
                      d,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        // Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: daysInMonth + firstDayOffset,
          itemBuilder: (context, index) {
            if (index < firstDayOffset) return const SizedBox();

            final dayInt = index - firstDayOffset + 1;
            final date = DateTime(_focusedDay.year, _focusedDay.month, dayInt);
            final key = "${date.year}-${date.month}-${date.day}";
            final hasWorkout = _repository.history.containsKey(key);
            final isSelected =
                _selectedDay.year == date.year &&
                _selectedDay.month == date.month &&
                _selectedDay.day == date.day;
            final isToday =
                DateTime.now().year == date.year &&
                DateTime.now().month == date.month &&
                DateTime.now().day == date.day;

            return GestureDetector(
              onTap: () => _onDaySelected(date),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFFFF5500)
                      : Colors.transparent,
                  border: isToday && !isSelected
                      ? Border.all(color: const Color(0xFFFF5500))
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '$dayInt',
                      style: GoogleFonts.plusJakartaSans(
                        color: isSelected
                            ? Colors.white
                            : (isToday
                                  ? const Color(0xFFFF5500)
                                  : Colors.white),
                        fontWeight: (isSelected || isToday)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (hasWorkout && !isSelected)
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5500),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailCard(WorkoutSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5500).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: Color(0xFFFF5500),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${session.duration} • ${session.volume}",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),
          // Exercise List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: session.exercises.length,
            itemBuilder: (context, index) {
              final ex = session.exercises[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Sets Grid
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ex.sets
                          .map(
                            (s) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "${s.reps} x ${s.weight}",
                                style: GoogleFonts.codystar(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // Simple formatting helpers
  String _formatMonthYear(DateTime dt) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return "${months[dt.month - 1]} ${dt.year}";
  }

  String _formatDateTitle(DateTime dt) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}";
  }
}
