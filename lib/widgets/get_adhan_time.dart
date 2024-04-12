import 'package:adhan_dart/adhan_dart.dart';


PrayerTimes getPrayerTime(double lat,double long,DateTime date)
{
    Coordinates coordinates =  Coordinates(lat, long);
    CalculationParameters params = CalculationMethod.Morocco();
    PrayerTimes prayerTimes =  PrayerTimes(coordinates, date, params);
    return prayerTimes;
}