import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenV2 extends StatefulWidget {
  const HomeScreenV2({super.key});

  @override
  State<HomeScreenV2> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Image.asset("assets/images/m2/temp_home.png",fit: BoxFit.fill,),
      ),
    );
  }
}
