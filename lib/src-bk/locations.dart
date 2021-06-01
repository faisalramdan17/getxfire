// /// @file flutter_location
// ///

// part of '../getxfire.dart';

// const String geoFieldName = 'location';

// ///
// ///
// /// GetxFireLocation can listen users who are comming in/out.
// /// You may want to call `init` method in main.dart to listen users in radius immediately when app start.
// /// To change the [radus], call `reset` method.
// /// When it is
// class GetxFireLocation {
//   GetxFireLocation({
//     @required GetxFire inject,
//   }) : _ff = inject;
//   GetxFire _ff;

//   double _radius;
//   String _gender;
//   String get gender => _gender;

//   /// [change] event will be fired when user changes his location.
//   /// Since [change] is BehaviorSubject, it will be fired with null for the
//   /// first time. And when the device can't fetch location information, there
//   /// will be no more event after null.
//   // ignore: close_sinks
//   BehaviorSubject change = BehaviorSubject<GeoFirePoint>.seeded(null);

//   /// Since [users] is BehaviorSubject, an event may be fired with empty user
//   /// list for the first time.
//   // ignore: close_sinks
//   BehaviorSubject users = BehaviorSubject<Map<String, dynamic>>.seeded({});

//   final Location _location = new Location();

//   // Other user's location near the current user's location.
//   // Map<String, dynamic> usersNearMe = {};
//   // bool get noUsersNearMe => usersNearMe.isEmpty;

//   StreamSubscription usersNearMeSubscription;

//   /// Expose `Location` instance.
//   Location get instance => _location;

//   final Geoflutterfire geo = Geoflutterfire();

//   /// Last(movement) geo point of the user.
//   GeoFirePoint _lastPoint;
//   GeoFirePoint get lastPoint => _lastPoint;

//   /// Holds all users near me without the age filter
//   Map<String, dynamic> usersNearMe = {};

//   /// Exposed getter to get filtered users near me.
//   // Map<String, dynamic> get usersNearMe {
//   //   Map<String, dynamic> _users = {};
//   //   if (_minAgeStamp != null && _maxAgeStamp != null) {
//   //     _usersNearMe.forEach((key, value) {
//   //       Timestamp bday = _usersNearMe[key]['birthday'];
//   //       if (bday == null) return;
//   //       if (bday.seconds >= _minAgeStamp && bday.seconds <= _maxAgeStamp) {
//   //         _users[key] = value;
//   //       }
//   //       print(bday);
//   //     });
//   //     return _users;
//   //   } else {
//   //     // print('no age filter');
//   //     return _usersNearMe;
//   //   }
//   // }

//   /// Initialize the location.
//   ///
//   /// [radius] is the radius to search users. If it is not set(or set as null),
//   /// 22(km) will be set by default.
//   init({double radius = 22, String gender}) {
//     // print('location:init');
//     _radius = radius;
//     _gender = gender;
//     _checkPermission();
//     _updateUserLocation();
//   }

//   /// Reset the radius to search users.
//   ///
//   reset({
//     double radius,
//     String gender,
//     int minAge,
//     int maxAge,
//   }) {
//     _radius = radius ?? _radius;
//     _gender = gender ?? _gender;

//     // if (minAge != null && maxAge != null) {
//     //   _minAgeStamp = _secondsSinceEpoch(maxAge);
//     //   _maxAgeStamp = _secondsSinceEpoch(minAge);
//     // }

//     _listenUsersNearMe(_lastPoint);
//   }

//   // int _secondsSinceEpoch(int value) {
//   //   DateTime now = DateTime.now();
//   //   return DateTime(now.year - value).millisecondsSinceEpoch ~/ 1000;
//   // }

//   Future<bool> hasPermission() async {
//     return await _location.hasPermission() == PermissionStatus.granted;
//   }

//   /// Return true if the permission is granted
//   Future<bool> _checkPermission() async {
//     // print('_checkPermission');

//     /// Check if `Location service` is enabled by the device.
//     bool locationService = await _location.serviceEnabled();
//     if (locationService == false) {
//       /// If not, request if not enabled
//       locationService = await _location.requestService();

//       /// And if the user really rejects to enable the `Location service`,
//       if (locationService == false) {
//         return false;
//       }
//     }

//     /// Check if the user give permission to the app to use location service
//     PermissionStatus permissionStatus = await _location.hasPermission();
//     if (permissionStatus == PermissionStatus.denied) {
//       /// Request if permission is not granted.
//       permissionStatus = await _location.requestPermission();
//       if (permissionStatus != PermissionStatus.granted) {
//         return false;
//       }
//     }

//     // print('permission granted:');
//     return true;
//   }

//   /// Listing user location changes.
//   ///
//   /// It does not matter weather the location service is eanbled or not. Just
//   /// listen it here and when the location is enabled later, it will work
//   /// alreday.
//   _updateUserLocation() {
//     // print('initGetxFireLocation');

//     // Changes settings to whenever the `onChangeLocation` should emit new locations.
//     _location.changeSettings(
//       accuracy: LocationAccuracy.high,
//     );

//     /// Listen to location change when the user is moving
//     ///
//     /// This will not emit new location if the device or user is not moving.
//     ///
//     /// If the device can't fetch location, this method will not be called.
//     /// * This is going to work after user login even if the user did logged in on start up
//     _location.onLocationChanged.listen((
//       LocationData newLocation,
//     ) async {
//       GeoFirePoint _new = geo.point(
//         latitude: newLocation.latitude,
//         longitude: newLocation.longitude,
//       );

//       if (_lastPoint == null) {
//         _lastPoint = _new;
//       }
//       if (_ff.notLoggedIn) return;

//       /// When the user change his location, it needs to search other users base on his new location.
//       /// TODO do not update user location unless the user move (by 1 meter) because it may update too often.
//       /// * Do not update location when the user didn't move.
//       if (_new.hash != _lastPoint?.hash) {
//         /// backup user's last location.
//         // print('location changed: ');
//         _lastPoint = _new;

//         await updateUserLocation(_new);
//         _listenUsersNearMe(_new);
//       }
//     }).onError((e) {
//       print(e.toString());
//     });
//   }

//   // When user didn't login, it will not try to save to data.
//   Future<GeoFirePoint> updateUserLocation(GeoFirePoint _new) async {
//     change.add(_new);
//     if (_ff.notLoggedIn) return _new;
//     await _ff.publicDoc.set({geoFieldName: _new.data}, SetOptions(merge: true));
//     return _new;
//   }

//   /// Listen `/meta/user/public/{uid}` for geo point and search users who are
//   /// within the radius from my geo point.
//   ///
//   ///
//   /// This method will be called
//   /// * immediately after the class is instantiated,
//   /// * and whenever the user changes his location.
//   ///
//   /// When the user is moving, it will search new other users within the radiusv
//   /// of his geo point. And when the other user comes in to the user's radius,
//   /// the other user will be inserted into the search result.
//   ///
//   /// todo when user move fast (in a car), this method may be call in every seconds.
//   /// And a second does not look enough to handle the stream listening(updating UI) of hundreds users within the radius.
//   /// ? This is a clear race condition. How are you going to handle this racing?
//   ///
//   _listenUsersNearMe(GeoFirePoint point) {
//     if (point == null) {
//       /// If the device can't fetch location information, then [point] will be null.
//       return;
//     }

//     // print('point: ${point.latitude} x ${point.longitude}');
//     // print('radius: $_radius');
//     // print('gender: $_gender');
//     Query colRef = _ff.publicCol;
//     if (_gender != null) {
//       colRef = colRef.where('gender', isEqualTo: _gender);
//     }

//     if (usersNearMeSubscription != null) {
//       usersNearMeSubscription.cancel();
//     }

//     usersNearMeSubscription = geo
//         .collection(collectionRef: colRef)
//         .within(
//           center: point,
//           radius: _radius, // km
//           // radius: 10000000, // km
//           field: geoFieldName,
//           strictMode: true,
//         )
//         .listen((List<DocumentSnapshot> documents) {
//       usersNearMe = {};
//       // print('found: ${documents.length}');

//       /// Clear users if documents is empty
//       /// documents might have 1 document containing the current user's location.
//       if (documents.isEmpty) {
//         users.add(usersNearMe);
//         return;
//       }

//       /// Get new users into [usersNearMe] and update.
//       documents.forEach((document) {
//         // if this is the current user's data. don't add it to the list.

//         if (_ff.loggedIn && document.id == _ff.user.uid) return;

//         Map<String, dynamic> data = document.data();
//         GeoPoint _point = data[geoFieldName]['geopoint'];

//         data['uid'] = document.id;
//         // get distance from current user.
//         data['distance'] = point.distance(
//           lat: _point.latitude,
//           lng: _point.longitude,
//         );

//         usersNearMe[document.id] = data;
//       });
//       users.add(usersNearMe);
//     });
//   }
// }
