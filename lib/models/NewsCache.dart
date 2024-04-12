import 'package:new_app/models/Article.dart';

class CategoryNews {
  final int category;
  final List<Article> newsList;

  CategoryNews({required this.category, required this.newsList});
}

class NewsCache {
  final _categoryNewsMap = <int, CategoryNews>{};

  void addNews(int categoryid, List<Article> newsList) {
    if (_categoryNewsMap[categoryid]?.newsList == null) {
      _categoryNewsMap[categoryid] =
          CategoryNews(category: categoryid, newsList: newsList);
    } else {
      _categoryNewsMap[categoryid]?.newsList.addAll(
          CategoryNews(category: categoryid, newsList: newsList).newsList);
    }
  }

  List<Article>? getNews(int categoryid) {
    if (_categoryNewsMap.containsKey(categoryid)) {
      return _categoryNewsMap[categoryid]?.newsList;
    }
    return null;
  }
}

class NewsPage {
  final _categoryPageMap = <int, int>{};

  void addPage(int categoryId, [int page = 1]) {
    _categoryPageMap[categoryId] = page;
  }

  int? getPage(int categoryId) {
    return _categoryPageMap[categoryId];
  }
}
