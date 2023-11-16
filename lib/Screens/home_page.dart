import 'package:flutter/material.dart';
import 'package:wifi_geo_map/Screens/loading_page.dart';
import 'package:wifi_geo_map/utils/custom_inkwell.dart';
import 'package:wifi_geo_map/utils/custom_sizedbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assests/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.08,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.08,
                ),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8183),
                      border: Border.all(
                        color: const Color(0xFF000000),
                        width: 3,
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                          hintText: '  Search for a user',
                          hintStyle: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.search,
                            size: 30,
                            color: Color(0xFF000000),
                          )),
                    ),
                  ),
                ),
              ),
              const CustomSizedBox(
                height: 0.73,
                width: 1,
                child: Center(child: Text("here comes data")),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF000000),
                      width: 3.0,
                    ),
                  ),
                ),
                child: const CustomSizedBox(
                  height: 0.1,
                  width: 1,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomInkWell(icon: Icons.settings, pageName: LoadingPage()),
                        CustomInkWell(icon: Icons.home, pageName: LoadingPage()),
                        CustomInkWell(icon: Icons.person, pageName: LoadingPage()),
                      ],
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
