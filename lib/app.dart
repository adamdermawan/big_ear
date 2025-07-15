import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import cubits (ViewModels)
import 'modules/home/viewmodels/home_cubit.dart';
// import 'modules/ai_chat/viewmodels/ai_chat_cubit.dart';
// import 'modules/items/viewmodels/item_cubit.dart';
// import 'modules/user/viewmodels/user_cubit.dart';

// Import initial screen
import 'modules/home/views/home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        // BlocProvider(create: (_) => AIChatCubit()),
        // BlocProvider(create: (_) => ItemCubit()),
        // BlocProvider(create: (_) => UserCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elephant App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeView(), // you can route to others based on logic later
      ),
    );
  }
}
