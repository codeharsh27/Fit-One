import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tandurast/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:tandurast/features/home/presentation/pages/home_page.dart';
import 'package:tandurast/features/workout/presentation/pages/workout_page.dart';
import 'package:tandurast/features/meal/presentation/pages/meal_page.dart';
import 'package:tandurast/features/profile/presentation/pages/profile_page.dart';

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
  initialLocation: '/home',
  routes: <RouteBase>[
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
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _sectionCNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/meal',
              builder: (BuildContext context, GoRouterState state) =>
                  const MealPage(),
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
            ),
          ],
        ),
      ],
    ),
  ],
);
