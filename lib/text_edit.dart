import 'package:flutter/material.dart';

class TextEdit extends StatefulWidget{

  const TextEdit({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TextEditState();
  }
}

class TextEditState extends State<TextEdit> {

  TextEditingController textController = TextEditingController();      //欄位輸入框

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      TextField(
        controller: textController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          icon: Icon(Icons.title),
          labelText: "請輸入要傳入WebView的值",
        ),
      );
  }

  String getValue(){
    return textController.value.text;
  }
}