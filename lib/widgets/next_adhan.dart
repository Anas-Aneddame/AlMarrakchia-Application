
import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:new_app/widgets/get_adhan_time.dart';
import 'dart:async';

class NextAdhan extends StatefulWidget {
  final double lat;
  final double long;
  final DateTime date;
  const NextAdhan(this.lat,this.long,this.date,{super.key});


  @override
  State<NextAdhan> createState() => _NextAdhanState();
}

class _NextAdhanState extends State<NextAdhan> {
  String time = "";
  String nextPrayer ="";
  

  final  Map<String,String> prayers={
    "fajr":"الصبح",
    "dhuhr":"الظهر",
    "asr":"العصر",
    "maghrib":"المغرب",
    "isha":"العشاء",
    "fajrafter":"الصبح",
    "sunrise":"شروق الشمس",
    "":"",
  };

  @override
  void initState()
  {
    super.initState();

    startTimer();

  }
void timeToNextAdhan() 
{
    DateTime dateTime = DateTime.now();
    PrayerTimes prayerTimes = getPrayerTime(widget.lat, widget.long, dateTime);
    String nextPrayer = prayerTimes.nextPrayer();
    DateTime? nextPrayerDate = prayerTimes.timeForPrayer(nextPrayer);
    int seconds = nextPrayerDate!.difference(dateTime).inSeconds;

    int hours = seconds~/3600;
    int minutes = seconds~/60;
    seconds -=minutes*60;
    minutes-=hours*60;
    if(mounted)
    {
          setState(() {
      String h=(hours <10 ? "0$hours":"$hours");
      String m=(minutes <10 ? "0$minutes":"$minutes");
      String s=(seconds <10 ? "0$seconds":"$seconds");

      this.nextPrayer = nextPrayer;
      time = "-$h:$m:$s";
    });
    }
}
  void startTimer()
  {
    Timer.periodic(const Duration(seconds: 1),(_)=>timeToNextAdhan());
  }
  
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("${prayers[nextPrayer]}",style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 10.0,
            color: Colors.black,
            offset: Offset(2.0,2.0),
          )
        ]
        
        
        ),
        ),
      Text(time,style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 10.0,
            color: Colors.black,
            offset: Offset(2.0,2.0),
          )
        ]
        
        ),),

    ],
  );
  }
}