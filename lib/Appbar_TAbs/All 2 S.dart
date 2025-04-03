import 'package:flutter/cupertino.dart';

import '../Magmo3as.dart';
import '../studetnstreambuilder.dart';

class SecondS extends StatelessWidget {
  const SecondS({super.key});

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
    ),StudentStreamBuilder(grade: "2 secondary",)]);;
  }
}
