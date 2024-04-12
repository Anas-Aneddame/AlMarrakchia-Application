import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:new_app/models/Article.dart';

class MostViewed {
  String? link;
  String? title;
  String? date;

  static Future<List<MostViewed>> getMostViewed(int page,
      {int count = 5}) async {
    String url = "https://www.almarrakchia.net/wp-admin/admin-ajax.php";
    String body =
        "action=magone_article_box_pagination&atts%5Btitle%5D=%D8%A7%D9%84%D9%85%D9%82%D8%A7%D9%84%D8%A7%D8%AA+%D8%A7%D9%84%D8%A3%D9%83%D8%AB%D8%B1+%D9%82%D8%B1%D8%A7%D8%A1%D8%A9&atts%5Btitle_url%5D=&atts%5Btitle_url%5D=&atts%5Bcount%5D=$count&atts%5Borderby%5D=popular&atts%5Bshow_date%5D=pretty&atts%5Bpagination%5D=loadmo&atts%5Bduration%5D=week&atts%5Bmax_num_pages%5D=10&type=list&paged=$page";
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      var document = parse(response.body);
      List<MostViewed> mostViewedList = [];
      // tdElement = div
      document.getElementsByClassName('td').forEach((tdElement) {
        if (tdElement.className == 'td') {
          MostViewed mostViewed = MostViewed();
          // titleElement = h3
          tdElement
              .getElementsByClassName('item-title')
              .forEach((titleElement) {
            for (var titleChild in titleElement.children) {
              if (titleChild.className != 'meta-item meta-item-author') {
                // set Link
                mostViewed.link =
                    "https://www.almarrakchia.net/wp-json/wp/v2/posts?slug=${titleChild.attributes['href']!.split('.net/')[1].split('/')[0]}";
                // set Title
                mostViewed.title = titleChild.firstChild!.text;
              }
            }
          });
          // set Date
          mostViewed.date = tdElement
              .getElementsByClassName('meta-item meta-item-date')
              .first
              .getElementsByTagName('span')
              .first
              .text;
          mostViewedList.add(mostViewed);
        }
      });
      return mostViewedList;
    } else {
      return Future.error("Server error");
    }
  }

  Future<void> getArticle() async {
    String? url = this.link;
    var response = await http.get(Uri.parse(url!));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      Article article = Article.fromJson(data.first,false);
    } else {
      return Future.error("sever error");
    }
  }

  static Future<String> getArticlesUrl(int page, {int count = 10}) async {
    String globalUrl = "https://www.almarrakchia.net/wp-json/wp/v2/posts?slug=";
    String url = "https://www.almarrakchia.net/wp-admin/admin-ajax.php";
    String body =
        "action=magone_article_box_pagination&atts%5Btitle%5D=%D8%A7%D9%84%D9%85%D9%82%D8%A7%D9%84%D8%A7%D8%AA+%D8%A7%D9%84%D8%A3%D9%83%D8%AB%D8%B1+%D9%82%D8%B1%D8%A7%D8%A1%D8%A9&atts%5Btitle_url%5D=&atts%5Btitle_url%5D=&atts%5Bcount%5D=$count&atts%5Borderby%5D=popular&atts%5Bshow_date%5D=pretty&atts%5Bpagination%5D=loadmo&atts%5Bduration%5D=week&atts%5Bmax_num_pages%5D=10&type=list&paged=$page";
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      var document = parse(response.body);
      int i = 0;
      // tdElement = div
      document.getElementsByClassName('td item-readmore').forEach((tdElement) {
        // titleElement = h3

        globalUrl =
            '$globalUrl,${tdElement.getElementsByTagName('a').first.attributes['href']!.split('.net/')[1].split('/#more')[0]}';

        // set Date
      });
      globalUrl = '$globalUrl&orderby=include_slugs&order=asc';
      return globalUrl;
    } else {
      return Future.error("Server error");
    }
  }

  static Future<List<Article>> getAllArticles(int page, {int count = 10}) async  {
    String url = await getArticlesUrl(page,count: count);

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Article> posts =
      data.map((article) => Article.fromJson(article,false)).toList();
      return posts;
    } else {
      return Future.error("sever error");
    }
  }
  static Future<List<Article>> appendElements(Future<List<Article>> listFuture, List<Article> elementsToAdd) async {
  final list = await listFuture;
  list.addAll(elementsToAdd);
  return list;
}
}