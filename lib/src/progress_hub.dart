part of '../getxfire.dart';

class ProgressHud extends PopupRoute {
  /*
  * Show message.
  * */
  static Future<void> showMessage(String message,
      {bool isSucceess = false, isHideIcon = false}) async {
    try {
      if (_currentHud != null) {
        _currentHud!.navigator!.pop();
      }
      ProgressHud hud = ProgressHud();
      hud.message = message;
      hud.isSucceess = isSucceess;
      hud.isHideIcon = isHideIcon;
      _currentHud = hud;
      Navigator.push(Get.context!, hud);
      Future.delayed(hud.delayed).then((val) {
        _currentHud!.navigator!.pop();
        _currentHud = null;
      });
    } catch (e) {
      _currentHud = null;
    }
  }

  static Future<void> showUpCommingMessage() async {
    try {
      if (_currentHud != null) {
        _currentHud!.navigator!.pop();
      }
      ProgressHud hud = ProgressHud();
      hud.message = "Coming Soon, still on progress!  😇🙏";
      hud.isUpComming = true;
      _currentHud = hud;
      Navigator.push(Get.context!, hud);
      Future.delayed(Duration(milliseconds: 1700)).then((val) {
        _currentHud?.navigator?.pop();
        _currentHud = null;
      });
    } catch (e) {
      _currentHud = null;
    }
  }

  /*
  * show an hud.
  * when you want to do anything, you can call this show.
  * for example： begin network request
  * */
  static Future<void> show() async {
    try {
      if (_currentHud != null) {
        _currentHud!.navigator!.pop();
      }
      ProgressHud hud = ProgressHud();
      _currentHud = hud;
      Navigator.push(Get.context!, hud);
    } catch (e) {
      _currentHud = null;
    }
  }

  /*
  * hide hud
  * when you complete something,you can call this hide to hide hud.
  * */
  static Future<void> hide() async {
    try {
      if (_currentHud != null) {
        _currentHud!.navigator!.pop();
      }
      _currentHud = null;
    } catch (e) {
      _currentHud = null;
    }
  }

// hud show this message, default null. when you set ,it will show message hud, not progress hud.
  String? message;
  bool isSucceess = false;
  bool isHideIcon = false;
  bool isUpComming = false;
  Color progressColor = Colors.grey;
  Color progressBackgroundColor = Colors.white;
  Color coverColor = Color.fromRGBO(0, 0, 0, 0.4);
  Duration delayed = Duration(milliseconds: 3000);
  TextStyle loadingTextStyle = TextStyle(
      fontSize: 13.0,
      color: Colors.black87,
      fontWeight: FontWeight.normal,
      fontFamily: 'Sans',
      decoration: TextDecoration.none);
  TextStyle messageTextStyle = TextStyle(
      fontSize: 14.0,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      fontFamily: 'Sans',
      decoration: TextDecoration.none);

  String loadingMessage = 'loading ...';

  static ProgressHud? _currentHud;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => kThemeAnimationDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.4),
      child: Center(
        child: _getProgress(),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }

  Widget _getProgress() {
    if (message == null) {
      return Container(
          width: 100.0,
          height: 100.0,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(10))),
          child: Stack(
            children: <Widget>[
              // Center(
              //   // child: Image.asset(
              //   //   "assets/common/opet-indicator.gif",//logo-color
              //   //   height: 77.0,
              //   // )
              //   // CircularProgressIndicator(
              //   //     valueColor: new AlwaysStoppedAnimation(progressColor)),
              // ),
              Center(
                child: Container(
                  child: SpinKitFadingCube(
                    color: Get.context?.theme.primaryColor,
                    duration: Duration(milliseconds: 1500),
                    size: 35.0,
                  ),
                ),
              )
            ],
          ));
    } else {
      return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(new Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: isHideIcon ? 0 : 15.0),
              child: isHideIcon
                  ? Container(
                      height: 0,
                      width: 0,
                    )
                  : isUpComming
                      ? Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(FontAwesomeIcons.cogs,
                              size: 20.0, color: Colors.blue),
                        )
                      : isSucceess
                          ? Icon(FontAwesomeIcons.checkCircle,
                              size: 20.0, color: Colors.green)
                          : Icon(FontAwesomeIcons.exclamation,
                              size: 20.0, color: Colors.red),
            ),
            Flexible(
              child: Text(
                message!,
                style: messageTextStyle,
              ),
            ),
          ],
        ),
      );
    }
  }
}
