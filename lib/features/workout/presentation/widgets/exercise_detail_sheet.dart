import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tandurast/features/workout/data/exercise_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tandurast/core/di/injection_container.dart' as di;
import 'package:tandurast/features/workout/domain/repositories/exercise_repository.dart';

class ExerciseDetailSheet extends StatefulWidget {
  final String exerciseName;
  const ExerciseDetailSheet({super.key, required this.exerciseName});

  @override
  State<ExerciseDetailSheet> createState() => _ExerciseDetailSheetState();
}

class _ExerciseDetailSheetState extends State<ExerciseDetailSheet> {
  late Future<ExerciseDetail?> _detailsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch from cloud via Repository
    _detailsFuture = di.sl<ExerciseRepository>().getExerciseDetail(
      widget.exerciseName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExerciseDetail?>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        // Fallback to local data if loading, error, or null (not found in cloud)
        // Actually, we should probably show loading state for a split second?
        // Or better: Show local data immediately (instant valid UI) and then replace with Cloud data if available?
        // Let's do: Loading -> Cloud Data -> Fallback Local.

        ExerciseDetail displayDetails;

        if (snapshot.connectionState == ConnectionState.waiting) {
          // We can render the local fallback while waiting for cloud updates!
          // This gives "Instant" UI.
          displayDetails = ExerciseData.getDetails(widget.exerciseName);
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null) {
          displayDetails = ExerciseData.getDetails(widget.exerciseName);
        } else {
          displayDetails = snapshot.data!;
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        // Title
                        Text(
                          displayDetails.name,
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Media (GIF/Video Placeholder)
                        Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: displayDetails.gifUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: displayDetails.gifUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        _buildPlaceholder(isLoading: true),
                                    errorWidget: (context, url, error) =>
                                        _buildPlaceholder(),
                                  )
                                : _buildPlaceholder(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Target Muscles
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: displayDetails.targetMuscles.map((muscle) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFF5500,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFF5500,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                muscle,
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFFFF5500),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 30),

                        // Instructions
                        Text(
                          "Instructions",
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...displayDetails.instructions.asMap().entries.map((
                          entry,
                        ) {
                          int idx = entry.key + 1;
                          String text = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "$idx",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    text,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.grey[300],
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 20),

                        // Pro Tips
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blueAccent.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Pro Tips",
                                    style: GoogleFonts.outfit(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...displayDetails.proTips.map(
                                (tip) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "• ",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          tip,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.blue.shade100,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlaceholder({bool isLoading = false}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2C2C2E), Color(0xFF1C1C1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? const CircularProgressIndicator(color: Color(0xFFFF5500))
                : const Icon(
                    Icons.play_circle_fill,
                    color: Color(0xFFFF5500),
                    size: 48,
                  ),
            const SizedBox(height: 8),
            Text(
              isLoading ? "Loading..." : "Demonstration GIF",
              style: GoogleFonts.plusJakartaSans(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
