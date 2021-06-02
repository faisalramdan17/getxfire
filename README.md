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

# References

- [GetxFire Package](https://github.com/faisalramdan17/getxfire) - This Package.
<!-- - [GetxFire Firebase Project](https://github.com/faisalramdan17/getxfire/tree/main/firebase) - Admin Site with Vuejs. -->
<!-- - [GetxFire Admin Panel Vuejs](https://github.com/faisalramdan17/getxfire/tree/main/admin-vuejs) - Firebase project for Firestore security rules. -->
- [GetxFire Sample App](https://github.com/faisalramdan17/getxfire/tree/main/example) - Example Flutter App.
- [GetxFire Documentation](https://github.com/faisalramdan17/getxfire/wiki) - Wiki Documentation.

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

# Social Media
- <a href="https://www.buymeacoffee.com/faisalramdan17" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 100px !important;width: 274px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>
- Buy Me a Coffee : https://www.buymeacoffee.com/faisalramdan17
- Contact us on Telegram : https://t.me/faisalramdan17
- Website: https://codingyourlife.id
- GitHub: https://github.com/faisalramdan17
- Facebook : https://www.facebook.com/codingyourlife.id
- Instagram: https://instagram.com/faisalramdan17 & https://instagram.com/codingyourlife.id
- LinkedIn: https://www.linkedin.com/in/faisalramdan17

