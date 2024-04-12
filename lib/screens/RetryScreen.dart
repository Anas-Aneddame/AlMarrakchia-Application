import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class RetryScreen extends StatefulWidget {
  const RetryScreen({Key? key}) : super(key: key);

  @override
  State<RetryScreen> createState() => _RetryScreenState();
}

class _RetryScreenState extends State<RetryScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text("ليس هناك اتصال",style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFFa80d14),
                    ),),
                  ),
                  TextButton(onPressed: ()=>{
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Directionality(textDirection: TextDirection.rtl, child: Home())),
                  )                  },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5.0,2,5,2),
                      child: Text("أعد المحاولة"),
                    ),  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        // Customize the text style of the button
                        fontSize:20,
                        color: Color(0xFFa80d14),

                    )),

                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFFa80d14), // Set the text color to white

                      // Customize the background color of the button
                    ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,

                      ),
                  ),
                  )
                ],
          )),
    );
  }
}
