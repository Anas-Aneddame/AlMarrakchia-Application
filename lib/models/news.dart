import 'dart:convert';
import 'package:http/http.dart' as http;

class News {
  Future<List> getAllNews(int page) async {
    String url = "https://www.almarrakchia.net/wp-json/wp/v2/posts?page=$page";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return Future.error("sever error");
    }
  }

  Future<Map<int, String>> fetchCategories() async {
    final response = await http.get(
        Uri.parse('https://www.almarrakchia.net/wp-json/wp/v2/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> categoriesJson = jsonDecode(response.body);
      final Map<int, String> categories = {};

      for (final categoryJson in categoriesJson) {
        final int id = categoryJson['id'];
        final String name = categoryJson['name'];
        categories[id] = name;
      }
      return categories;
    } else {
      throw Exception('Failed to fetch categories from WordPress API');
    }
  }
}
