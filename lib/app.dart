import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import cubits (ViewModels)
import 'modules/home/viewmodels/home_cubit.dart';
import 'modules/ai_chat/viewmodels/ai_chat_cubit.dart';
import 'modules/items/viewmodels/items_cubit.dart';
import 'modules/user/viewmodels/user_cubit.dart';

// Import main navigation widget
import 'modules/shared/views/main_navigation.dart'; // <-- your new widget

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => AiChatCubit()),
        BlocProvider(create: (_) => ItemsCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elephant App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Ubuntu',
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        home: const MainNavigation(), // <-- Use global navigation here
      ),
    );
  }
}
