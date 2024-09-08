import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:p2p_chat/screens/home_screen.dart';
import 'package:p2p_chat/providers/user_provider.dart';
import 'package:p2p_chat/providers/chat_provider.dart';
import 'package:p2p_chat/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P2P Chat',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
