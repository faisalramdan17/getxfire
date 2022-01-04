part of '../getxfire.dart';

class ExButton extends StatelessWidget {
  const ExButton({
    Key? key,
    required this.labelButton,
    this.color,
    this.colorText,
    this.fontSize,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  final String? labelButton;
  final Color? color, colorText;
  final double? fontSize;
  final Function()? onPressed;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color ?? Get.context?.theme.primaryColor,
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                icon == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(right: 8), child: icon),
                Text(
                  labelButton ?? "-",
                  style: TextStyle(
                      color: colorText ?? ThemeData().colorScheme.primary,
                      fontSize: fontSize ?? 15,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
