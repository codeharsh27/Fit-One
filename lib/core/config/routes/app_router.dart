import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tandurast/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:tandurast/features/home/presentation/pages/home_page.dart';
import 'package:tandurast/features/workout/presentation/pages/workout_page.dart';
import 'package:tandurast/features/workout/presentation/pages/workout_history_page.dart';
import 'package:tandurast/features/workout/presentation/pages/workout_stats_page.dart';
import 'package:tandurast/features/workout/presentation/pages/active_workout_page.dart';
import 'package:tandurast/features/workout/presentation/pages/exercise_selection_page.dart';

import 'package:tandurast/features/workout/presentation/pages/new_routine_page.dart';
import 'package:tandurast/features/workout/presentation/pages/explore_page.dart';
import 'package:tandurast/features/workout/presentation/pages/explore_category_page.dart';
import 'package:tandurast/features/workout/presentation/pages/program_detail_page.dart';

import 'package:tandurast/features/profile/presentation/pages/profile_page.dart';
import 'package:tandurast/features/profile/presentation/pages/edit_profile_page.dart';

import 'package:tandurast/features/auth/presentation/pages/splash_page.dart';
import 'package:tandurast/features/auth/presentation/pages/login_page.dart';
import 'package:tandurast/features/auth/presentation/pages/signup_page.dart';
import 'package:tandurast/features/onboarding/presentation/pages/onboarding_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _sectionBNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _sectionCNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _sectionDNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder:
          (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            return DashboardPage(navigationShell: navigationShell);
          },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _sectionANavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              builder: (BuildContext context, GoRouterState state) =>
                  const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _sectionBNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/workout',
              builder: (BuildContext context, GoRouterState state) =>
                  const WorkoutPage(),
              routes: [
                GoRoute(
                  path: 'history',
                  builder: (BuildContext context, GoRouterState state) =>
                      const WorkoutHistoryPage(),
                ),
                GoRoute(
                  path: 'stats',
                  builder: (BuildContext context, GoRouterState state) =>
                      const WorkoutStatsPage(),
                ),
                GoRoute(
                  path: 'active',
                  parentNavigatorKey:
                      _rootNavigatorKey, // Full screen mode, hide bottom nav
                  builder: (BuildContext context, GoRouterState state) =>
                      const ActiveWorkoutPage(),
                ),
                GoRoute(
                  path: 'exercise-select',
                  parentNavigatorKey: _rootNavigatorKey, // Full screen mode
                  builder: (BuildContext context, GoRouterState state) =>
                      const ExerciseSelectionPage(),
                ),

                GoRoute(
                  path: 'new-routine',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const NewRoutinePage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _sectionCNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/explore',
              builder: (BuildContext context, GoRouterState state) =>
                  const ExplorePage(),
              routes: [
                GoRoute(
                  path: 'category/:name',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    return ExploreCategoryPage(
                      categoryName: state.pathParameters['name']!,
                    );
                  },
                ),
                GoRoute(
                  path: 'program/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    return ProgramDetailPage(
                      programId: state.pathParameters['id']!,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _sectionDNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              builder: (BuildContext context, GoRouterState state) =>
                  const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'edit',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const EditProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
