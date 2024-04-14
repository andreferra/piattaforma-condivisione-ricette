import 'package:condivisionericette/screens/feed_screen/feed_screen.dart';
import 'package:condivisionericette/screens/notifiche_screen/notifiche_scren.dart';
import 'package:condivisionericette/screens/profile_screen/profile_screen.dart';
import 'package:condivisionericette/screens/setting_screen/setting_screen.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;


const List<Widget> widgetList = [
  FeedScreen(),
  NotificheScreen(),
  ProfileScreen(),
  SettingScreen(),
];