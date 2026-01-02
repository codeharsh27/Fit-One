import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tandurast/features/workout/data/explore_data.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = "";
  String? _selectedFilter;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Chest', 'icon': Icons.fitness_center},
    {'name': 'Back', 'icon': Icons.accessibility_new},
    {'name': 'Legs', 'icon': Icons.directions_run},
    {'name': 'Abs', 'icon': Icons.grid_view},
    {'name': 'Arms', 'icon': Icons.front_hand},
    {'name': 'Shoulders', 'icon': Icons.emoji_people},
  ];

  final List<String> _filters = [
    "All",
    "Beginner",
    "Intermediate",
    "Advanced",
    "Home",
    "Gym",
  ];

  List<WorkoutProgram> get _filteredPrograms {
    return ExploreData.programs.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesFilter = _selectedFilter == null || _selectedFilter == "All"
          ? true
          : (p.level == _selectedFilter ||
                p.equipment.contains(_selectedFilter!));
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Explore",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Search workouts, programs...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Body Parts Categories
              Text(
                "Browse by Body Part",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return _buildCategoryItem(
                      cat['name'] as String,
                      cat['icon'] as IconData,
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Featured / Programs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Featured Programs",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Filter Button or Dropdown
                ],
              ),
              const SizedBox(height: 12),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters
                      .map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(f),
                            selected: _selectedFilter == f,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedFilter = selected ? f : null;
                              });
                            },
                            backgroundColor: const Color(0xFF1C1C1E),
                            selectedColor: const Color(0xFFFF5500),
                            labelStyle: GoogleFonts.plusJakartaSans(
                              color: _selectedFilter == f
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide.none,
                            ),
                            showCheckmark: false,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Programs List
              if (_filteredPrograms.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      "No programs found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredPrograms.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final program = _filteredPrograms[index];
                    return _buildProgramCard(program);
                  },
                ),

              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon) {
    return GestureDetector(
      onTap: () {
        List<String> exercises = [];
        String title = "$name Workout";

        switch (name) {
          case 'Chest':
            exercises = [
              'Bench Press (Barbell)',
              'Incline Dumbbell Press',
              'Chest Fly',
            ];
            break;
          case 'Back':
            exercises = ['Pullups', 'Lat Pulldown (Cable)', 'Barbell Row'];
            break;
          case 'Legs':
            exercises = ['Squat (Barbell)', 'Leg Press', 'Walking Lunges'];
            break;
          case 'Abs':
            exercises = ['Crunches', 'Plank', 'Leg Raises'];
            break;
          case 'Arms':
            exercises = [
              'Bicep Curl (Dumbbell)',
              'Tricep Dips',
              'Hammer Curls',
            ];
            break;
          case 'Shoulders':
            exercises = [
              'Overhead Press (Dumbbell)',
              'Lateral Raises',
              'Front Raises',
            ];
            break;
          default:
            exercises = ['Burpees', 'Pushups', 'Jumping Jacks'];
        }

        context.push(
          '/workout/active',
          extra: {'title': title, 'exercises': exercises},
        );
      },
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5500).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFFF5500), size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramCard(WorkoutProgram program) {
    return GestureDetector(
      onTap: () {
        context.push('/explore/program/${program.id}');
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            // Background Image with Error Handling
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=500&auto=format&fit=crop&q=60",
                  fit: BoxFit.cover,
                  memCacheWidth: 600,
                  placeholder: (context, url) =>
                      Container(color: const Color(0xFF2C2C2E)),
                  errorWidget: (context, url, error) =>
                      Container(color: const Color(0xFF2C2C2E)),
                ),
              ),
            ),
            // Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5500),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            program.level.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          program.title,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${program.routines.length} Routines • ${program.equipment}",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.grey[300],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
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
