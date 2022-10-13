
import 'package:flutter/material.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: const [

          Text(
            'Current: OOP',
            style: TextStyle(
              color: Color.fromARGB(255, 205, 238, 219),
              fontSize: 32,
              wordSpacing: 10,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
            // textAlign: TextAlign.center,
          ),
          Text(
            '11:00 - 12:30',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              wordSpacing: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 40,),

          Text(
            'Upcoming: DLD',
            style: TextStyle(
              color: Color.fromARGB(255, 205, 238, 219),
              fontSize: 24,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w700,
            ),
            // textAlign: TextAlign.center,
          ),
          Text(
            '2:15 - 3:45',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}