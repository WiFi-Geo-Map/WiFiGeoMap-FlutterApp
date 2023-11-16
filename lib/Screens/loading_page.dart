import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          const SizedBox(
            child: Center(
              child: Text(
                "Singing In",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 26, 98, 158),
                    fontSize: 42,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
          Image.asset(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            'assets/Images/splash.gif',
          ),
          const SizedBox(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 26, 98, 158),
            ),
          )
        ],
      ),
    );
  }
}
