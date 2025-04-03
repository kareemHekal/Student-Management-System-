import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../loadingFile/loadingWidget.dart';
import '../cards/magmo3afor display widget.dart';
import '../models/Magmo3aModel.dart';

class ChoosedaysToAttend extends StatefulWidget {
  final String? level;
  ChoosedaysToAttend({this.level, super.key});

  @override
  _SeconddayState createState() => _SeconddayState();
}

class _SeconddayState extends State<ChoosedaysToAttend> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with two tabs
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    // Dispose the controller to free up resources
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: app_colors.orange),
        ),
        backgroundColor: app_colors.green,
        title: Image.asset(
          "assets/images/2....2.png",
          height: 100,
          width: 90,
        ),
        toolbarHeight: 120,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Saturday"),
            Tab(text: "Sunday"),
            Tab(text: "Monday"),
            Tab(text: "Tuesday"),
            Tab(text: "Wednesday"),
            Tab(text: "Thursday"),
            Tab(text: "Friday"),

          ],
          indicatorColor: app_colors.orange,
          labelColor: app_colors.orange,
          unselectedLabelColor: app_colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGroupList("Saturday"), // Stream for Saturday
          _buildGroupList("Sunday"),   // Stream for Sunday
          _buildGroupList("Monday"),   // Stream for Monday
          _buildGroupList("Tuesday"),  // Stream for Tuesday
          _buildGroupList("Wednesday"),// Stream for Wednesday
          _buildGroupList("Thursday"), // Stream for Thursday
          _buildGroupList("Friday"),   // Stream for Friday
          // Stream for Tuesday
        ],
      ),
    );
  }

  Widget _buildGroupList(String day) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Center(child: Image.asset("assets/images/1......1.png")),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Text(
                  " Just Pick the Group ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: app_colors.green, fontSize: 30),
                ),
                SizedBox(height: 20),
                StreamBuilder<List<Magmo3amodel>>(
                  stream: FirebaseFunctions.getAllDocsFromDayWithGrade(day, widget.level ?? ""),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: DiscreteCircle(
                          color: app_colors.green,
                          size: 30,
                          secondCircleColor: app_colors.ligthGreen,
                          thirdCircleColor: app_colors.orange,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Text("Something went wrong"),
                            ElevatedButton(
                              onPressed: () {
                                // Optionally implement retry logic here
                              },
                              child: Text('Try Again'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Directly use snapshot.data as a List<Magmo3amodel>
                    var Magmo3as = snapshot.data ?? [];

                    if (Magmo3as.isEmpty) {
                      return Center(
                        child: Text(
                          "No groups",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 25, color: app_colors.black),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: 12,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, Magmo3as[index]);
                            },
                            child: Magmo3aWidgetWithoutSlidable(
                              magmo3aModel: Magmo3as[index],
                            ),
                          );
                        },
                        itemCount: Magmo3as.length,
                      ),
                    );
                  },
                )

              ],
            ),
          ),
        ),
      ],
    );
  }
}
