part of '../getxfire.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    this.title,
    this.content,
    this.lottiePath,
    this.lottieHeight,
    this.labelLeftButton,
    this.labelRightButton,
    this.colorLeftButton,
    this.colorRightButton,
    this.colorLeftTextButton,
    this.colorRightTextButton,
    this.fontSizeLeftButton,
    this.fontSizeRightButton,
    this.iconLeftButton,
    this.iconRightButton,
    this.onLeftPressed,
    this.onRightPressed,
    this.customWidget,
    Key? key,
  }) : super(key: key);

  final String? title, content, lottiePath;
  final String? labelLeftButton, labelRightButton;
  final Color? colorLeftButton, colorRightButton;
  final Color? colorLeftTextButton, colorRightTextButton;
  final double? lottieHeight;
  final double? fontSizeLeftButton, fontSizeRightButton;
  final Function()? onLeftPressed;
  final Function()? onRightPressed;
  final Icon? iconLeftButton, iconRightButton;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (lottiePath == null)
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Lottie.asset(
                        lottiePath!, // "assets/lottie/$lottiePath.json",
                        height: lottieHeight ?? 130,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
              (title == null)
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              (content == null)
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 8),
                      child: Text(
                        content!,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
              (customWidget == null)
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 8),
                      child: customWidget,
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ExButton(
                        icon: iconLeftButton,
                        labelButton: labelLeftButton ?? "No",
                        color: colorLeftButton ?? Colors.black38,
                        colorText: colorLeftTextButton ?? Colors.white,
                        fontSize: fontSizeLeftButton,
                        onPressed: onLeftPressed,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ExButton(
                        icon: iconRightButton,
                        labelButton: labelRightButton ?? "Yes",
                        color: colorRightButton ??
                            (Get.isDarkMode ? Colors.white : Colors.green[400]),
                        colorText: colorRightTextButton ??
                            (Get.isDarkMode ? Colors.black87 : Colors.white),
                        fontSize: fontSizeRightButton,
                        onPressed: onRightPressed,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
