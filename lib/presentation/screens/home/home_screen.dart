import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/presentation/blocs/notification/notification_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(context),
      body: ListView(itemExtent: 0),
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
