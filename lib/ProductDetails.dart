
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  String something;
  SecondPage(this.something);
  @override
  State<StatefulWidget> createState() {
    return SecondPageState(this.something);
  }
}
class SecondPageState extends State<SecondPage> {
  String something;
  SecondPageState(this.something);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
    //now you have passing variable
    title: Text(something),
   ),
   );
  }

  }