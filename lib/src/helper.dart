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
        preferredControlTintColor: ThemeData().accentColor,
        // dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        // modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }

  void copyText(String text) {
    Clipboard.setData(new ClipboardData(text: text));
  }

  String? stringTag(String? text) {
    if (text == null) return null;
    var stringArr = text.trim().toLowerCase().split(" ");
    return stringArr.join("-");
  }

  // Create searchIndex for searching
  List<String> searchIndex(String text) {
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
