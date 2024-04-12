import 'package:new_app/services/sqflite.dart';
import 'package:flutter/material.dart';
import '../models/Article.dart';
import '../widgets/newsCard.dart';
import '../screens/most_viewed_screen.dart';
import '../screens/Home.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    const Home(),
    const MostViewedScreen(),
    const Directionality(
        textDirection: TextDirection.rtl, child: FavoritesScreen())
  ];

  int _selectedIndex = 2;

/*   List<String> categoriesList = [
    'أخبار',
    'مراكش الذاكرة',
    'رياضة',
    'تعليم ـ جامعة',
    'المراكشية تي في',
    'منوعات'
  ]; */
  Future<List<Article>> favoriteArticles = sqflite.getFavoriteArticles();

  void _onItemTapped(int index) {
    if(mounted)
    {
      setState(() {
      _selectedIndex = index;
    });
    }
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Directionality(
              textDirection: TextDirection.rtl, child: _pages[_selectedIndex])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('المقالات المفضلة',
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 28.0,
              )),
          centerTitle: true,
          backgroundColor: const Color(0xFFa80d14),
          iconTheme: const IconThemeData(color: Color(0xFFa80d14)),
          elevation: 0,
        ),
        body: FutureBuilder<List<Article>?>(
            future: sqflite.getFavoriteArticles(),
            builder: (context, snapshot) {
              // if (snapshot.hasData &&
              //     snapshot.connectionState == ConnectionState.done) {
              //   List<Article>? favoriteArticles = snapshot.data;
              //   return ListView(
              //     children: favoriteArticles!.map((article) {
              //       return NewsCard(
              //         article: article,
              //       );
              //     }).toList(),
              //   );
              // }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Article>? favoriteArticles = snapshot.data;
                return ListView(
                  children: favoriteArticles!.map((article) {
                    return NewsCard(
                      article: article,
                    );
                  }).toList(),
                );
              }
              /// handles others as you did on question
              else {
                return  const Align(
                  alignment: Alignment.center,
                  child: Center(
                    child:  Text("لا توجد لديك مقالات مفضلة. ",style: TextStyle(
                    color: Color(0xFFa80d14),
              fontSize: 20.0,
              ))
                ));
              }
            }),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 18,
          unselectedFontSize: 16,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الأولى',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_circle_up),
              label: 'الاكثر مشاهدة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'المقالات المفضلة',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFa80d14),
          onTap: _onItemTapped,
        ));
  }
}
