// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:getxfire_example/bk/global_variables.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PhoneAuthScreen extends StatefulWidget {
//   @override
//   _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
// }

// class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//   final mobileNumberController = TextEditingController();
//   String countryCode = "+82";
//   bool loading = false;

//   String get internationalNo => countryCode + mobileNumberController.text;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Phone Verification'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Choose your country',
//               style: TextStyle(fontSize: 10),
//             ),
//             CountryCodePicker(
//               onChanged: (country) => countryCode = country.dialCode,
//               initialSelection: 'KR',
//               favorite: ['KR', 'PH', 'JP', 'ZH'],
//               showCountryOnly: false,
//               showOnlyCountryWhenClosed: true,
//               alignLeft: true,
//             ),
//             Text(
//               'Input your mobile number',
//               style: TextStyle(fontSize: 10),
//             ),
//             TextFormField(
//               controller: mobileNumberController,
//               keyboardType: TextInputType.number,
//               style: TextStyle(
//                 fontSize: 32,
//               ),
//               decoration: InputDecoration(
//                 hintText: '000-000-000',
//                 hintStyle: TextStyle(
//                   fontSize: 32,
//                   color: Color(0x95959599),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (loading) return;
//                 setState(() => loading = true);

//                 /// TODO: validate phone number format.
//                 print('no: $internationalNo');
//                 ff.mobileAuthSendCode(internationalNo,
//                     onCodeSent: (verificationID, codeResendToken) {
//                   setState(() => loading = false);
//                   Get.toNamed(
//                     'phone-auth-code-verification',
//                     arguments: {
//                       'verificationID': verificationID,
//                       'codeResendToken': codeResendToken,
//                       'internationalNo': internationalNo
//                     },
//                   );
//                 }, onError: (e) {
//                   setState(() => loading = false);
//                   Get.snackbar('Error', e.toString());
//                 });
//               },
//               child: loading ? CircularProgressIndicator() : Text('SEND CODE'),
//             ),
//             if (ff.appSetting('force-verification') != true)
//               ElevatedButton(
//                 onPressed: () => Get.toNamed('home'),
//                 child: Text('SKIP'),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
