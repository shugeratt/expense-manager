import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:dovomi/models/money.dart';
import 'package:dovomi/screens/home_screen.dart';
import 'package:dovomi/screens/main_screen.dart';


void main()async{
await Hive.initFlutter();
Hive.registerAdapter(MoneyAdapter());
await Hive.openBox<Money>('moneyBox');
runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static void getdata(){
    HomeScreen.moneys.clear();
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    for (var value in hiveBox.values){
      HomeScreen.moneys.add(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'اپلیکیشن مدیریت مالی',
      theme: ThemeData(fontFamily: 'Digi_Koodak_Bold'),
      home: MainScreen(),
    );
  }
}
