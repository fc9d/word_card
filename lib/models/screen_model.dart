import 'package:flutter/material.dart';

import '../screens/card_screen.dart';
import '../screens/edit_screen.dart';
import '../screens/game_screen.dart';

class ScreenModel {
  String title;
  Widget screen;
  Icon icon;
  bool isSelected;

  ScreenModel({
    required this.title,
    required this.screen,
    required this.icon,
    this.isSelected = false,
  });

  static List<ScreenModel> screens() {
    return [
      ScreenModel(
        title: '카드',
        screen: const CardScreen(),
        icon: const Icon(Icons.local_fire_department_rounded),
        isSelected: true,
      ),
      ScreenModel(
        title: '게임',
        screen: const GameScreen(),
        icon: const Icon(Icons.games_rounded),
      ),
      ScreenModel(
        title: '수정',
        screen: const EditScreen(),
        icon: const Icon(Icons.edit),
      ),
    ];
  }
}
