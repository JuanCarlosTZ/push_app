import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/domain/entities/post.dart';
import 'package:push_app/presentation/blocs/notification/notification_bloc.dart';
import 'package:push_app/presentation/shared/custom_icon_action.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final post = context.watch<NotificationBloc>().postById(postId);

    return Scaffold(body: _DetailView(post: post));
  }
}

class _DetailView extends StatelessWidget {
  final Post? post;
  const _DetailView({this.post});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (post == null) {
      return const Center(child: Text('Notificacion no entontrada'));
    }

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverAppBar(
            leading: CustomIconAction(onPressed: () => context.pop()),
            expandedHeight: 0.3 * size.height,
            flexibleSpace: _CustomSliverAppbar(post!.urlImage)),
        SliverList(
            delegate:
                SliverChildBuilderDelegate(childCount: 1, (context, index) {
          return SafeArea(top: false, child: _CustomSliverItem(post!));
        })),
      ],
    );
  }
}

class _CustomSliverAppbar extends StatelessWidget {
  final String url;
  const _CustomSliverAppbar(this.url);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Image.network(url),
    );
  }
}

class _CustomSliverItem extends StatelessWidget {
  final Post post;
  const _CustomSliverItem(this.post);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: textStyle.titleLarge,
          ),
          Text(post.caption ?? ''),
          Text('${post.published}'),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
