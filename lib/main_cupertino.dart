import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_snackbar/my_snackbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
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
  late AnimationController animationController1;
  late AnimationController animationController2;

  @override
  void initState() {
    super.initState();
    animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animationController2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  void _showSnackBar(BuildContext context) async {
    showMySnackBar(context: context, message: "message");
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
                child: Text("独自Snackbarを標示")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (c){
                    return MyHomePage();
                  }));
                },
                child: Text("次の画面へ")),
          ],
        ),
      ),
    );
  }
}
