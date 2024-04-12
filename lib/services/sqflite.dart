import 'dart:convert';

import '../models/Article.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'parser.dart';
import 'package:html/parser.dart' as parser;



class sqflite{
  static Database? _database;
  
  Future<Database?> get database async{
    if(database==null){
      _database=initDB();
    }
      return database;
  }

  static initDB() async{
// Get a location using getDatabasesPath
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, 'articles.db');

    // Open the database
    final Database database = await openDatabase(path, version: 1, onCreate: (Database db,int version) async {
      // Lorsqu'on ouvert la base de donnees , on cree les tables ainsi que les categories et les tags existants
      createFavoritesTable();
      createCategoriesTable();
      createTagsTable();
    });
    return database;
  }

  static Future<List<Article>> getFavoriteArticles() async{
    Database? db=await initDB();
    List<Map<String, Object?>>? rows = await db?.query('favorite_articles');
    if (rows == null) return [];

    return List.generate(rows.length, (i) {

      int categorie = int.parse(rows[i]['categories'] as String);
      return Article(
        rows[i]['id'] as  int,
         rows[i]['title'] as String,
        rows[i]['content'] as String,
        rows[i]['image'] as String,
        rows[i]['date'] as String,
        rows[i]['link'] as String,
        categorie,
        rows[i]['tags'] as String,
      );
    });

  }


  static insertFavoriteArticle(Article article) async {
    Database? db = await initDB();
    var articleToInsert = {
      'id': article.id,
      'title': article.title,
      'image': Parser.getImage(article.content),
      'date': article.date.toString(),
      'content': article.content,
      'link': article.link,
      'categories': article.category.toString(),
      'tags': article.tags,
      'isFavorite': 1, // 1 represents true for the BOOLEAN favorite
    };
    await db?.insert('favorite_articles', articleToInsert);
    getFavoriteArticles();
  }
  static removeFavoriteArticle(Article article) async{
    Database? db=await initDB();
    await db?.delete('favorite_articles', where: 'id = ?', whereArgs: [article.id]);
    getFavoriteArticles();
  }
  static Future<bool> isPostFavorite(int id) async {
    final db = await initDB();
    final result = await db.rawQuery('SELECT * FROM favorite_articles WHERE id = ?', [id]);
    return result.isNotEmpty;
  }
  static Future<String> getCategory(int id) async{
    final db = await initDB();
    var result = await db.rawQuery('SELECT * FROM categories WHERE id = ?', [id]);
    // si la categorie n'existait pas , on l'ajoute
    if(result.isNotEmpty==true){
      // fetch le nom du nouveau tag et l'inserer dans la table des tags
      final response = await http.get(Uri.parse('https://www.almarrakchia.net/wp-json/wp/v2/categories/$id'));
      if(response.statusCode==200){
        final data = json.decode(response.body);
        var categoryToInsert = {
          'id': id,
          'name': data['name']};
        await db?.insert('tags', categoryToInsert);
        result = await db.rawQuery('SELECT * FROM categories WHERE id = ?', [id]);

      }
      else{
        return ' ';
      }

    }
    final category = result.first;
    return category['name'].toString();
  }
  static Future<String> getTag(int id) async{
    final db = await initDB();
    var result = await db.rawQuery('SELECT * FROM tags WHERE id = ?', [id]);
    // si le tag n'existait pas , on l'ajoute
    if(result.isNotEmpty==true){
      // fetch le nom du nouveau tag et l'inserer dans la table des tags
      final response = await http.get(Uri.parse('https://www.almarrakchia.net/wp-json/wp/v2/tags/$id'));
      if(response.statusCode==200){

        final data = json.decode(response.body);
      var tagToInsert = {
        'id': id,
        'name': data['name']};
      await db?.insert('tags', tagToInsert);
      result = await db.rawQuery('SELECT * FROM tags WHERE id = ?', [id]);}
      else{
        return '';
      }
    }
    final tag = result.first;
    return tag['name'].toString();

  }


  static createFavoritesTable() async{
    // Create the favorite_articles table if it does not exist
    final db = await initDB();
    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorite_articles(
        id INT PRIMARY KEY,
        title VARCHAR(255),
        image VARCHAR(255),
        date TEXT,
        content TEXT,
        link VARCHAR(255),
        categories VARCHAR(255),
        tags VARCHAR(255),
        isFavorite BOOLEAN
      )
    ''');
  }
  static createCategoriesTable() async{
    final db = await initDB();
    // Create the categories table if it does not exist
    await db.execute('''
        CREATE TABLE IF NOT EXISTS categories (
          id INTEGER PRIMARY KEY,
          name TEXT
    )
  ''');
    final initialCategories = [
      {'id':216,'name': 'أخبار'},
      {'id':1,'name': 'المراكشية تي في'},
      {'id':231,'name': 'تعليم ـ جامعة'},
      {'id':186,'name': 'ثقافة ـ أبحاث'},
      {'id':320,'name': 'خاص رمضان'},
      {'id':274,'name': 'رأي'},
      {'id':197,'name': 'رياضة'},
      {'id':120,'name': 'مراكش الذاكرة'},
      {'id':171,'name': 'منوعات'},
      {'id':288,'name': 'هنا وهناك'},
    ];
    var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM categories'));
    if (count == 0) {
      for (var category in initialCategories) {
        await db.insert('categories', category);
      };
    }
  }
  static createTagsTable() async{
    final db = await initDB();
  // Create the categories table if it does not exist
    await db.execute('''
          CREATE TABLE IF NOT EXISTS tags (
            id INTEGER PRIMARY KEY,
            name TEXT
      )
    ''');

    final initialTags = [
      {'id':297,'name': 'آسفي'},
      {'id':323,'name': 'التعليم'},
      {'id':299,'name': 'الثقافة'},
      {'id':324,'name': 'الجامعة'},
      {'id':317,'name': 'الحركة الوطنية'},
      {'id':322,'name': 'الحومات'},
      {'id':321,'name': 'الذاكرة'},
      {'id':301,'name': 'الرياضة'},
      {'id':325,'name': 'القرويين'},
    ];
    var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM tags'));
    if (count == 0) {
      for (var tag in initialTags) {
        await db.insert('tags', tag);
      }

    }}

  static clearTables(){}


}