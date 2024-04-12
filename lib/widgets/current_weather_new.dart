import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:new_app/widgets/five_days_weather.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:geocoding/geocoding.dart';

class CurrentWeather extends StatefulWidget {
  final double lat;
  final double long;
  const CurrentWeather(this.lat,this.long,{super.key});

  @override
  State<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  final WeatherFactory wf = WeatherFactory("d35941f9a438387d69222413f6d5a8be",language: Language.ARABIC);
  final Map<String,String> imageOfWeather ={
    "01d":"clear_sky.jpg",
    "01n":"clear_sky_night.jpg",
    "02d":"broken_clouds.jpg",
    '02n':"scattered_clouds_night.jpg",
    "03d":"scattered_clouds.jpg",
    "03n":"scattered_clouds_night.jpg",
    "04d":"broken_clouds.jpg",
    "04n":"scattered_clouds_night.jpg",
    "09d":"rain.jpg",
    "09n":"rain.jpg",
    "10d":"rain.jpg",
    "10n":"rain.jpg",
    "11d":"thunderstorm.jpg",
    "11n":"thunderstorm.jpg",
  } ;
  final Map<String,IconData> weatherIcon ={
    "01d":WeatherIcons.day_sunny,
    "01n":WeatherIcons.night_clear,
    "02d":WeatherIcons.day_cloudy,
    '02n':WeatherIcons.night_cloudy,
    "03d":WeatherIcons.cloud,
    "03n":WeatherIcons.cloud,
    "04d":WeatherIcons.cloudy,
    "04n":WeatherIcons.cloudy,
    "09d":WeatherIcons.rain,
    "09n":WeatherIcons.rain,
    "10d":WeatherIcons.day_rain,
    "10n":WeatherIcons.day_rain,
    "11d":WeatherIcons.thunderstorm,
    "11n":WeatherIcons.thunderstorm,
  } ;

  String city ='';
  @override
  void initState(){
    super.initState();
    getCityByCoordinates(widget.lat,widget.long).then((position) {
      if(mounted)
      {
              setState(() {
        city = position.first.locality!;
      });
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    final Future<Weather> weather=wf.currentWeatherByLocation(widget.lat,widget.long);
    final Future<List<Weather>> weatherList=wf.fiveDayForecastByLocation(widget.lat,widget.long);

    return FutureBuilder<Weather>(
        future: weather ,
        builder:(BuildContext context, AsyncSnapshot<Weather> snapshot){
          Widget child=Container();
          if(snapshot.hasData)
          {
            String? weatherCon = imageOfWeather[snapshot.data!.weatherIcon];
            child = Container( decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/weather/$weatherCon"),
                fit :  BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.srcOver,),
              ),
            ),
                child: ListView(
                  children: [
                    currentWeatherView(snapshot.data!,city),
                    const SizedBox(
                      height: 20,
                    ),
                    additionalInfo(snapshot.data!),
                    const SizedBox(
                      height: 20,
                    ),
                    fiveDaysWeather(weatherList),
                  ],
                )

            );
          }
          return child;
        }

    );


  }

  Widget currentWeatherView(Weather weather,String city)
  {
    int currentTemp = weather.temperature!.celsius!.round();
    const shadow = Shadow(blurRadius: 8.0,color: Colors.black,offset: Offset(2.0,3.0));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            city,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
              shadows: [shadow],


            ),
          ),
        ),

        Text(
            "${weather.weatherDescription}",
            style: const TextStyle(
                color: Colors.white,
                fontSize:25,
                fontWeight:FontWeight.w100 ,
                letterSpacing:2,
                shadows: [shadow]
            )
        ),
        Icon(
          weatherIcon["${weather.weatherIcon}"],
          color: Colors.white,
          size: 75,
          shadows: const [shadow],

        ),
        Padding(
          padding:
          const EdgeInsets.only(top: 20),
          child: Text(
            " $currentTemp°",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 90,
                fontWeight: FontWeight.w300,
                shadows: [shadow]
            ),
          ),
        ),
      ],
    );
  }

}

Widget additionalInfo(Weather weather)
{
  String sunrise = DateFormat("Hm").format(weather.sunrise!);
  String sunset = DateFormat("Hm").format(weather.sunset!);
  const shadow = Shadow(blurRadius: 8.0,color: Colors.black,offset: Offset(2.0,3.0));
  return Padding(
    padding: const EdgeInsets.only(left:20,right:20,top:20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Text("سرعة الرياح",
                style:  TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,shadows: [shadow])),
            emptySpaceH(),
            Text("${weather.windSpeed}m/s",
                style:  const TextStyle(color: Colors.white,fontSize: 22,fontWeight:FontWeight.w300,shadows: [shadow])),
          ],),

        emptySpaceW(),
        Column(
          children: [
            const Text("الغروب",
                style:   TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,shadows: [shadow])
            ),
            emptySpaceH(),
            Text(sunset,
                style:   const TextStyle(color: Colors.white,fontSize: 22,fontWeight:FontWeight.w300,shadows: [shadow])
            ),
          ],),
        emptySpaceW(),
        Column(
          children: [
            const Text("الشروق",
                style:   TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,shadows: [shadow])),
            emptySpaceH(),
            Text(sunrise,
                style:   const TextStyle(color: Colors.white,fontSize: 22,fontWeight:FontWeight.w300,shadows: [shadow])
            ),
          ],),
        emptySpaceW(),
        Column(
          children: [
            const Text("الرطوبة",
                style:   TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,shadows: [shadow])
            ),
            emptySpaceH(),
            Text("${weather.humidity}%",
                style:   const TextStyle(color: Colors.white,fontSize: 22,fontWeight:FontWeight.w300,shadows: [shadow])
            ),
          ],)
      ],


    ),

  );
}


Widget emptySpaceW()
{
  return const SizedBox(width: 8,);
}
Widget emptySpaceH()
{
  return const SizedBox(height: 10,);
}

Future<List<Placemark>> getCityByCoordinates(double lat,double long) async
{
  return await placemarkFromCoordinates(lat, long);

}