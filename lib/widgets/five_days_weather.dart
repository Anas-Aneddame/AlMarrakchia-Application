import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';



Map<int,String> dayOfTheWeek = {
  1:"الاثنين",
  2:"الثلاثاء",
  3:"الأربعاء",
  4:"الخميس",
  5:"الجمعة",
  6:"السبت",
  7:"الأحد",
};
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

List<Weather> filteredList(List<Weather> weatherList)
{ 
  List<Weather> filteredlist = [];

  TimeOfDay time1 = const TimeOfDay(hour: 12, minute: 00);

  for(Weather w in weatherList)
  {
    if(time1==TimeOfDay.fromDateTime(w.date!))
    {
      filteredlist.add(w);
    }
  }
  return filteredlist;
}

Widget fiveDaysWeather(Future<List<Weather>> weatherList) {

  return  FutureBuilder<List<Weather>>(
      future:weatherList ,
      builder:(BuildContext context, AsyncSnapshot<List<Weather>> snapshot){
        List<Widget> children=[Container()];
        if(snapshot.hasData)
        {children = <Widget>[
            forecastHorizontal(snapshot.data!),
         ];
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );

      } 
      
      )
  ;
}


/* Widget fiveDaysWeatherView(List<Weather> weatherList)
{ 
  weatherList = filteredList(weatherList);
  const shadow = Shadow(blurRadius: 10.0,color: Colors.black,offset: Offset(2.0,2.0));
  return  Table(
      children: weatherList.map((w) => TableRow(
        children: [
          TableCell(
            child: getWeatherImage(w.weatherIcon)),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child:Text("${w.temperature}°",textAlign: TextAlign.center,style: const TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.white,shadows: [shadow]),), ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            const Icon(FontAwesomeIcons.wind,color: Colors.white,shadows: [shadow]),
            Text("${w.windSpeed}",textAlign: TextAlign.center,style: const TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.white,shadows: [shadow]),),
          ],),),
          TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: 
          Text("${dayOfTheWeek[w.date!.weekday]}",textAlign: TextAlign.center,style: const TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.white,shadows: [shadow]),),
          )
      ])).toList(),
    ) ;
}
Widget getWeatherImage(String? weatherIcon)
{
  
if(weatherIcon=="01n")
  {
    return Image.asset("assets/images/weather/crescent.png",height:50,width: 50,);

  }

  return Image.network("https://openweathermap.org/img/wn/$weatherIcon.png");
} */

Widget forecastHorizontal(List<Weather> weatherList)
{
  const shadow = Shadow(blurRadius: 8.0,color: Colors.black,offset: Offset(2.0,3.0));
  return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: weatherList.length,
        separatorBuilder: (context, index) => const Divider(
              height: 100,
              color: Colors.white,
            ),
        itemBuilder: (context, index) {
          final item = weatherList[index];
          DateTime date = item.date!;
          String time = DateFormat('Hm').format(date);
          final int temp = item.temperature!.celsius!.round();
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children : [
                      Text(
                        " ${dayOfTheWeek[item.date!.weekday]} $time",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          shadows: [shadow],                    )
                        ),
                      Icon(
                        weatherIcon["${item.weatherIcon}"],
                        color: Colors.white,
                        size: 35,
                        shadows: const [shadow],
                        ),
                      const SizedBox(height: 15,),
                      Text(
                        '$temp°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          shadows: [shadow],
                          )
                
                        ,)
                              
                            ],),
                )),
          );
        },
      ),
    );
  }
