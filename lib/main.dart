import 'package:flutter/material.dart';
import 'package:flutterwebview2/web.dart';

void main() => runApp(MaterialApp(
  home: HomePage(),
));

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  TextEditingController keyText = TextEditingController();      //欄位輸入框

  //按鈕觸發事件
  void submit(context) {
    String txt = keyText.value.text;
    if(txt == ""){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("請勿為空"),
      ));
      return;
    }

    //換頁
    Navigator.push(context, MaterialPageRoute(builder: (context) => Web(
      txt: txt,
    )));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //debugPaintSizeEnabled = true;
    return Scaffold(
        appBar: AppBar(
          title: const Text("原生App"),
        ),
        body:
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: keyText,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    labelText: "請輸入要傳入WebView的值",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: MaterialButton(
                      child: const Text(
                          '送出',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          )
                      ),
                      color: Colors.blueAccent,
                      onPressed: () => {
                        submit(context)
                      }
                  ),
                )
              ]
          ),
        )
    );
  }
}