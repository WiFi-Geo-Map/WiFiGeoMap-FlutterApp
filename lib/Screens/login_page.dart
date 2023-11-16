import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wifi_geo_map/provider/googel_signin.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 163, 187, 207),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          const SizedBox(
            child: Center(
              child: Text(
                "Login to continue",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
          Image.asset(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            'assets/Images/login.gif',
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Color.fromARGB(255, 238, 176, 84),
            ),
            onPressed: () {
              final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
              provider.googleLogin();
            },
            label: const Text(
              "     SignIn with Google",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 131, 86, 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
