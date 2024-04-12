import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_app/services/parser.dart';
import 'package:http/http.dart' as http;

class Article {
  int id;
  String title;
  String content;
  String image;
  int category;
  String date;
  late String link;
  late bool isFavorite=false;
  String tags;

  Article(this.id,this.title, this.content,this.image,  this.date,this.link, this.category, this.tags);

  static Map<int,String> categoriesList={216: 'أخبار',
  1: 'المراكشية تي في',
  231: 'تعليم ـ جامعة',
  186: 'ثقافة ـ أبحاث',
  320: 'خاص رمضان',
  274: 'رأي',
  197: 'رياضة',
  120: 'مراكش الذاكرة',
  171: 'منوعات',
  288: 'هنا وهناك'};

  //Cette fonction retourne une instance de Article avec les propriétés initialisées à partir des valeurs dans l'objet JSON.
  factory Article.fromJson(Map<String, dynamic> json,bool isUniversity) {
    var category = isUniversity ? 231: json['categories'][0];
    return Article(
      json['id'],
      json['title']['rendered'],
      json['content']['rendered'],
      Parser.getImage(json['content']['rendered']),
      json['date'],
      json['link'],
      category,
      ' ',
    );
  }
  static Future<List<Article>> getAllNews(int categoryId,int page) async {
    String url ;
    bool isUniversity = false;
    if(categoryId==0){
      url = "https://www.almarrakchia.net/wp-json/wp/v2/posts?page=$page";
    }
    else if(categoryId==231)
    {
      url="https://enssup.almarrakchia.net/wp-json/wp/v2/posts?page=$page";
      isUniversity = true;
    }
    else{
    url = "https://www.almarrakchia.net/wp-json/wp/v2/posts?categories=$categoryId&page=$page";
    }

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Article> posts =
      data.map((article) => Article.fromJson(article,isUniversity)).toList();
      return posts;
    } else {
      return Future.error("sever error");
    }
  }
}