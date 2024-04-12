 import '../models/Article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;
 import 'dart:convert';

import '../screens/ArticleScreen.dart';
import '../screens/Home.dart';
import '../screens/searchPosts.dart';

class CustomSearchDelegate extends SearchDelegate{




 List<String> searchTerms=['الثقافة وبحوث','تعليم ـ جامعة','رياضة','منوعات','المراكشية تي في','مراكش الذاكرة','أخبار'];
  static late  List<dynamic> articles ;
  // To clear the query
  @override
  String get searchFieldLabel => "ابحث";
  Future<List<Article>> searchPosts(String searchTerm) async {
    final url = 'https://www.almarrakchia.net/wp-json/wp/v2/posts?per_page=25&search=$searchTerm';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Article> posts =
      data.map((article) => Article.fromJson(article,false)).toList();
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: ()=>{query=''}, icon: Icon(Icons.clear))
    ];
  }
 @override
 Widget build(BuildContext context) {
   return new Directionality(
       textDirection: TextDirection.rtl,
       child: TextField(
       textAlign: TextAlign.right,
       autofocus: true,
       decoration: new InputDecoration(
       labelText: "افزودن کتاب",
       hintText: "نام کتاب را وارد کنید"
   ),
   ));
 }

  @override
  Widget? buildLeading(BuildContext context) {
    return
      IconButton(onPressed: (){close(context, null);}, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context){

    return Directionality(
        textDirection: TextDirection.rtl, child: SearchPosts(articles:searchPosts(query)));
}

  @override
  Widget buildSuggestions(BuildContext context) {

    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Home(),
    );
  }




}
