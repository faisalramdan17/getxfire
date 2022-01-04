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
    this.colorLeftTextButton = Colors.black,
    this.colorRightTextButton = Colors.white,
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
                      padding: const EdgeInsets.only(bottom: 15.0, top: 8),
                      child: Lottie.asset(
                        lottiePath!,
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
                        style: const TextStyle(
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
                        style: const TextStyle(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onLeftPressed,
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: colorLeftButton,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Center(
                              child: Text(
                            labelLeftButton ?? "Cancel",
                            style: TextStyle(
                                color: colorLeftTextButton,
                                fontSize: fontSizeLeftButton ?? 16),
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: onRightPressed,
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: colorRightButton ?? Get.theme.primaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Center(
                              child: Text(
                            labelRightButton ?? "Yes",
                            style: TextStyle(
                                color: colorRightTextButton ?? Colors.white,
                                fontSize: fontSizeRightButton ?? 16),
                          )),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    //   child: ExButton(
                    //     icon: iconRightButton,
                    //     labelButton: labelRightButton ?? labels.text.yes,
                    //     color: colorRightButton ??
                    //         (Get.isDarkMode ? Colors.white : Colors.green[400]),
                    //     colorText: colorRightTextButton ??
                    //         (Get.isDarkMode ? Colors.black87 : Colors.white),
                    //     fontSize: fontSizeRightButton,
                    //     onPressed: onRightPressed,
                    //   ),
                    // ),
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
