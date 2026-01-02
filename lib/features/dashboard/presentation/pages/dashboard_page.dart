import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardPage({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E), // Lighter "Surface" dark color
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1), // Subtle separator line
              width: 1,
            ),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: _goBranch,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFFFF5500),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            iconSize: 24, // Standard Icon Size
            selectedLabelStyle: const TextStyle(
              fontSize: 10, // Reduced font size
              fontWeight: FontWeight.w600,
              height: 1.5, // Standard line height
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard_outlined),
                activeIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12, // Smaller indicator
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5500),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4), // Tighter spacing
                    const Icon(Icons.dashboard),
                  ],
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                // Removed extra padding for compact size
                icon: Transform.rotate(
                  angle: -0.785,
                  child: const Icon(Icons.fitness_center_outlined),
                ),
                activeIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5500),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Transform.rotate(
                      angle: -0.785,
                      child: const Icon(Icons.fitness_center),
                    ),
                  ],
                ),
                label: 'Workout',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.explore_outlined),
                activeIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5500),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.explore),
                  ],
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.settings),
                activeIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5500),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(CupertinoIcons.settings_solid),
                  ],
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
