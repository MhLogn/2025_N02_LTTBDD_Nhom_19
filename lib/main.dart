import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:my_project/core/theme/app_theme.dart';
import 'package:my_project/core/di/injection.dart' as di;
import 'package:my_project/core/di/injection.dart';
import 'package:my_project/firebase_options.dart';

import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/Chat/chatRoom_cubit.dart';
import 'package:my_project/presentation/Chat/chatList_cubit.dart';
import 'package:my_project/presentation/Chat/message_cubit.dart';
import 'package:my_project/presentation/language/locale_cubit.dart';
import 'package:my_project/presentation/auth/cubit/auth_cubit.dart';
import 'package:my_project/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<ChatCubit>()),
        BlocProvider(create: (_) => sl<ChatRoomCubit>()),
        BlocProvider(create: (_) => sl<MessageCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            locale: locale,

            supportedLocales: const [Locale('en'), Locale('vi')],

            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            theme: AppTheme.lightTheme,

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
