import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:dovomi/screens/home_screen.dart';
import 'package:dovomi/screens/info_screen.dart';

import '../models/money.dart' show Money;


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentindex = 0;
  Widget body= HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [Icons.home_filled,Icons.info_outline],
        inactiveColor: Colors.black54,
        activeIndex: currentindex,
        gapLocation: GapLocation.center,
        notchSmoothness:
        NotchSmoothness.smoothEdge,
        onTap:( index){
          if (index==0){
              body =HomeScreen();
          }else{
           body = InfoScreen();

          }
setState(() {
  currentindex =index;
});
        },

      ),
      body:body,
    );
  }
}
