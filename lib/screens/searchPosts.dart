import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

import '../models/Article.dart';
import '../widgets/newsCard.dart';
import 'ArticleScreen.dart';

class SearchPosts extends StatefulWidget {
  Future<List<Article>>? articles;

   SearchPosts({Key? key, required this.articles}) : super(key: key);

  @override
  State<SearchPosts> createState() => _SearchPostsState();
}

class _SearchPostsState extends State<SearchPosts> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

            body: Center(
              child: FutureBuilder<List<Article>>(
                future: widget.articles,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Article>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Afficher un indicateur de chargement pendant que la Future est en attente
                    return const CircularProgressIndicator(
                      color: Color(0xFFa80d14),
                    );
                  }

                  else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // Afficher les données une fois que la Future est résolue
                  List<Article>? articles = snapshot.data;

                  return ListView(
                  children: articles != null
                      ?  articles.map((article) {
                  return NewsCard(
                  article: article,
                  );
                  }).toList(): [], //
                  );
                  }
                  /// handles others as you did on question
                  else {
                  return Align(
                  alignment: Alignment.center,
                  child: Center(
                  child: const  Text("لا توجد مقالات توافق هذا البحث. ",style: TextStyle(
                  color: Color(0xFFa80d14),
                  fontSize: 20.0,
                  ))
                  ));
                  }
                }),

              )
    );}

  }
