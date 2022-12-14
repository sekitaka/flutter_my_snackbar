import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// SnackBarを表示する
showMySnackBar(
    {required BuildContext context,
    required String message,
    VoidCallback? onOkTapped}) {
  final controller = _MySnackBarController(
      context: context, message: message, onOkTapped: onOkTapped)
    ..show();
  _snackBarControllers.add(controller);
}

// すべて表示中のSnackBarを削除する
_dismissAllMySnackBar() {
  _snackBarControllers.forEach((element) {
    if (!element.isDismissed) {
      element._dismiss();
    }
  });

  print(
      "snackBarControllers count:${_snackBarControllers.length} @before clean");
  _snackBarControllers.removeWhere((element) => element.isDismissed);
  print(
      "snackBarControllers a count:${_snackBarControllers.length} @after clean");
}

// 表示中のSnackBarController
final List<_MySnackBarController> _snackBarControllers = [];


// SnackBarのアニメーションや表示状態を管理する
class _MySnackBarController with WidgetsBindingObserver {
  late AnimationController controller;
  late OverlayState overlay;
  OverlayEntry? overlayEntry;
  String message;
  VoidCallback? onOkTapped;
  bool isDismissCalled = false;
  bool isDismissed = false;
  BuildContext context;

  // https://github.com/surfstudio/flutter-bottom-inset-observer/blob/main/lib/src/bottom_inset_observer.dart
  @override
  void didChangeMetrics() {
    final window = WidgetsBinding.instance.window;
    final inset = window.viewInsets.bottom / window.devicePixelRatio;
    print("didChangeMetrics:$inset");
    // キーボードの表示非表示を検知したら閉じる
    _dismiss();
  }

  _MySnackBarController(
      {required this.context,
      required this.message,
      VoidCallback? onOkTapped}) {
    WidgetsBinding.instance.addObserver(this);

    final rootOverlay = Overlay.of(context);
    overlay = rootOverlay!;
    controller = AnimationController(
        vsync: rootOverlay!, duration: const Duration(milliseconds: 200))
      ..addStatusListener((status) {
        print("animation status changed:${status}");
        if (status == AnimationStatus.dismissed) {
          _onDismissFinished();
        }
      });
    this.onOkTapped = () {
      _dismiss();
      if (onOkTapped != null) {
        onOkTapped();
      }
    };
  }

  _dismiss() {
    if (!isDismissCalled) {
      controller.reverse();
      WidgetsBinding.instance.removeObserver(this);
    }
    isDismissCalled = true;
  }

  _onDismissFinished() {
    print("Remove overlay");
    overlayEntry?.remove();
    overlayEntry = null;
    isDismissed = true;
  }

  show() {
    final width = MediaQuery.of(context).size.width;
    final bodyHeight = 60;
    final safeAreaHeight = MediaQuery.of(context).padding.bottom;
    final bottomViewInsets = MediaQuery.of(context).viewInsets.bottom;
    final bodyHeightWithSafeArea =
        bodyHeight + safeAreaHeight + bottomViewInsets;

    final entry = OverlayEntry(
        builder: (context) {
          return Container(
            alignment: Alignment.bottomCenter,
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
                      child: _MySnackBar(
                        message: message,
                        onOkTapped: onOkTapped,
                      ))
                ],
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

// SnackBar自体のウィジェット
class _MySnackBar extends StatefulWidget {
  String message;
  VoidCallback? onOkTapped;

  _MySnackBar({required this.message, this.onOkTapped});

  @override
  State createState() => _MySnackBarState();
}

class _MySnackBarState extends State<_MySnackBar>
    with TickerProviderStateMixin {
  @override
  void initState() {
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
        child: Row(
          children: [
            Expanded(
                child: Text(
              widget.message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, height: 1.2),
            )),
            const SizedBox(
              width: 8,
            ),
            TextButton(
                onPressed: () => _onOkTapped(),
                child: const Text(
                  "OK",
                )),
          ],
        ),
      ),
    );
    return body;
  }
}

// 画面移動時にSnackBarを削除するためのオブザーバー
// CupertinoAppやMaterialAppの生成時に指定する
class MySnackBarNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("didPush");
    _dismissAllMySnackBar();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("didPop");
    _dismissAllMySnackBar();
  }
}
