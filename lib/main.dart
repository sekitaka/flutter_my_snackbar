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
  bool _show = false;

  @override
  void initState() {
    super.initState();
    animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animationController1.addListener(() {
      print("animation listener");
    });
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
    setState(() {
      _show = !_show;
    });
    rootOverlay?.insert(entry);
  }

  void _hoge(BuildContext context) {
    animationController1.forward();
    animationController2.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // ■ScaffoldならSnackBar出る
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => _showSnackBar(context),
                child: Text("Show Snackbar")),
            ElevatedButton(
                onPressed: () => _hoge(context), child: Text("hoge")),
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                children: [
                  AlignTransition(
                      alignment: Tween<AlignmentGeometry>(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ).animate(CurvedAnimation(
                          parent: animationController1, curve: Curves.linear)),
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.pink,
                      ))
                ],
              ),
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                children: [
                  AlignTransition(
                      alignment: Tween<AlignmentGeometry>(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).animate(CurvedAnimation(
                          parent: animationController2, curve: Curves.linear)),
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.green,
                      ))
                ],
              ),
            ),
            SizedBox(
              width: 200,
              height: 350,
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    width: _show ? 200.0 : 50.0,
                    height: _show ? 50.0 : 200.0,
                    top: _show ? 50.0 : 150.0,
                    duration: const Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _show = !_show;
                        });
                      },
                      child: Container(
                        color: Colors.blue,
                        child: const Center(child: Text('Tap me')),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
