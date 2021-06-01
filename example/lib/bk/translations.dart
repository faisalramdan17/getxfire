// import 'package:get/get.dart';

// /// Default translated texts.
// ///
// /// This will be available immediately after app boots before downloading from
// /// Firestore.
// Map<String, Map<String, String>> translations = {
//   "en": {
//     "app-name": "App Name",
//     "home": "Home",
//   },
//   "id": {
//     "app-name": "Nama App",
//     "home": "Beranda",
//   },
//   "ko": {
//     "app-name": "앱 이름",
//     "home": "홈",
//   }
// };

// /// Update translation document data from Firestore into `GetX locale format`.
// updateTranslations(Map<dynamic, dynamic> data) {
//   data.forEach((ln, texts) {
//     for (var name in texts.keys) {
//       translations[ln][name] = texts[name];
//     }
//   });
// }

// /// GetX locale text translations.
// class AppTranslations extends Translations {
//   @override
//   Map<String, Map<String, String>> get keys => translations;
// }
