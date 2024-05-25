import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/screens/home/home_screen.dart';
import 'package:push_app/presentation/screens/post/post_detail_screen.dart';

getDetailPath(String postId) {
  return '/home/post-detail/$postId';
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/home',
    ),
    GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'post-detail/:id',
            builder: (context, state) {
              final postId = state.pathParameters['id'] ?? '';
              return PostDetailScreen(postId: postId);
            },
          ),
        ]),
  ],
);
