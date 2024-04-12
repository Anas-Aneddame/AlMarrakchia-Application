import 'package:new_app/widgets/next_adhan.dart';
import 'package:new_app/widgets/today_adhan_time.dart';
import 'package:new_app/widgets/geo_location.dart';


import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class AdhanPage extends StatefulWidget {
  const AdhanPage({super.key});

  @override
  State<AdhanPage> createState() => _AdhanPageState();
}

class _AdhanPageState extends State<AdhanPage> {
  double _latitude=0;
  double _longitude=0;

  //2 returns a circularProgressindicator, 1 returns the adhan times, 0 returns a view to access settings to grant permission
  int _hasLocation = 2;
  DateTime date =  DateTime.now();

  @override
  void initState(){
     super.initState();
     getCoordinates();
  }

  getCoordinates()
  {
    if(mounted)
    {
      getPosition().then((position) {
      if(position!=null)
      {
        setState(() {
        _latitude = position.latitude;
        _longitude=position.longitude;
        _hasLocation = 1;
              
      });
      }
      else{
        setState(() {

        _hasLocation=0;
        
        });
      }

     }
     );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA80D14),
        elevation: 0.0,
        title: const Text(
         'اوقات الصلاة',
          style: TextStyle(
            color : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            ),
        ),
        centerTitle: true,
        // leading:  IconButton(
        //   onPressed: (){
        //     Navigator.pop(context);
        //   },
        //   icon: const Icon(Icons.arrow_back),
        //   color: Colors.white,
        //  ),
      ),
      body:Container( decoration: BoxDecoration(
      image: DecorationImage(
        image:const AssetImage("assets/images/adhan/koutoubia.jpg"),
        fit :  BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.srcOver,),
        ),
    ),
    child:getAdhanView(),
    
    
    )
      
    );
  }

  Widget getAdhanView()
  {
    if(_hasLocation==1)
    {
      return  ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(40.0),
            child: NextAdhan(_latitude,_longitude,date),
          ),

          Container(
            margin: const EdgeInsets.only(top: 30.0),
            child: AdhanTime(_latitude,_longitude),
          )

        ],
      );

    }
    else if(_hasLocation==0)
    {
      return RefreshIndicator(
          onRefresh: () async {
            return getCoordinates();
          },
          child: Center(
            child: ListView(children: [
              SizedBox(
                height:MediaQuery.of(context).size.height*0.8,
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      const Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          "المرجو التحقق من تفعيل الموقع أو إذن استخدامه",
                          style: TextStyle(
                            // color:Colors.grey,
                            fontSize: 18,
                            color: Color(0xFFa80d14),
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => openAppSettings(),
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(
                            // Customize the text style of the button
                            fontSize: 20,
                            color: Color(0xFFa80d14),
                          )),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(
                                0xFFa80d14), // Set the text color to white
              
                            // Customize the background color of the button
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 2, 5, 2),
                          child: Text('إفتح الإعدادات'),
                        ),
                      ),
                    ])),
              ),
            ]),
          ),
        );

    }

    return  const Center(
    child:SizedBox(
      width:60 ,
      height: 60,
      child: CircularProgressIndicator(),
    )
    );


  }
}




