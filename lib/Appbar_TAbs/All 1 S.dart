
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Magmo3as.dart';
import '../studetnstreambuilder.dart';

class FirstS extends StatelessWidget {
  const FirstS({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [Column
      (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Center(child: Image.asset("assets/images/1......1.png")),
        ),
        SizedBox(height: 50)
      ],
    ),StudentStreamBuilder(grade: "1 secondary",)]);
  }
}
