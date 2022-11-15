import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final route = ModalRoute.of(context);
    final width = MediaQuery.of(context).size.width;
    final rootOverlay = Navigator.of(context, rootNavigator: true).overlay;
    if (animationController1.isCompleted) {
      animationController1.reverse();
      return;
    }

    final bodyHeight = 60;
    final bodyHeightWithSafeArea =
        bodyHeight + MediaQuery.of(context).padding.bottom;
    final body = Container(
      width: width,
      height: bodyHeightWithSafeArea,
      color: Colors.amber,
    );
    final entry = OverlayEntry(
        builder: (context) {
          return Container(
            alignment: Alignment.bottomCenter,
            child: GridPaper(
              child: SizedBox(
                height: bodyHeightWithSafeArea,
                width: width,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 1),
                          end: Offset(0, 0),
                        ).animate(animationController1),
                        child: body)
                  ],
                ),
              ),
            ),
          );
        },
        maintainState: true)
      ..addListener(() async {
        animationController1.forward();
      });
    rootOverlay?.insert(entry);
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("独自SnackBarの作り方"),),
      // ■ScaffoldならSnackBar出る
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => _showSnackBar(context),
                child: Text("Show Snackbar")),
          ],
        ),
      ),
    );
  }
}
