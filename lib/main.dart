import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_snackbar/my_snackbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MySnackBarNavigationObserver mySnackBarNavigationObserver =
      MySnackBarNavigationObserver();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // 画面遷移のタイミングで表示されているSnackBarを非表示にする
      navigatorObservers: [mySnackBarNavigationObserver],
      // MaterialAppならSnackBar出る
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _showSnackBar(BuildContext context) async {
    final messageId = Random().nextInt(4);
    final String message;
    switch (messageId) {
      case 0:
        message = "message";
        break;
      case 1:
        message =
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in\$";
        break;
      case 2:
        message = "メッセージ";
        break;
      case 3:
        message =
            "私はすべてどうしてもその道楽顔とともにののうちにあっんた。もし多数を反抗家はおそらくその説明ですただってが考えでいるですには成就聞いでんて、そうには当てたでしたた。偽りを当てるだものも初めて今がじっとないなう。\$";
        break;
      default:
        message = "message";
    }
    showMySnackBar(context: context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("独自SnackBarの作り方"),
      ),
      // ■ScaffoldならSnackBar出る
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => _showSnackBar(context),
                child: Text("独自Snackbar")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (c) {
                    return MyHomePage();
                  }));
                },
                child: Text("次の画面へ")),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: CupertinoTextField(controller: _textEditingController,),
            )
          ],
        ),
      ),
    );
  }
}
