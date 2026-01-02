import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class NewRoutinePage extends StatefulWidget {
  const NewRoutinePage({super.key});

  @override
  State<NewRoutinePage> createState() => _NewRoutinePageState();
}

class _NewRoutinePageState extends State<NewRoutinePage> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _exercises = [];

  void _addExercise() async {
    // Navigate to exercise selection page
    final result = await context.push<String>('/workout/exercise-select');
    if (result != null) {
      setState(() {
        _exercises.add(result);
      });
    }
  }

  void _saveRoutine() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a routine name")),
      );
      return;
    }
    // TODO: Save routine to repository
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Routine Created Successfully!"),
        backgroundColor: Color(0xFFFF5500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "New Routine",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveRoutine,
            child: Text(
              "Save",
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFFF5500),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Routine Name Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: _nameController,
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Routine Name (e.g., Leg Day)",
                  hintStyle: GoogleFonts.outfit(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Exercises List
            Expanded(
              child: _exercises.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 48,
                            color: Colors.white12,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No exercises added yet",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: _addExercise,
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFFFF5500),
                            ),
                            label: Text(
                              "Add Exercise",
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFFF5500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _exercises.length + 1,
                      separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == _exercises.length) {
                          return TextButton.icon(
                            onPressed: _addExercise,
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFFFF5500),
                            ),
                            label: Text(
                              "Add Exercise",
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFFF5500),
                              ),
                            ),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                _exercises[index],
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _exercises.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
