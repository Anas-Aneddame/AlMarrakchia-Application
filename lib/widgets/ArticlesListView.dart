import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Article.dart';
import '../screens/ArticleScreen.dart';

class   ArticlesListView extends StatelessWidget {

  final List<Article> articles;
  const ArticlesListView( {Key? key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (BuildContext context, int index) {
              final article = articles[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleScreen(
                       article: article,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.asset('assets/${article.image}'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(article.title),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
  }

