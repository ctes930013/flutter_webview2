import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  const Result({Key? key, required this.value}) : super(key: key);

  //接收由上一頁傳入的值
  final String value;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Scaffold(
        appBar: AppBar(
          title: const Text("原生App"),
        ),
        body:
        SingleChildScrollView(
          child: Text(value),
        ),
      );
  }
}