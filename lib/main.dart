import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/config/notifications/app_firebase_notification.dart';
import 'package:push_app/config/notifications/app_local_notification.dart';

import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/config/theme/app_theme.dart';
import 'package:push_app/presentation/blocs/notification/notification_bloc.dart';
import 'package:push_app/presentation/blocs/permission/permission_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppFirebaseNotification.initializeFCM();
  await AppLocalNotification.initialize();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) => NotificationBloc(
              onForengroundNotificationMessage: FirebaseMessaging.onMessage,
              showLocalNotification: AppLocalNotification.showLocalNotification,
            )),
    BlocProvider(create: (context) => PermissionCubit()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
