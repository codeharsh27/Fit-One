import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutStatsPage extends StatefulWidget {
  const WorkoutStatsPage({super.key});

  @override
  State<WorkoutStatsPage> createState() => _WorkoutStatsPageState();
}

class _WorkoutStatsPageState extends State<WorkoutStatsPage> {
  String _selectedRange = 'Week'; // Options: Day, Week, Month, Year
  int _selectedIndex = -1; // -1 means no specific bar selected

  // Mock Data Generators
  List<Map<String, dynamic>> get _currentChartData {
    switch (_selectedRange) {
      case 'Day':
        // Hourly breakdown for a single day? Or just one big bar?
        // usually Day stats are just the stats for that day.
        // Let's do hourly 'activity' or just 'volume per exercise'
        return [
          {"label": "Squat", "value": 4000, "height": 0.8},
          {"label": "Leg Press", "value": 5000, "height": 1.0},
          {"label": "Ext", "value": 1500, "height": 0.3},
          {"label": "Curl", "value": 1200, "height": 0.25},
        ];
      case 'Week':
        return [
          {"label": "M", "value": 12500, "height": 0.5},
          {"label": "T", "value": 18200, "height": 0.75},
          {"label": "W", "value": 9400, "height": 0.4},
          {"label": "T", "value": 24500, "height": 1.0},
          {"label": "F", "value": 15000, "height": 0.6},
          {"label": "S", "value": 6000, "height": 0.25},
          {"label": "S", "value": 0, "height": 0.05},
        ];
      case 'Month':
        return List.generate(4, (index) {
          return {
            "label": "W${index + 1}",
            "value": (15000 + (index * 2000)),
            "height": 0.4 + (index * 0.15),
          };
        });
      case 'Year':
        return ["Jan", "Feb", "Mar", "Apr", "May", "Jun"].map((m) {
          return {"label": m, "value": 45000, "height": 0.6};
        }).toList();
      default:
        return [];
    }
  }

  Map<String, String> get _summaryStats {
    switch (_selectedRange) {
      case 'Day':
        return {"workouts": "1", "duration": "1h 30m", "volume": "11.7k"};
      case 'Week':
        return {"workouts": "5", "duration": "6.5h", "volume": "85.6k"};
      case 'Month':
        return {"workouts": "22", "duration": "28h", "volume": "340k"};
      case 'Year':
        return {"workouts": "145", "duration": "180h", "volume": "2.1M"};
      default:
        return {"workouts": "-", "duration": "-", "volume": "-"};
    }
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _currentChartData;
    final summary = _summaryStats;
    // Default to last item if nothing selected, or just show "Average"
    final selectedItem =
        _selectedIndex != -1 && _selectedIndex < chartData.length
        ? chartData[_selectedIndex]
        : null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Statistics',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Time Range Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: ['Day', 'Week', 'Month', 'Year'].map((range) {
                  final isSelected = _selectedRange == range;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRange = range;
                          _selectedIndex = -1; // Reset selection
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF3A3A3C)
                              : Colors.transparent, // iOS style toggle
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          range,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Workouts",
                    summary["workouts"]!,
                    Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "Duration",
                    summary["duration"]!,
                    Icons.timer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "Volume",
                    summary["volume"]!,
                    Icons.bar_chart,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 3. Dynamic Chart Header
            Text(
              "$_selectedRange Volume",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // 4. Interactive Bar Chart
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(chartData.length, (index) {
                        return _buildBar(index, chartData[index]);
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 10),
                  // Dynamic Detail Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedItem != null
                            ? "${selectedItem['label']} Volume"
                            : "Average Volume",
                        style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                      ),
                      Text(
                        selectedItem != null
                            ? "${selectedItem['value']}${_selectedRange == 'Day' ? '' : ' kg'}" // Day is per-exercise maybe? strictly volume for consistency
                            : _calculateAverage(chartData),
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFFF5500),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            // 5. Muscle Split (Could also be dynamic, but static for now is fine)
            Text(
              "Muscle Split ($_selectedRange)",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildMuscleSplitList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _calculateAverage(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return "0";
    // This assumes 'value' is int. In real app, be careful.
    int sum = 0;
    for (var item in data) {
      sum += (item['value'] as int); // Explicit cast
    }
    double avg = sum / data.length;
    return "${(avg / 1000).toStringAsFixed(1)}k"; // Return e.g. "12.5k"
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, color: const Color(0xFFFF5500), size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(int index, Map<String, dynamic> data) {
    final isSelected = _selectedIndex == index;
    final double heightPct = data['height'];
    final String label = data['label'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            width: _selectedRange == 'Year'
                ? 20
                : 12, // Wider bars for Year view
            height: isSelected ? (140 * heightPct) + 10 : (140 * heightPct),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFF5500)
                  : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF5500).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 10, // Smaller font for labels
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleSplitList() {
    // Dynamic list based on range
    List<Map<String, dynamic>> splits;
    if (_selectedRange == 'Day') {
      splits = [
        {"m": "Chest", "p": 0.6, "c": const Color(0xFFFF5500), "d": "18 Sets"},
        {"m": "Triceps", "p": 0.4, "c": Colors.blue, "d": "12 Sets"},
      ];
    } else {
      splits = [
        {
          "m": "Chest",
          "p": 0.35,
          "c": const Color(0xFFFF5500),
          "d": "120 Sets",
        },
        {"m": "Back", "p": 0.25, "c": Colors.blue, "d": "85 Sets"},
        {"m": "Legs", "p": 0.20, "c": Colors.purple, "d": "60 Sets"},
        {"m": "Arms", "p": 0.15, "c": Colors.green, "d": "45 Sets"},
        {"m": "Shoulders", "p": 0.05, "c": Colors.yellow, "d": "15 Sets"},
      ];
    }

    return Column(
      children: splits
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMuscleSplitItem(
                item['m'],
                item['p'],
                item['c'],
                item['d'],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMuscleSplitItem(
    String muscle,
    double pct,
    Color color,
    String details,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              muscle,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Container(
                      height: 6,
                      width: 150 * pct,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            details,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
