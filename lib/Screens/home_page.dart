import 'package:flutter/material.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  @override
  Widget build(BuildContext context) {
    return const SkeletonPage(isSearching: true, child: Center(child: Text("hello:)")) );
  }
}

// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:wifi_geo_map/provider/googel_signin.dart';

// import '../provider/controller.dart';

// class UserPage extends StatefulWidget {
//   const UserPage({super.key});

//   @override
//   State<UserPage> createState() => _UserPageState();
// }

// class _UserPageState extends State<UserPage> {
//   final user = FirebaseAuth.instance.currentUser!;

//   ControllerPage controll() => const ControllerPage();

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Column(children: [
//         AppBar(
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.blueGrey,
//                   Color.fromARGB(255, 132, 174, 207),
//                   Color.fromARGB(255, 223, 103, 143),
//                 ],
//               ),
//             ),
//           ),
//           elevation: 0.0,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(15),
//             ),
//           ),
//           title: const Text(
//             "Profile",
//             style: TextStyle(
//               fontSize: 30,
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         Container(
//           padding:
//               EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
//           child: Column(
//             children: [
//               SizedBox(
//                 width: 120,
//                 height: 120,
//                 child: CircleAvatar(
//                   backgroundImage: NetworkImage(user.photoURL!),
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.025),
//               Text(
//                 user.displayName!,
//                 style: const TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//               Text(
//                 user.email!,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//               SizedBox(
//                   width: 200,
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.yellow),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18.0),
//                           side: const BorderSide(color: Colors.red),
//                         ),
//                       ),
//                     ),
//                     onPressed: () {},
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 15.0),
//                       child: Text(
//                         "Edit Details",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   )),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//               SizedBox(
//                 width: 200,
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all<Color>(Colors.yellow),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18.0),
//                         side: const BorderSide(color: Colors.red),
//                       ),
//                     ),
//                   ),
//                   onPressed: () {
//                     final provider = Provider.of<GoogleSignInProvider>(context,
//                         listen: false);
//                     provider.logout();
//                     Timer(const Duration(milliseconds: 1800), () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ControllerPage(),
//                         ),
//                       );
//                       Navigator.pop(context);
//                     });
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 15.0),
//                     child: Text(
//                       "Log out",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         )
//       ]),
//     );
//   }
// }
