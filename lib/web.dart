import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterwebview2/result.dart';
import 'package:flutterwebview2/text_edit.dart';

class Web extends StatefulWidget{

  //接收由上一頁傳入的值
  final String txt;

  const Web({Key? key, required this.txt}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WebState();
  }
}

class _WebState extends State<Web> {

  final GlobalKey<TextEditState> textEditKey = GlobalKey();
  //定義webview的url
  final String url = "lib/assets/flutter.html";
  late String txt;
  late InAppWebViewController _controller;
  //紀錄原本的web content
  String originWebContent = "";
  //紀錄重組過後的web content
  String newWebContent = "";
  @override
  Widget build(BuildContext context) {
    //接收由上一頁傳入的值
    txt = widget.txt;

    return Scaffold(
      appBar: AppBar(
        title: const Text("WebView"),
      ),
      body:
        Column(
          children: [
            //app輸入框
            Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 250,
                    child: TextEdit(
                      key: textEditKey,
                    ),
                  ),
                  Expanded(
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
                  ),
                ],
              ),
            ),
            //webview
            Expanded(
                child: InAppWebView(
                  initialFile: url,
                  //initialData: InAppWebViewInitialData(data: newWebContent),
                  initialOptions: webOptions(),
                  onWebViewCreated: (controller) {
                    webController(controller);
                  },
                  onLoadStart: (controller, url) {
                    //避免重複加載
                    if(originWebContent == ""){
                      resetWebContent(txt);
                    }
                  },
                ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showWebCotent();
          },
          tooltip: '內文',
          child: const Text('內文'),
        ),
    );
  }

  final String htmlShowStr = "window.document.getElementsByTagName('html')[0].outerHTML;";    //取得網頁內文的js語法
  //顯示網頁內文
  showWebCotent() {
    _controller.evaluateJavascript(source: htmlShowStr).then((result) {
      //換頁
      Navigator.push(context, MaterialPageRoute(builder: (context) => Result(
        value: result,
      )));
    });
  }

  //重組內文
  resetWebContent(String txt){
    _controller.evaluateJavascript(source: htmlShowStr).then((result) {
      if(originWebContent == ""){
        //get web content
        originWebContent = result;
      }
      //加上使用者輸入的字符
      newWebContent = originWebContent + "<h4>從原生App傳入的值: "+txt+"</h4>";
      _controller.loadData(data: newWebContent);
    });
  }

  //webview的設定
  InAppWebViewGroupOptions webOptions(){
    return InAppWebViewGroupOptions(
        android: AndroidInAppWebViewOptions(
            useHybridComposition: true    //解決部分android裝置不能輸入中文問題
        )
    );
  }

  //webview的控制器
  InAppWebViewController webController(controller){
    _controller = controller
    // ..addJavaScriptHandler(      //傳值給web端
    //   handlerName: 'fromFlutter',
    //   callback: (data) {
    //     return txt;    //send data to web
    //   },
    // )
      ..addJavaScriptHandler(      //監聽web端傳入的值
        handlerName: 'toFlutter',
        callback: (data) {
          //show web message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Web端回傳的值: ${data[0]}"),
          ));    //get data from web
        },
      )
      ..addJavaScriptHandler(      //監聽web端傳入的換頁
        handlerName: 'toFlutterPage',
        callback: (data) {
          //檢查點擊事件連結的開頭
          String urlScheme = data[0];
          if(urlScheme.startsWith("flutterweb2://")) {
            String scheme = urlScheme.split("://")[0] ?? '';
            String host = urlScheme.split("://")[1] ?? '';
            if(host.startsWith("result")){
              //移除該頁面
              //Navigator.pop(context);
              //換頁
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Result(
                value: "這是原生App",
              )));
              //webview不要換頁
            }
          }  //get data from web
        },
      );
    return _controller;
  }

  //傳值到webview按鈕觸發事件
  void submit(context) {
    String txt = textEditKey.currentState?.getValue() ?? "";
    if(txt == ""){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("請勿為空"),
      ));
      return;
    }

    resetWebContent(txt);
  }
}