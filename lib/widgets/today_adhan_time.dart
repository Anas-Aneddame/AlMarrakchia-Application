import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:new_app/widgets/get_adhan_time.dart';

class AdhanTime extends StatefulWidget {
  final double lat;
  final double long;
  const AdhanTime(this.lat,this.long,{super.key});


  @override
  State<AdhanTime> createState() => _AdhanTimeState();
}

class _AdhanTimeState extends State<AdhanTime> {
  Map<int,String> dayOfTheWeek = {
    1:"الاثنين",
    2:"الثلاثاء",
    3:"الأربعاء",
    4:"الخميس",
    5:"الجمعة",
    6:"السبت",
    7:"الأحد",
  };

  Map<int,String> months ={
    1:"يناير",
    2:"فبراير",
    3:"مارس",
    4:"أبريل",
    5:"ماي",
    6:"يونيو",
    7:"يوليوز",
    8:"غشت",
    9:"شتنبر",
    10:"أكتوبر",
    11:"نونبر",
    12:"دجنبر",

  };
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: (){
                    if(mounted)
                    {
                    setState(() {
                      date = date.add(const Duration(days: -1));
                    });
                    }
                  }, icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0,2.0),
                  )
                ],

              )),
              Text(
                "${date.year} ${dayOfTheWeek[date.weekday]} ${date.day} ${months[date.month]} ",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0,2.0),
                    )
                  ],

                ),
              ),
              IconButton(
                  onPressed: (){
                    if(mounted)
                    {
                      setState(() {
                      date = date.add(const Duration(days: 1));
                    });
                    }

                  }, icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0,2.0),
                  )
                ],
              )),


            ],),
        ),
        Column(
          children: todayAdhanTime(widget.lat,widget.long,date),
        )
      ],
    );
  }
}

String addZero(int element){
  return element.toString().padLeft(2,"0");
}

List<Widget> todayAdhanTime(double lat,double long,DateTime dateTime)
{
  PrayerTimes prayerTimes = getPrayerTime(lat, long, dateTime);
  DateTime fajr = prayerTimes.fajr!;
  DateTime dhuhr = prayerTimes.dhuhr!;
  DateTime asr = prayerTimes.asr!;
  DateTime maghrib = prayerTimes.maghrib!;
  DateTime isha = prayerTimes.isha!;
  if(dateTime.timeZoneName=="+01")
  {
    fajr =  fajr.add(const Duration(hours: 1));
    dhuhr =  dhuhr.add(const Duration(hours: 1));
    asr =  asr.add(const Duration(hours: 1));
    maghrib =  maghrib.add(const Duration(hours: 1));
    isha =  isha.add(const Duration(hours: 1));
  }


  Map<String,DateTime> adhanTimeMap ={
    "الصبح":fajr,
    "الظهر":dhuhr,
    "العصر":asr,
    "المغرب":maghrib,
    "العشاء":isha,
  };

  List<Widget> widgetList =[];

  adhanTimeMap.forEach((adhan, time) {


    Widget adhanRow =Container(
      margin: const EdgeInsets.only(left: 30,right: 30,top:10,bottom: 10),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${addZero(time.hour)}:${addZero(time.minute)}",style: const TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold,shadows: [Shadow(blurRadius: 10.0,color: Colors.black,offset: Offset(2.0,2.0),)]),),
          Text(adhan,style: const TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold,shadows: [Shadow(blurRadius: 10.0,color: Colors.black,offset: Offset(2.0,2.0),)]),),
        ],),
    );

    widgetList.add(adhanRow);

  });

  return widgetList;

}