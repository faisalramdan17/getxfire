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

  // String daftarWA({
  //   required String title,
  //   required String noWA, //
  //   required UserModel user,
  // }) {
  //   return "https://api.whatsapp.com/send?phone=$noWA&text=Hi%20minCast%20%F0%9F%98%8A%0A%0APerkenalkan%2C%0ANama%20%3A%20${user.profile?.fullName ?? ""}%0AEmail%20%3A%20${user.profile?.email ?? ""}%0AUmur%20%3A%20${""}%0ATB%2FBB%20%3A%20${user.talent?.bodyHeight ?? ""}%2F${user.talent?.bodyWeight ?? ""}%0ADomisili%20%3A%20${user.profile?.address?.city ?? ""}%0AInstagram%20%3A%20${user.profile?.instagram ?? ""}%0APengalaman%20%3A%20${user.talent?.lastExperience ?? ""}%0A%0ASaya%20dapat%20info%20dari%20iCast%20App%20dan%20mau%20ikut%20casting%20*$title*";
  // }

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
