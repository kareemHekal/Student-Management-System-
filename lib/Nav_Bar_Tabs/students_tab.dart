
import 'package:flutter/material.dart';
import '../Appbar_TAbs/days of home page/Friday.dart';
import '../Appbar_TAbs/days of home page/Monday.dart';
import '../Appbar_TAbs/days of home page/Saturday.dart';
import '../Appbar_TAbs/days of home page/Sunday.dart';
import '../Appbar_TAbs/days of home page/Thursday.dart';
import '../Appbar_TAbs/days of home page/Tuesday.dart';
import '../Appbar_TAbs/days of home page/Wednesday.dart';
import '../colors_app.dart';


class StudentsTab extends StatelessWidget {
  const StudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Center(child: Image.asset("assets/images/1......1.png")),
        ),
        DefaultTabController(

          length: 7,
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  color: app_colors.green,
                  child: const TabBar(
                    labelColor: app_colors.orange,
                    indicatorColor: app_colors.orange,
                    indicatorWeight: 5,
                    dividerHeight: 2,
                    padding:EdgeInsets.all(0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(
                        child: Text("Sat",style:TextStyle(fontSize: 10),),
                      ),
                      Tab(
                        child: Text("Sun",style:TextStyle(fontSize: 10),),
                      ),
                      Tab(
                        child: Text("Mon",style:TextStyle(fontSize: 10),),
                      ),
                      Tab(
                        child: Text("Tue",style:TextStyle(fontSize: 10),),
                      ),
                      Tab(
                        child: Text("Wed",style:TextStyle(fontSize: 10),),
                      ),
                      Tab(
                        child: Text("Thu",style:TextStyle(fontSize: 10),),
                      ),
                      Tab(
                        child: Text("Fri",style:TextStyle(fontSize: 10),),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: TabBarView(children: [
                    Saturday(),
                    Sunday(),
                    Monday(),
                    Tuesday(),
                    Wednesday(),
                    Thursday(),
                    Friday(),
                  ]),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
