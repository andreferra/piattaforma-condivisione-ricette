import 'package:condivisionericette/screens/feed_screen/feed_screen.dart';
import 'package:condivisionericette/screens/notifiche_screen/notifiche_scren.dart';
import 'package:condivisionericette/screens/profile_screen/profile_screen.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/add_recipes_screen.dart';
import 'package:condivisionericette/screens/recipes/recipes_screen/recipes_screen.dart';
import 'package:condivisionericette/screens/setting_screen/setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageControllerProvider = ChangeNotifierProvider<PageController>((ref) {
  return PageController();
});

class PageController extends ChangeNotifier {
  static const List<Widget> widgetList = [
    FeedScreen(),
    RecipesScreen(),
    NotificheScreen(),
    ProfileScreen(),
    SettingScreen(),
    AddRecipesScreen(),
  ];
  int _currentIndex = 5;

  int get currentIndex => _currentIndex;

  Widget get currentPage => widgetList[_currentIndex];

  void setPage(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
