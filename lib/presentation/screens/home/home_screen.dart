import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/domain/entities/post.dart';
import 'package:push_app/presentation/blocs/notification/notification_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(context),
      body: const _HomeView(),
    );
  }

  AppBar _customAppBar(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Push notificación'),
          context.select(
            (NotificationBloc bloc) =>
                Text(bloc.state.status.toString(), style: textStyle.titleSmall),
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              context.read<NotificationBloc>().requestAuthorization();
            },
            icon: const Icon(Icons.settings))
      ],
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      context.read<NotificationBloc>().loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = context.watch<NotificationBloc>().state.posts;
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.push(getDetailPath(posts[index].postId));
          },
          child: _PostItem(post: posts[index]),
        );
      },
    );
  }
}

class _PostItem extends StatelessWidget {
  const _PostItem({
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        height: 150,
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(20),
                child: Image.network(post.urlImage),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: textStyle.titleLarge,
                    ),
                    Text(post.caption ?? ''),
                    const Expanded(child: SizedBox()),
                    Text('${post.published}')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
