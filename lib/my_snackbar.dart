import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showMySnackBar(
    {required BuildContext context,
    required String message,
    VoidCallback? onOkTapped}) {
  MySnackBarController(
      context: context, message: message, onOkTapped: onOkTapped)
    ..show();
}

class MySnackBarController {
  late AnimationController controller;
  late OverlayState overlay;
  OverlayEntry? overlayEntry;
  String message;
  VoidCallback? onOkTapped;
  bool isDismissing = false;

  BuildContext context;

  MySnackBarController(
      {required this.context,
      required this.message,
      VoidCallback? onOkTapped}) {
    // final rootOverlay = Navigator.of(context, rootNavigator: true).overlay;
    final rootOverlay = Overlay.of(context);
    overlay = rootOverlay!;
    controller = AnimationController(
        vsync: rootOverlay!, duration: const Duration(seconds: 2))
      ..addStatusListener((status) {
        print("animation status changed:${status}");
        if (isDismissing == true && status == AnimationStatus.dismissed){
          print("Remove overlay");
          overlayEntry?.remove();
        }
      });
    this.onOkTapped = () {
      dismiss();
      if (onOkTapped != null) {
        onOkTapped();
      }
    };
  }

  dismiss() {
    isDismissing = true;
    controller.reverse();
  }

  show() {
    final width = MediaQuery.of(context).size.width;
    final bodyHeight = 60;
    final safeAreaHeight = MediaQuery.of(context).padding.bottom;
    final bodyHeightWithSafeArea = bodyHeight + safeAreaHeight;

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
                        ).animate(controller),
                        child: MySnackBar(
                          message: message,
                          onOkTapped: onOkTapped,
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        maintainState: true)
      ..addListener(() async {
        controller.forward();
      });
    overlayEntry = entry;
    overlay.insert(entry);
  }
}

class MySnackBar extends StatefulWidget {
  String message;
  VoidCallback? onOkTapped;

  MySnackBar({required this.message, this.onOkTapped});

  @override
  State createState() => _MySnackBarState();
}

class _MySnackBarState extends State<MySnackBar> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  void _onOkTapped() {
    if (widget.onOkTapped != null) {
      widget.onOkTapped!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bodyHeight = 60;
    final safeAreaHeight = MediaQuery.of(context).padding.bottom;
    final bodyHeightWithSafeArea = bodyHeight + safeAreaHeight;
    final body = Container(
      width: width,
      height: bodyHeightWithSafeArea,
      color: Colors.amber,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: safeAreaHeight, left: 16, top: 8, right: 16),
        child: GridPaper(
          color: Colors.green,
          child: Row(
            children: [
              Expanded(child: Text(widget.message)),
              SizedBox(
                width: 8,
              ),
              TextButton(onPressed: () => _onOkTapped(), child: Text("OK")),
            ],
          ),
        ),
      ),
    );
    return body;
  }
}
