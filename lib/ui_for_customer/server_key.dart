// import 'package:googleapis_auth/auth_io.dart';
//
// class GetServerKey {
//   Future<String> getServerKeyToken() async {
//     final scopes = [
//       'https://www.googleapis.com/auth/userinfo.email',
//       'https://www.googleapis.com/auth/firebase.database',
//       'https://www.googleapis.com/auth/firebase.messaging',
//     ];
//
//     final client = await clientViaServiceAccount(
//       ServiceAccountCredentials.fromJson({
//
//       }
//       ),
//       scopes,
//     );
//     final accessServerKey = client.credentials.accessToken.data;
//     print("Server key is: ${accessServerKey}");
//     return accessServerKey;
//   }
// }
//
// Future<void> sendPushNotification(String token, Map<String, dynamic> scheduleData) async {
//   try {
//     final String serverKey ='ya29.c.c0ASRK0GblOc2RBhRGRxVFfXvjIeH4q1Ip6Lriljb553P5Y_6HKU5oy_t8yACpRRRDfzyUI8UN-2mKWHuXGRf5g6umuuV3KAJ3qhZ-afbYuAaO-goh6eOL6zTbxGkVV7Zd8SL6StgBi6qb0k6YnJ7tI-byyedm4_KEMu_e2m7_QSRTmPSxODVvtY6gzNl4ncPC2h0-p7SWp2c9mj9MpgAEeWLDl7JJ9VfQDoEu53EAnYEaMHQZV5gxJisCr8SuA_h1OXbxoPlrHmOr7vVxt11-8VfyHghJkzdEfBVB7xr1IeIFBrwmGS_2eq58nLdknT0T47Z0Ajko-l2GYBK87rXGsf1PejE9bZg7JibKOuM24waBpW3UYf8fY2IA0wNOhwT391KUcMJgwdOXI6iVs9zM0YnooQ6mt89qhWZnihVS645m0U4lq9jRc7tRb_1t1bUye0R49oQpY0BwVZiFSzhn9MU9Z6f1Bx65BV_bt7lzS8u_avk_7bkcI41Y0UVJyRbzYIg-eOdl7YRxgrtju_zo3j8234qn1dyqnJSVY20RsepmarSzFjX5d9xhBU8eMuQQj2rwh4VO8jckXpw1YSeJRufdQxfii1sgvJjWUki72gUbjwss67nRr1b4MqxnFv71w7XWQMSxyyf6cb3lvb1JY6dM3kXYu5ytV3y3Bs-Zck6deMwoU-lwsb9Z9510-Il3ethMyw_vMwuypBQgauQy2-kJQfi_yzXhla9Y-g8_6VqfXVrrZ77MUFFhmkMVUfZx3ytwhrF-27uXyRMpWZvu-aeZFBMz6-Bom-0p3R0amIJaZOvB48ikmz506R-sS5b0R4m307XB';
//     final Uri url = Uri.parse("https://f...content-available-to-author-only...s.com/v1/projects/be-food-4bc9b/messages:send");
//
//     // Construct the notification payload
//     Map<String, dynamic> notificationData = {
//       "message": {
//         "notification": {
//           "title": "New Schedule Added",
//           "body": "A new schedule has been added. Check it now!",
//         },
//         "data": scheduleData,
//         "token": 'ya29.c.c0ASRK0GbHJLAVhoBhy6Pmm290vMhNhckImVvEXFEhOTA9moxGIl1IBqFGKXjCDs8Gf06kBoQ0pFsNqLoLAvag4CXTT3_6EjDlef4HljdTf53mSOFE2dSZnKG8BB1pxONZX57x_w-kAplV2S2dFkpJqDRTNN9o3YV2ofleAd11m0V9YQ0xoJDDdszmd713DOE474qaHD80DGkw76Zr3Zof53dTS8KFusJCTpb2R8I0wNzd2-QZZNLWYPwnIXGnIIuA_uV3bZw8SuFbIs7_Ysw6kHBSFy7rqv3YgFLARSXiuGmmmnx44-OSHxQUNIZIOUmPihB7YzPzuB543w4eCGMs-5348ZFG5DAQ9bW24QvbXNk0kbx7-de9FBEXg3YH388CS6tVsM6otao6zJM4tlWbiBeuU5_1SV7bSvqBS4a66Wt-k-VdzUXciki_6-oYyt7Whp_IXkyjp13VmjdrUeqRov7fdpeS04bQ2_M-kasefcZ6hIc6t3w85f32m5sR1cIFoYVc6-dm6QfF-9ry9_OcX6zFZJOOYbmORYRY2gajZZ4IU3WhQFdylon_BJb52tm2qnv2xOtZIsshkn9c4Zq5VZ4j7da_Y44x0bUatSmQ2fBc30-Wanh539eppIlxa1OwtYzWOrg_hryY7Z5r4tY_sZojOVIiXiekqb3XWorURlbnV63Rokckcv0boOQx0Y754ecFjBnahF3ellQRfnwlBb8c2ynSRrv0BtouZVU6Xugdf5zM-vWQuifYd5kWgn5vp5d50dvqwW1SJkR13UUJacQ4W4Od7J__eMeSkwmny4ZsZk4f0l0yevYsp_iQ6svWv5tJv73u6hYMS3Boj1O5vt0SndvnOFRUupnb0haBSZ4IZi6zt9y6luebOo0dRkUeORFd5RVUnlyzVqk1W6QO9yJnb59vb41ymJ8lJRSFxsrMR-R_c3vul6piqR_0n_x_t-gM6n0cR0t5tm-yhaRmxBucOJtyJSqgJFq-qYeVrmrd2Y', // Send to individual token
//       },
//     };
//
//     // Headers for the FCM API
//     Map<String, String> headers = {
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $serverKey",
//     };
//
//     // Send POST request to FCM
//     final response = await http.post(
//       url,
//       headers: headers,
//       body: json.encode(notificationData),
//     );
//
//     if (response.statusCode == 200) {
//       print("Notification sent successfully to token: $token");
//     } else {
//       final responseBody = json.decode(response.body);
//       print("Failed to send notification to token: $token, Response: $responseBody");
//
//       // Handle invalid tokens
//       if (responseBody["error"]?["details"] != null) {
//         for (var detail in responseBody["error"]["details"]) {
//           if (detail["@type"] == "type.googleapis.com/google.rpc.BadRequest" &&
//               detail["fieldViolations"] != null) {
//             for (var violation in detail["fieldViolations"]) {
//               if (violation["field"] == "message.token" &&
//                   violation["description"] == "Invalid registration token") {
//                 throw Exception("Invalid registration token");
//               }
//             }
//           }
//         }
//       }
//     }
//   } catch (e) {
//     print("Error sending notification to token: $e");
//     rethrow; // Rethrow the exception to handle invalid tokens in the calling method
//   }
// }
// final get=GetServerKey();
// String serverkey1=await get.getServerKeyToken();
// print("Server key=${serverkey1}");
// String? token = await FirebaseMessaging.instance.getToken();
// print("FCM Token: $token");
// // try {
//
// final Uri url = Uri.parse("https://fcm.googleapis.com/v1/projects/be-food-4bc9b/messages:send");
//
// // Construct the notification payload
// Map<String, dynamic> notificationData = {
// "message": {
// "notification": {
// "title": "Congrats!",
// "body": "You Got an Order",
// },
// 'token': token,
// },
// };
//
// // Headers for the FCM API
// Map<String, String> headers = {
// "Content-Type": "application/json",
// "Authorization": "Bearer ${serverkey1}",
// };
//
// // Send POST request to FCM
// final response = await http.post(
// url,
// headers: headers,
// body: json.encode(notificationData),
// );
//
// if (response.statusCode == 200) {
// print("Notification sent successfully to token:$token");
// } else {
// final responseBody = json.decode(response.body);
// print("Failed to send notification to token, Response: $responseBody");
//
// // Handle invalid tokens
// if (responseBody["error"]?["details"] != null) {
// for (var detail in responseBody["error"]["details"]) {
// if (detail["@type"] == "type.googleapis.com/google.rpc.BadRequest" &&
// detail["fieldViolations"] != null) {
// for (var violation in detail["fieldViolations"]) {
// if (violation["field"] == "message.token" &&
// violation["description"] == "Invalid registration token") {
// throw Exception("Invalid registration token");
// }
// }
// }
// }
// }
// }
// // } catch (e) {
// //   print("Error sending notification to token: $e");
// //   rethrow; // Rethrow the exception to handle invalid tokens in the calling method
// //
// }
//
