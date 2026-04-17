import 'package:firebase_practice/core/routes/app_route_names.dart';
import 'package:firebase_practice/core/routes/app_route_paths.dart';
import 'package:firebase_practice/core/routes/router_refresh_stream.dart';
import 'package:firebase_practice/features/auth/presentation/controllers/auth_controller.dart';
import 'package:firebase_practice/features/auth/presentation/screens/login_screen.dart';
import 'package:firebase_practice/features/tasks/presentation/screens/task_detail_screen.dart';
import 'package:firebase_practice/features/tasks/presentation/screens/task_form_screen.dart';
import 'package:firebase_practice/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final RouterRefreshStream refreshListenable = RouterRefreshStream(
    ref.watch(firebaseAuthProvider).authStateChanges(),
  );
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: AppRoutePaths.tasks,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final bool isAuthenticated =
          ref.read(firebaseAuthProvider).currentUser != null;
      final bool isGoingToLogin = state.matchedLocation == AppRoutePaths.login;

      if (!isAuthenticated) {
        return isGoingToLogin ? null : AppRoutePaths.login;
      }

      if (isGoingToLogin) {
        return AppRoutePaths.tasks;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePaths.login,
        name: AppRouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.tasks,
        name: AppRouteNames.tasks,
        builder: (context, state) => const TaskListScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'new',
            name: AppRouteNames.newTask,
            builder: (context, state) => const TaskFormScreen(),
          ),
          GoRoute(
            path: ':taskId',
            name: AppRouteNames.taskDetail,
            builder: (context, state) =>
                TaskDetailScreen(taskId: state.pathParameters['taskId']!),
            routes: <RouteBase>[
              GoRoute(
                path: 'edit',
                name: AppRouteNames.taskEdit,
                builder: (context, state) =>
                    TaskFormScreen(taskId: state.pathParameters['taskId']!),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
