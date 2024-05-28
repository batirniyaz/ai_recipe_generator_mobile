import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_recipe_generator_mobile/pages/LoginPage.dart';
import 'package:ai_recipe_generator_mobile/pages/FreeUserPage.dart';
import 'package:ai_recipe_generator_mobile/pages/PremiumUserPage.dart';
import 'package:ai_recipe_generator_mobile/pages/HistoryPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(child: LoginPage()),
    ),
    GoRoute(
      path: '/free_user',
      pageBuilder: (context, state) => MaterialPage(child: FreeUserPage()),
    ),
    GoRoute(
      path: '/premium_user',
      pageBuilder: (context, state) => MaterialPage(child: PremiumUserPage()),
    ),
    GoRoute(
      path: '/food_history',
      pageBuilder: (context, state) => MaterialPage(child: HistoryPage()),
    ),
  ],
);
