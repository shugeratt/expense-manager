

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dovomi/main.dart';
import 'package:dovomi/models/money.dart';
import 'package:dovomi/screens/home_screen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'dart:math' as math;
import '../ulits/constans.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:dovomi/ulits/extension.dart';

class NewTransaction extends StatefulWidget {
   NewTransaction({super.key});
  static int groupId=0;
  static TextEditingController tozihatController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing= false;
  static int id=0;
static String date = 'تاریخ';


  @override
  State<NewTransaction> createState() => _NewTransactionState();
}



class _NewTransactionState extends State<NewTransaction> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
       body:SafeArea(child:  Container(
         width: double.infinity,
         margin: EdgeInsets.all(20),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(NewTransaction.isEditing ? 'ویرایش تراکنش' : 'تراکنش جدید',
              style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth * 0.03),),
         SizedBox(
           height: 20,
         ),
            MyFiuldWidget(title: 'توضیحات',controller: NewTransaction.tozihatController,),
            SizedBox(
              height: 20,
            ),
           MyFiuldWidget(title: 'مبلغ',controller:  NewTransaction.priceController,),

SizedBox(
  height: 20,
),
          TypeandDateWidget()
          ,
          MyButton()
          ],
               ),
       ),
    ));
  }
}

class MyButton extends StatefulWidget {
   MyButton({
    super.key,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  late Box<Money> hiveBox;
@override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity,
        child: ElevatedButton(
          onPressed: (){
            if (NewTransaction.date == 'تاریخ') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('لطفاً تاریخ را انتخاب کنید!'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            if (NewTransaction.tozihatController.text.isEmpty ||
                NewTransaction.priceController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('همه فیلدها را پر کنید!'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            Box<Money> hiveBox = Hive.box<Money>('moneyBox');
          Money item =Money(

              id:math.Random().nextInt(999999),
              title: NewTransaction.tozihatController.text,
              price: NewTransaction.priceController.text,
              date:NewTransaction.date,
              isReceivedl: NewTransaction.groupId ==1 ? true : false);
          if(NewTransaction.isEditing){
            int? foundIndex = null;
            MyApp.getdata();
            for (int i =0;i<hiveBox.values.length;i++){
              Money? currentItem = hiveBox.getAt(i);
              if(hiveBox.getAt(i)?.id == NewTransaction.id){
                foundIndex = i;
                break;
              }
            }
            if (foundIndex == null || foundIndex >= hiveBox.length) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تراکنش پیدا نشد')),
              );
              Navigator.pop(context, true);
              return;
          }
            hiveBox.putAt(foundIndex, item);
          }else {
            hiveBox.add(item);
            }
          MyApp.getdata();
            Navigator.pop(context, true);
        },style: TextButton.styleFrom(elevation: 0,backgroundColor: kPurpleColor),
      child: Text(NewTransaction.isEditing ? 'ویرایش کردن' :"اضافه کردن" ,style: TextStyle( fontSize: 20,color: Colors.white),),));
  }
}





class TypeandDateWidget extends StatefulWidget {
  const TypeandDateWidget({
    super.key,
  });

  @override
  State<TypeandDateWidget> createState() => _TypeandDateWidgetState();
}

class _TypeandDateWidgetState extends State<TypeandDateWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [

          Expanded(
            child: Radio(value: 1, groupValue: NewTransaction.groupId, onChanged:(value){
                setState(() {
                NewTransaction.groupId = value!;
              });
            } ),
          ),
        Text('دریافتی',style: TextStyle(fontSize: 20),),

        Expanded(
          child: Radio(value: 2, groupValue: NewTransaction.groupId, onChanged:(value){
            setState(() {
              NewTransaction.groupId = value!;
            });
          } ),
        ),
        Text('پرداختی',style: TextStyle(fontSize: 20),),
const SizedBox(width: 10,)
         ,OutlinedButton(onPressed: ()async {
            var pickdate = await showPersianDatePicker(
              context: context,
              initialDate: Jalali.now(),
              firstDate: Jalali(1404),
              lastDate: Jalali(1499),
            );
            setState(() {
              String year = pickdate!.year.toString();
              String month = pickdate.month.toString().length==1? "0${pickdate.month.toString()}" : pickdate.month.toString();
              String day = pickdate.day.toString().length==1? "0${pickdate.day.toString()}" : pickdate.day.toString();
              NewTransaction.date = pickdate!.year.toString();

            NewTransaction.date = year+'/'+month+'/'+day;
            });

          }, child: Text(NewTransaction.date,
              style:const TextStyle(color: Colors.black,fontSize: 12),

          ),
          ),
        ],
    );
  }
}

class MyFiuldWidget extends StatelessWidget {

String? title;
TextEditingController controller;
MyFiuldWidget({
  this.title
  ,required this.controller
,})
  ;@override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.grey.shade300,
      decoration: InputDecoration(hintText: title,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),)
          ,enabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)
          )
      ,focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)
          ),
      ),

    );
  }
}
