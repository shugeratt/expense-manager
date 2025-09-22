import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:dovomi/main.dart';
import 'package:dovomi/models/money.dart';
import 'package:dovomi/screens/new_transaction.dart';
import '../ulits/constans.dart';
import 'package:dovomi/ulits/extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static List<Money> moneys = [];
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  bool isSearching = false;

  @override
  void initState() {
    MyApp.getdata();
    super.initState();
  }

  @override
  void dispose() {
   if (searchController.hasListeners){
  searchController.dispose();
   }
    super.dispose();
  }

  void _updateList() {
    setState(() {
      isSearching = false;
    });
  }

  void _performSearch(String text) {
    if (text.isEmpty) return;

    final box = Hive.box<Money>('moneyBox');
    final results = box.values
        .where((value) => value.title.contains(text) || value.date.contains(text))
        .toList();

    setState(() {
      HomeScreen.moneys.clear();
      HomeScreen.moneys.addAll(results);
      isSearching = true;
    });
  }

  void _resetSearch() {
    MyApp.getdata();
    searchController.clear();
    setState(() {
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: MyFloating(onUpdate: _updateList),
        body: Column(
          children: [
            HeaderWidget(
              onSearch: _performSearch,
              onCollapse: _resetSearch,
              searchController: searchController,
            ),
            Expanded(
              child: ValueListenableBuilder<Box<Money>>(
                valueListenable: hiveBox.listenable(),
                builder: (context, box, _) {
                  // Sync moneys only when not searching
                  if (!isSearching) {
                    HomeScreen.moneys = box.values.toList();
                  }

                  return HomeScreen.moneys.isEmpty
                      ? const NoteWidget()
                      : ListView.builder(
                    itemCount: HomeScreen.moneys.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          NewTransaction.date = HomeScreen.moneys[index].date;
                          NewTransaction.tozihatController.text = HomeScreen.moneys[index].title;
                          NewTransaction.priceController.text = HomeScreen.moneys[index].price;
                          NewTransaction.groupId = HomeScreen.moneys[index].isReceivedl ? 1 : 2;
                          NewTransaction.isEditing = true;
                          NewTransaction.id = HomeScreen.moneys[index].id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewTransaction()),
                          ).then((value) {

                            setState(() {});
                            _updateList();
                          });
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('آیا واقعا میخوای آیتم رو حذف کنی؟',
                                  style: TextStyle(fontSize: 15)),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    try {
                                      hiveBox.deleteAt(index);
                                      setState(() {});
                                      _updateList();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('خطا در حذف: $e')),
                                      );
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text('بله'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('خیر'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: MyListTileWidget(index: index),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyListTileWidget extends StatelessWidget {
  final int index;
  const MyListTileWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isReceived = HomeScreen.moneys[index].isReceivedl;
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = (screenWidth < 1004 ? 14.0 : screenWidth * 0.03).clamp(12.0, 20.0);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isReceived ? kGreenColor : kRedColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              color: Colors.white,
              isReceived ? Icons.add : Icons.remove,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              HomeScreen.moneys[index].title,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.right,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'تومان',
                    style: TextStyle(
                      fontSize: fontSize - 2,
                      color: kRedColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    HomeScreen.moneys[index].price,
                    style: TextStyle(
                      fontSize: 20,
                      color: isReceived ? kGreenColor : kRedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                HomeScreen.moneys[index].date,
                style: TextStyle(fontSize: fontSize - 2),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svgpic/pic1.svg', height: 250, width: 250),
          const SizedBox(height: 16),
          const Text(
            '! تراکنشی موجود نیست',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class MyFloating extends StatefulWidget {
  final VoidCallback onUpdate;
  const MyFloating({super.key, required this.onUpdate});

  @override
  State<MyFloating> createState() => _MyFloatingState();
}

class _MyFloatingState extends State<MyFloating> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        NewTransaction.date = 'تاریخ';
        NewTransaction.tozihatController.text = '';
        NewTransaction.priceController.text = '';
        NewTransaction.groupId = 0;
        NewTransaction.isEditing = false;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewTransaction()),
        ).then((value) {
          setState(() {

          });
          widget.onUpdate();
        });
      },
      elevation: 0,
      backgroundColor: kPurpleColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onCollapse;
  final TextEditingController searchController;

  const HeaderWidget({
    super.key,
    required this.onSearch,
    required this.onCollapse,
    required this.searchController,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool _isExpanded = false;

  @override
  void dispose() {
  //  widget.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = (screenWidth < 1004 ? 14.0 : screenWidth * 0.03).clamp(12.0, 20.0);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: SearchBarAnimation(
              onFieldSubmitted: widget.onSearch,
              textEditingController: widget.searchController,
              hintText: 'جستجو کنید',
              buttonShadowColour: Colors.black26,
              buttonBorderColour: Colors.black26,
              buttonElevation: 0,
              isOriginalAnimation: false,
              onCollapseComplete: () {
                _isExpanded = false;
                widget.onCollapse();
              },
              onExpansionComplete: () {
                _isExpanded = true;
              },
              trailingWidget: _isExpanded
                  ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  widget.searchController.clear();
                  widget.onCollapse();
                },
              )
                  : const SizedBox(),
              secondaryButtonWidget: const Icon(Icons.search, color: Colors.grey),
              buttonWidget: const Icon(Icons.search, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'تراکنش ها',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}