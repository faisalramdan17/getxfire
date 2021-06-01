// import 'package:getxfire_example/bk/global_variables.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PhoneAuthCodeVerificationScreen extends StatefulWidget {
//   @override
//   _PhoneAuthCodeVerificationScreenState createState() =>
//       _PhoneAuthCodeVerificationScreenState();
// }

// class _PhoneAuthCodeVerificationScreenState
//     extends State<PhoneAuthCodeVerificationScreen> {
//   final codeController = TextEditingController();
//   bool loading = false;

//   String verificationID;
//   int codeResendToken;
//   String internationalNo;

//   @override
//   void initState() {
//     dynamic args = Get.arguments;
//     verificationID = args['verificationID'];
//     internationalNo = args['internationalNo'];
//     codeResendToken = args['codeResendToken'];
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Phone Auth Code Verification'),
//       ),
//       body: Column(
//         children: [
//           Text('Enter code'),
//           TextFormField(controller: codeController),
//           ElevatedButton(
//             child: Text(
//               "VERIFY",
//             ),
//             onPressed: () async {
//               if (loading) return;
//               setState(() => loading = true);
//               try {
//                 await ff.mobileAuthVerifyCode(
//                   code: codeController.text,
//                   verificationId: verificationID,
//                 );
//                 setState(() => loading = false);
//                 Get.toNamed('home');
//               } catch (e) {
//                 setState(() => loading = false);
//                 Get.snackbar('Error', e.toString());
//               }
//             },
//           ),

//           // change number & resend code button.
//           Row(
//             children: [
//               TextButton(
//                 child: Text(
//                   'Resend Code'.tr,
//                   style: TextStyle(
//                     color: Color(0xFF032674),
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 onPressed: () {
//                   ff.mobileAuthSendCode(
//                     internationalNo,
//                     resendToken: codeResendToken,
//                     onCodeSent: (_verificationID, resendToken) {
//                       setState(() {
//                         verificationID = _verificationID;
//                         codeResendToken = resendToken;
//                       });
//                     },
//                     onError: (e) => Get.snackbar('Error', e.toString()),
//                   );
//                 },
//               ),
//               Spacer(),
//               TextButton(
//                 child: Text(
//                   'Change Number'.tr,
//                   style: TextStyle(
//                     color: Color(0xFF032674),
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 onPressed: () {
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
