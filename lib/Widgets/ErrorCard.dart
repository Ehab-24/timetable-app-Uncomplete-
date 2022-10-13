
import 'package:flutter/material.dart';
import '../Globals/Utils.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    Key? key,
    required this.content,
  }) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Dialog(

      backgroundColor: Colors.transparent,

      child: Stack(

        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,

        children: [

          Container(
            margin: EdgeInsets.symmetric(horizontal: Utils.screenWidthPercentage(context, 0.04)),
            
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
          
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            
            child: Column(
          
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [

                const SizedBox(height: 40,),

                const Center(
                  child: Text(
                    'Error Occured! once again',
                    style: TextStyle(
                      color: Color.fromRGBO(84, 110, 122, 1),
                      fontSize: 28,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),

                const SizedBox(height: 20,),

                Text(
                  content,
                  style: const TextStyle(
                    color: Color.fromRGBO(55, 71, 79, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),
                
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.cyan,
                    side: const BorderSide(color: Colors.cyan),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)
                    )
                  ),
                  child: const Text(
                    'Close',
                  ),
                )
              ],
            ),
          ),
          
          //Circular Indicator
          const Positioned(
            top: -30,
            child: CircleAvatar(
              foregroundColor: Color.fromRGBO(238, 238, 238, 1),
              backgroundColor: Color.fromARGB(255, 218, 8, 71),
              radius: 30,
              child: Icon(Icons.nearby_error, size: 30,),
            ),
          )
        ],
      ),
    );
  }
}