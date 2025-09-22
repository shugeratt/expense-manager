import 'package:dovomi/ulits/calculate.dart';
import 'package:dovomi/widget/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:dovomi/ulits/extension.dart';
class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      body:SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20,top: 20),
              child: Text('مدیریت تراکنشها به تومان',style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth * 0.03),),
            )
            ,
                MoneyinfoWigdet(FirstPrise: Calculate.dToday().toString(),
                  FirstText: ':  دریافتی امروز',
                  SecendPrice:Calculate.pToday().toString(),
                  SecendText: ':  پرداختی امروز',),
            MoneyinfoWigdet(FirstPrise: Calculate.dMonth().toString(),
              FirstText: ':  دریافتی این ماه',
              SecendPrice:Calculate.pMonth().toString(),
              SecendText: ':  پرداختی این ماه',),
            MoneyinfoWigdet(FirstPrise: Calculate.dYear().toString(),
              FirstText: ':  دریافتی امسال',
              SecendPrice:Calculate.pYear().toString(),
              SecendText: ':  پرداختی امسال',),
          SizedBox(height: 20,),
            Calculate.dYear() == 0 && Calculate.pYear() ==0 ? Container() :
            Container(
              padding: const EdgeInsets.all(20.0),
              height: 200,
              child: const BarChartWidget(),
            ),
          ],
        ),
      )
      ),
    );
  }
}

class MoneyinfoWigdet extends StatelessWidget {
  final String? FirstText;
  final String? FirstPrise;
  final String? SecendText;
  final String? SecendPrice;
MoneyinfoWigdet({required this.FirstText,required this.FirstPrise,required this.SecendText,required this.SecendPrice,})

  ;@override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.only(top: 20,right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Text(FirstPrise!,
            style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth * 0.03),
            textAlign:TextAlign.right,)),
          Expanded(child: Text(FirstText!,
              style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth * 0.03),textAlign:TextAlign.right))
          ,
          Expanded(child: Text(SecendPrice!,
              style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth * 0.03),textAlign:TextAlign.right)),
          Expanded(child: Text(SecendText!,
              style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth * 0.03),textAlign:TextAlign.right))],
      ),
    );
  }
}
