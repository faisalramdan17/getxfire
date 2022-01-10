part of '../getxfire.dart';

class Helper {
  Future<void> launchURL(String url) async {
    await FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        toolbarColor: Get.theme.primaryColor,
        // colorScheme: CustomTabsColorScheme.dark,
        // secondaryToolbarColor: Colors.green,
        // navigationBarColor: Colors.amber,
        // addDefaultShareMenuItem: true,
        // instantAppsEnabled: true,
        // showTitle: true,
        // urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        // barCollapsingEnabled: true,
        preferredBarTintColor: Get.theme.primaryColor,
        preferredControlTintColor: ThemeData().colorScheme.primary,
        // dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        // modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }

  String chatWA({
    required String title,
    required String noWA,
    required String content,
  }) {
    return "https://api.whatsapp.com/send?phone=$noWA&text=$content";
  }

  String? getPhoneCode(String? text) {
    if (text?.contains("(") ?? false) {
      return (text?.isEmpty ?? true)
          ? null
          : text?.substring((text.indexOf("(")) + 1, text.indexOf(")")).trim();
    }
    return null;
  }

  String? removePhoneCode(String? text) {
    if (text?.contains("(") ?? false) {
      return (text?.isEmpty ?? true)
          ? null
          : text
              ?.replaceRange(text.indexOf("("), (text.indexOf(")")) + 1, "")
              .trim();
    }

    return text;
  }

  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  String? stringTag(String? text) {
    if (text == null) return null;
    var stringArr = text.trim().toLowerCase().split(" ");
    return stringArr.join("-");
  }

  // Create searchIndex for searching
  List<String> searchIndex(String? text) {
    if (text == null) return [];
    List<String> searchIndex = [];
    var titleArr = text.split(" ");
    for (int i = 0; i < titleArr.length; i++) {
      for (int y = 1; y < titleArr[i].length + 1; y++) {
        var data = titleArr[i].substring(0, y).toLowerCase();
        if (!searchIndex.contains(data)) searchIndex.add(data);
      }
    }
    return searchIndex;
  }
}
