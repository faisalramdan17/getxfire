# Get X Firebase

[![pub package](https://img.shields.io/pub/v/getxfire?color=blue&label=getxfire&logo=getxfire&logoColor=blue)](https://pub.dev/packages/getxfire)
[![likes](https://badges.bar/getxfire/likes)](https://pub.dev/packages/getxfire/score)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/faisalramdan17)

A Flutter Package that implemented firebase services with getx package.

It's free, open source, complete, rapid development package for creating Social apps, Chat apps, Community(Forum) apps, Shopping mall apps, and much more based on Firebase.

- Complete features.\
  This package has complete features (see Features below) that most of apps require.
- `Simple, easy and the right way`.\
  We want it to be deadly simple yet, right way for ourselves and for the developers in the world.
  We know when it gets complicated, our lives would get even more complicated.
- Real time.\
  We design it to be real time when it is applied to your app. All the events like post and comment creation, voting(like, dislike), deletion would appears on all the user's phone immediately after the event.

# Help Maintenance

I've been maintaining quite many repos these days and burning out slowly. If you could help me cheer up, buying me a cup of coffee will make my life really happy and get much energy out of it.

<p><br/>
    <a title="Buy me a coffee" href="https://www.buymeacoffee.com/faisalramdan17" target="_blank">
        <img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=faisalramdan17&button_colour=FF5F5F&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00">
    </a>
</p> 
<br/>

# Contact Me & Social Media
- <a href="https://www.buymeacoffee.com/faisalramdan17" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 100px !important;width: 274px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>
- Buy Me a Coffee : https://www.buymeacoffee.com/faisalramdan17
- Subscribe on Youtube : https://www.youtube.com/c/CodingYourLife?sub_confirmation=1
- Contact us on Telegram : https://t.me/faisalramdan17
- Website: https://codingyourlife.id
- GitHub: https://github.com/faisalramdan17
- LinkedIn: https://www.linkedin.com/in/faisalramdan17
- Facebook : https://www.facebook.com/codingyourlife.id
- Instagram: https://instagram.com/faisalramdan17 & https://instagram.com/codingyourlife.id

# Features

- User

  - User registration and login with email/password
  - User profile update
  - User profile photo update
  - Social logins
    - Google
    - Apple (Coming Soon)
    - Facebook (Coming Soon)
  - Phone number authentication (Coming Soon)

- Push notifications (Coming Soon)

  - Admin can send push notifications to all users.
  - Admin can send push notifications to users of a forum.
  - User can enable/disable to get notification when other users creates comments under his posts/comments.
  - User can subscribe/unsubscribe for new posts or comments under a forum.

<!-- - Chat (Coming Soon)

  - A complete chat functionality which includes
    - Group chat
    - Inviting users
    - Blocking users
    - Kickout users
    - Changing settings of chat room
  - Expect more to come. -->

- Location (Coming Soon)

  - App can update login user's GEO location. There are many possiblities by saving GEO location.
  - App can search other users(by distance, gender) near the login user GEO point.

<!-- - Settings in real time. 

  - Admin can update app settings via Admin page and the change will apply to app immediately.

- Internalization (Localization) in real time. (Coming Soon)

  - Texts in menu, text screens could be translated/update at any via Admin page and it appears in the app immediately. -->

- Security

  - Tight Firestore security rules are applied.

<!-- - Admin Site (Coming Soon)

  - There is no doubt that most apps need admin feature(or site) that works outside of the app. And that should be a desktop version of website since there are much contents to view.
  - Unfortunately, Flutter web is not ready for production, so we have chosen `Vuejs` to build admin site to manage users, posts, photos and other resources in Fireflutter proejct.
  - This README.md does not include much information about Admin site. Please visit github repository: [https://github.com/faisalramdan17/getxfire/tree/main/admin-vuejs](https://github.com/faisalramdan17/getxfire/tree/main/admin-vuejs) to know more about it. -->


- Fully Customizable
  - GetxFire package does not involve in any of part application's login or UI. It is completely separated from the app. Thus, it's highly customizable.

# Getting Started

### Installation
Install the library from pub:
```
dependencies:
  getxfire: <latest-version>
```

### Import the library
```
import 'package:getxfire/getxfire.dart';
```

### Init GetxFire
Add this inside `main()` function at `main.dart` file:
```
WidgetsFlutterBinding.ensureInitialized();
await GetxFire.init();
```

### Usage

#### Open Dialog
Will popup success message  :
```
GetxFire.openDialog.messageSuccess("Create User successfully!");
```
Will popup error message :
```
GetxFire.openDialog.messageError("Failed to Create User!");
```
Will popup info message :
```
GetxFire.openDialog.info(
  lottiePath: GetxFire.lottiePath.COMING_SOON,
  lottiePadding: EdgeInsets.only(top: 50),
);
```
Will popup message with yes and no confirm button :
```
GetxFire.openDialog.confirm(
  content: "Are you sure to sign out?",
  lottiePath: GetxFire.lottiePath.THINKING, // lottiePath: "assets/lottie/coffee-favorite.json",
  onYesClicked: () async {
    final User user = GetxFire.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        content: Text('No one has signed in.'),
      ));
      return;
    }
    await GetxFire.signOut();

    final String uid = user.uid;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$uid has successfully signed out.'),
    ));
  },
);
```

#### Get Lottie Assets Available
```
GetxFire.lottiePath.<functions>
```
We can get default lottie animation assets,
such as : `THINKING`, `COMING_SOON`, `SEARCH_FILES`, `SAD_HEART`, `NO_ACTIVITY`, `MULTI_TASKING`, `IMAGE_ICON`, `EMPTY_BOX`, and `COFFEE_FAVORITE`
```
class LottiePath {
  final THINKING = "assets/lottie/thinking.json";
  final COMING_SOON = "assets/lottie/coming-soon.json";
  final SEARCH_FILES = "assets/lottie/search-files.json";
  final SAD_HEART = "assets/lottie/sad-heart.json";
  final NO_ACTIVITY = "assets/lottie/no-activity.json";
  final MULTI_TASKING = "assets/lottie/multi-tasking.json";
  final IMAGE_ICON = "assets/lottie/image-icon.json";
  final EMPTY_BOX = "assets/lottie/empty-box.json";
  final COFFEE_FAVORITE = "assets/lottie/coffee-favorite.json";
}
```
Example :
```
GetxFire.lottiePath.THINKING
```

#### Show and Hide Progress Bar

Example :
```
// This for show loading progress bar
GetxFire.showProgressHud();

// This for hide loading progress bar
GetxFire.hideProgressHud();
```
#### Converter Date, etc.
```
GetxFire.converter.<functions>
```

#### Helper Scripts
```
GetxFire.helper.<functions>
```

#### For Use FirebaseAuth.instance Services
```
GetxFire.auth.<functions>
```
#### For Use Firestore Services
```
GetxFire.firestore.<functions>
```
#### For Use Storage Services
```
GetxFire.storage.<functions>
```

#### Login Anonymously
```
await GetxFire.signInAnonymously(
  onSuccess: (userCredential) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Signed in Anonymously as user ${userCredential.user.uid}'),
      ),
    );
  },
  onError: (code, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to sign in Anonymously\n$message'),
      ),
    );
  },
);
```
#### Login Email & Password
```
await GetxFire.signInWithEmailAndPassword(
  email: _emailController.text,
  password: _passwordController.text,
  onSuccess: (userCredential) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${userCredential.user.email} signed in'),
      ),
    );
  },
  onError: (code, message) {},
);
```
#### Login With Google (Google Sign-in)
```
await GetxFire.signInWithGoogle(
  onSuccess: (userCredential) {
    final user = userCredential.user;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Sign In ${user.uid} with Google'),
    ));
  },
  onError: (code, message) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Failed to sign in with Google: $message'),
    //   ),
    // );
  },
);
```

#### For Get Current User
```
GetxFire.currentUser
```
example :
```
User user = GetxFire.currentUser;
```

#### For Get Current User Changes
Add this inside `void initState()` function at statfullwidget :
```
GetxFire.userChanges().listen((event) => setState(() {}));
```

#### For Get Current User State Changes 
Add this inside `void initState()` function at statfullwidget :
```
GetxFire.userStateChanges(setState);
```

# References

- [GetxFire Package](https://github.com/faisalramdan17/getxfire) - This Package.
- [GetxFire Sample App](https://github.com/faisalramdan17/getxfire/tree/main/example) - Example Flutter App.
- [GetxFire Documentation](https://github.com/faisalramdan17/getxfire/wiki) - Wiki Documentation.

<!-- - [GetxFire Firebase Project](https://github.com/faisalramdan17/getxfire/tree/main/firebase) - Admin Site with Vuejs. -->
<!-- - [GetxFire Admin Panel Vuejs](https://github.com/faisalramdan17/getxfire/tree/main/admin-vuejs) - Firebase project for Firestore security rules. -->

# Packages Dependencies
These are the available Packages Dependencies in this repository.

| Plugin | Pub | Points | Popularity | Likes |
|--------|-----|--------|------------|-------|
| [firebase_core](https://pub.dev/packages/firebase_core/) | [![pub package](https://img.shields.io/pub/v/firebase_core.svg)](https://pub.dev/packages/firebase_core) | [![pub points](https://badges.bar/firebase_core/pub%20points)](https://pub.dev/packages/firebase_core/score) |  [![popularity](https://badges.bar/firebase_core/popularity)](https://pub.dev/packages/firebase_core/score) | [![likes](https://badges.bar/firebase_core/likes)](https://pub.dev/packages/firebase_core/score) |
| [firebase_auth](https://pub.dev/packages/firebase_auth/) | [![pub package](https://img.shields.io/pub/v/firebase_auth.svg)](https://pub.dev/packages/firebase_auth) | [![pub points](https://badges.bar/firebase_auth/pub%20points)](https://pub.dev/packages/firebase_auth/score) | [![popularity](https://badges.bar/firebase_auth/popularity)](https://pub.dev/packages/firebase_auth/score) | [![likes](https://badges.bar/firebase_auth/likes)](https://pub.dev/packages/firebase_auth/score) |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore/) | [![pub package](https://img.shields.io/pub/v/cloud_firestore.svg)](https://pub.dev/packages/cloud_firestore) | [![pub points](https://badges.bar/cloud_firestore/pub%20points)](https://pub.dev/packages/cloud_firestore/score) | [![popularity](https://badges.bar/cloud_firestore/popularity)](https://pub.dev/packages/cloud_firestore/score) | [![likes](https://badges.bar/cloud_firestore/likes)](https://pub.dev/packages/cloud_firestore/score) |
| [firebase_storage](https://pub.dev/packages/firebase_storage/) | [![pub package](https://img.shields.io/pub/v/firebase_storage.svg)](https://pub.dev/packages/firebase_storage) | [![pub points](https://badges.bar/firebase_storage/pub%20points)](https://pub.dev/packages/firebase_storage/score) | [![popularity](https://badges.bar/firebase_storage/popularity)](https://pub.dev/packages/firebase_storage/score) | [![likes](https://badges.bar/firebase_storage/likes)](https://pub.dev/packages/firebase_storage/score) |
| [firebase_dynamic_links](https://pub.dev/packages/firebase_dynamic_links/) | [![pub package](https://img.shields.io/pub/v/firebase_dynamic_links.svg)](https://pub.dev/packages/firebase_dynamic_links) | [![pub points](https://badges.bar/firebase_dynamic_links/pub%20points)](https://pub.dev/packages/firebase_dynamic_links/score) | [![popularity](https://badges.bar/firebase_dynamic_links/popularity)](https://pub.dev/packages/firebase_dynamic_links/score) | [![likes](https://badges.bar/firebase_dynamic_links/likes)](https://pub.dev/packages/firebase_dynamic_links/score) |
| [firebase_analytics](https://pub.dev/packages/firebase_analytics/) | [![pub package](https://img.shields.io/pub/v/firebase_analytics.svg)](https://pub.dev/packages/firebase_analytics) | [![pub points](https://badges.bar/firebase_analytics/pub%20points)](https://pub.dev/packages/firebase_analytics/score) | [![popularity](https://badges.bar/firebase_analytics/popularity)](https://pub.dev/packages/firebase_analytics/score) | [![likes](https://badges.bar/firebase_analytics/likes)](https://pub.dev/packages/firebase_analytics/score) |
| [google_sign_in](https://pub.dev/packages/google_sign_in/) | [![pub package](https://img.shields.io/pub/v/google_sign_in.svg)](https://pub.dev/packages/google_sign_in) | [![pub points](https://badges.bar/google_sign_in/pub%20points)](https://pub.dev/packages/google_sign_in/score) | [![popularity](https://badges.bar/google_sign_in/popularity)](https://pub.dev/packages/google_sign_in/score) | [![likes](https://badges.bar/google_sign_in/likes)](https://pub.dev/packages/google_sign_in/score) |
| [intl](https://pub.dev/packages/intl/) | [![pub package](https://img.shields.io/pub/v/intl.svg)](https://pub.dev/packages/intl) | [![pub points](https://badges.bar/intl/pub%20points)](https://pub.dev/packages/intl/score) | [![popularity](https://badges.bar/intl/popularity)](https://pub.dev/packages/intl/score) | [![likes](https://badges.bar/intl/likes)](https://pub.dev/packages/intl/score) |
| [get](https://pub.dev/packages/get/) | [![pub package](https://img.shields.io/pub/v/get.svg)](https://pub.dev/packages/get) | [![pub points](https://badges.bar/get/pub%20points)](https://pub.dev/packages/get/score) | [![popularity](https://badges.bar/get/popularity)](https://pub.dev/packages/get/score) | [![likes](https://badges.bar/get/likes)](https://pub.dev/packages/get/score) |
| [lottie](https://pub.dev/packages/lottie/) | [![pub package](https://img.shields.io/pub/v/lottie.svg)](https://pub.dev/packages/lottie) | [![pub points](https://badges.bar/lottie/pub%20points)](https://pub.dev/packages/lottie/score) | [![popularity](https://badges.bar/lottie/popularity)](https://pub.dev/packages/lottie/score) | [![likes](https://badges.bar/lottie/likes)](https://pub.dev/packages/lottie/score) |
| [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter/) | [![pub package](https://img.shields.io/pub/v/font_awesome_flutter.svg)](https://pub.dev/packages/font_awesome_flutter) | [![pub points](https://badges.bar/font_awesome_flutter/pub%20points)](https://pub.dev/packages/font_awesome_flutter/score) | [![popularity](https://badges.bar/font_awesome_flutter/popularity)](https://pub.dev/packages/font_awesome_flutter/score) | [![likes](https://badges.bar/font_awesome_flutter/likes)](https://pub.dev/packages/font_awesome_flutter/score) |
| [image_picker](https://pub.dev/packages/image_picker/) | [![pub package](https://img.shields.io/pub/v/image_picker.svg)](https://pub.dev/packages/image_picker) | [![pub points](https://badges.bar/image_picker/pub%20points)](https://pub.dev/packages/image_picker/score) | [![popularity](https://badges.bar/image_picker/popularity)](https://pub.dev/packages/image_picker/score) | [![likes](https://badges.bar/image_picker/likes)](https://pub.dev/packages/image_picker/score) |
| [image_cropper](https://pub.dev/packages/image_cropper/) | [![pub package](https://img.shields.io/pub/v/image_cropper.svg)](https://pub.dev/packages/image_cropper) | [![pub points](https://badges.bar/image_cropper/pub%20points)](https://pub.dev/packages/image_cropper/score) | [![popularity](https://badges.bar/image_cropper/popularity)](https://pub.dev/packages/image_cropper/score) | [![likes](https://badges.bar/image_cropper/likes)](https://pub.dev/packages/image_cropper/score) |
| [flutter_animated_dialog](https://pub.dev/packages/flutter_animated_dialog/) | [![pub package](https://img.shields.io/pub/v/flutter_animated_dialog.svg)](https://pub.dev/packages/flutter_animated_dialog) | [![pub points](https://badges.bar/flutter_animated_dialog/pub%20points)](https://pub.dev/packages/flutter_animated_dialog/score) | [![popularity](https://badges.bar/flutter_animated_dialog/popularity)](https://pub.dev/packages/flutter_animated_dialog/score) | [![likes](https://badges.bar/flutter_animated_dialog/likes)](https://pub.dev/packages/flutter_animated_dialog/score) |
| [flutter_spinkit](https://pub.dev/packages/flutter_spinkit/) | [![pub package](https://img.shields.io/pub/v/flutter_spinkit.svg)](https://pub.dev/packages/flutter_spinkit) | [![pub points](https://badges.bar/flutter_spinkit/pub%20points)](https://pub.dev/packages/flutter_spinkit/score) | [![popularity](https://badges.bar/flutter_spinkit/popularity)](https://pub.dev/packages/flutter_spinkit/score) | [![likes](https://badges.bar/flutter_spinkit/likes)](https://pub.dev/packages/flutter_spinkit/score) |
| [flutter_web_browser](https://pub.dev/packages/flutter_web_browser/) | [![pub package](https://img.shields.io/pub/v/flutter_web_browser.svg)](https://pub.dev/packages/flutter_web_browser) | [![pub points](https://badges.bar/flutter_web_browser/pub%20points)](https://pub.dev/packages/flutter_web_browser/score) | [![popularity](https://badges.bar/flutter_web_browser/popularity)](https://pub.dev/packages/flutter_web_browser/score) | [![likes](https://badges.bar/flutter_web_browser/likes)](https://pub.dev/packages/flutter_web_browser/score) |

# Components

- Firebase\
  Firebase is a leading cloud system powered by Google. It has lots of goods to build web and app.

  - We first built it with Firebase and LEMP(Linux + Nginx + MariaDB + PHP). It was fine but was a pressure to maintain two different systems. So, We decided to remove LEMP and built it again with Firebase only.

  - You may use Firebase as free plan for a test.

- Flutter\
  Flutter as its app development toolkit.


<!-- - Algolia\
  Firebase does not support full text search which means users cannot search posts and comments.
  Algolia does it. -->

- And other open source Flutter & Dart packages.

# Requirements

- Basic understanding of Flutter and Dart.
- Basic understanding of Firebase.
- Editor: VSCode, Xcode(for Mac OS).\
  Our primary editor is VSCode and we use Xcode for Flutter settings. We found it more easy to do the settings with Xcode for iOS development.

# Installation & Usage

- To use this plugin, please visit the [GetxFire Wiki Documentation](https://github.com/faisalramdan17/getxfire/wiki)
- If you are not familiar with Firebase and Flutter, you may have difficulties to install it.

  - GetxFire is not a smple package that you just add it into pubspec.yaml and ready to go.
  - Many of the settings are coming from the packages that getxfire is using. And for release, it may need extra settgins.
  - Most of developers are having troubles with settings. You are not the only one. Ask us on [Git issues](https://github.com/faisalramdan17/getxfire/issues).

- We will cover all the settings and try to put it as demonstrative as it can be.

  - We will begin with Firebase settings and contiue gradual settings with Flutter.

- And please let us know if there is any mistake on the documentation.

# State Management

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

GetX : https://pub.dev/packages/get

GetX is an extra-light and powerful solution for Flutter. It combines high-performance state management, intelligent dependency injection, and route management quickly and practically.

GetX has 3 basic principles. This means that these are the priority for all resources in the library: PRODUCTIVITY, PERFORMANCE AND ORGANIZATION.

GetX is not bloated. It has a multitude of features that allow you to start programming without worrying about anything, but each of these features are in separate containers and are only started after use. If you only use State Management, only State Management will be compiled. If you only use routes, nothing from the state management will be compiled.

GetX has a huge ecosystem, a large community, a large number of collaborators, and will be maintained as long as the Flutter exists. GetX too is capable of running with the same code on Android, iOS, Web, Mac, Linux, Windows, and on your server.
