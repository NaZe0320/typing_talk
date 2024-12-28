import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:typing_talk/presentation/features/home/screens/home_screen.dart';
import 'package:typing_talk/presentation/features/practice/screens/practice_result_screen.dart';
import 'package:typing_talk/presentation/features/practice/screens/practice_screen.dart';
import 'package:typing_talk/presentation/features/practice/screens/practice_setting_screen.dart';
import 'package:typing_talk/presentation/features/profile/screens/profile_screen.dart';
import 'package:typing_talk/presentation/features/setting/screens/setting_screen.dart';
import 'package:typing_talk/presentation/features/statistic/screens/statistic_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/practice',
        name: 'practice',
        builder: (context, state) {
          return PracticeScreen();
        },
      ),
      GoRoute(
        path: '/practice-setting',
        name: 'practice-setting',
        builder: (context, state) {
          return PracticeSettingScreen();
        },
      ),
      GoRoute(
        path: '/practice-result',
        name: 'practice-result',
        builder: (context, state) {
          return PracticeResultScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) {
          return ProfileScreen();
        },
      ),
      GoRoute(
        path: '/statistic',
        name: 'statistic',
        builder: (context, state) {
          return StatisticScreen();
        },
      ),
      GoRoute(
        path: '/setting',
        name: 'setting',
        builder: (context, state) {
          return SettingScreen();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
