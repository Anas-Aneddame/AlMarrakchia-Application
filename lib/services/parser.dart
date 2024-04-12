import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Parser{

  static getImage(imgUrl){

     // getMedia(imgUrl);
    var document = parse(imgUrl);
    var imgElement = document.querySelector('img');
    var videoElement = document.querySelector('iframe');

    if(videoElement!=null && videoElement.attributes['src']!.contains('youtube')){
      String? videoId = YoutubePlayer.convertUrlToId(videoElement.attributes['src']!);
      String thumbnailUrl = YoutubePlayer.getThumbnail(videoId: videoId!,webp: false,quality:"0");
      // return videoElement.attributes['src'];
      return thumbnailUrl;

    }
    else
      {
        return imgElement != null ? imgElement.attributes['src'] ?? '' : '';
        
      }
  }
  static getMedia(media){
    var document = parse(media);
    var videoElement = document.querySelector('iframe');
    if(videoElement!=null){
    return 'https://www.youtube.com/watch?v=GQyWIur03aw';
  }
    else{
      var imgElement = document.querySelector('img');
      return imgElement?.attributes['src'] ;
    }



  }
  static String getText(content){
    var document = parse(content);
    String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;


  }
  static getDate(date) {
    List<String> dayNamesArabic = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد'
    ];
    final DateTime dateTime = DateTime.parse(date);
    int dayNumber = dateTime.weekday;
    final arabicMonthsMap = {
      1: 'يناير',
      2: 'فبراير',
      3: 'مارس',
      4: 'أبريل',
      5: 'ماي',
      6: 'يونيو',
      7: 'يوليوز',
      8: 'غشت',
      9: 'شتنبر',
      10: 'أكتوبر',
      11: 'نونبر',
      12: 'دجنبر',
    };
    final monthNumber = dateTime.month;
    final monthName = arabicMonthsMap[monthNumber];
    String dayName=dayNamesArabic[dayNumber-1];

    String formattedDate = DateFormat('$dayName  d $monthName yyyy').format(dateTime);


    return formattedDate;
  }
  static String titleDecoder(String title) {
    HtmlUnescape unescape = HtmlUnescape();
    String titleDecode = unescape.convert(title);
    return titleDecode;
  }

}