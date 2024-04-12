import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_app/screens/RetryScreen.dart';
import '../models/NewsCache.dart';
import '../services/search.dart';
import '../widgets/newsCard.dart';
import '../screens/FavoritesScreen.dart';
import '../screens/most_viewed_screen.dart';

import 'package:new_app/models/Article.dart';
import 'package:new_app/screens/adhan_view.dart';
import 'package:new_app/models/menu_content.dart';
import 'package:new_app/screens/weather_view.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int page = 1;

  late List<Article> articles;

  static int currentTabIndex = 0;

  late final TabController _tabController;

  final ScrollController _scrollController = ScrollController();

  static Map<int, int> indexMappingList = categoriesList.keys.toList().asMap();

  late Future<List<Article>> loadPosts;

  bool loading = false;

  static List<Article> _posts = [];

  int _selectedIndex = 0;

  final _newsCache = NewsCache();

  final _page = NewsPage();

  static Map<int, String> categoriesList = {
    0: 'الرئيسية',
    216: 'أخبار',
    171: 'منوعات',
    197: 'رياضة',
    1: 'المراكشية تي في',
    231: 'تعليم ـ جامعة',
    120: 'مراكش الذاكرة',
    186: 'ثقافة ـ أبحاث',
  };
  double tileHeight = 60.0;

  Color mainColor = const Color(0xFFB12E2E);
  Color white = Colors.white;

  final List<MenuContent> menuContentList = [
    MenuContent('الأقسام',true),
    MenuContent.withIcon(' الرئيسية',Icons.newspaper),
    MenuContent.withIcon('اخبار',Icons.newspaper),
    MenuContent.withIcon('منوعات',Icons.shuffle),
    MenuContent.withIcon('رياضة',Icons.sports_soccer),
    MenuContent.withIcon('المراكشية تي في',Icons.tv),
    MenuContent.withIcon('تعليم ـ جامعة',Icons.school),
    MenuContent.withIcon('مراكش الذاكرة',FontAwesomeIcons.city),
    MenuContent.withIcon(  'ثقافة ـ أبحاث',FontAwesomeIcons.book),
    MenuContent('خدمات', true),
    MenuContent.withIcon('اوقات الصلاة',Icons.mosque),
    MenuContent.withIcon('الطقس',FontAwesomeIcons.cloudRain),
    MenuContent('شبكات التواصل الاجتماعي',true),
    MenuContent.withLink('فيسبوك',Icons.facebook, true,'https://m.facebook.com/almarrakchia.net'),
    MenuContent.withLink('الانستغرام',FontAwesomeIcons.instagram,true, 'https://www.instagram.com/almarrakchiajournal/'),
    MenuContent.withLink('تويتر',FontAwesomeIcons.twitter,true, 'https://twitter.com/almarrakchianet'),
    MenuContent.withLink('يوتيوب',FontAwesomeIcons.youtube,true, 'https://www.youtube.com/channel/UC2QxzgDoIohBIhst1LlKDwg'),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: categoriesList.length, vsync: this);
/*     _tabController.addListener();
 */
    loadPosts = _loadPosts(indexMappingList[currentTabIndex]!);

/*     _handleTabSelection();
 */
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (loading == false) {
          page++;
          addNews(indexMappingList[currentTabIndex]!)
              .then((value) => _loadPosts(indexMappingList[currentTabIndex]!));
          loading = true;
        }
        /*   addNews(indexMappingList[currentTabIndex]!)
              .then((value) => _handleTabSelection());
          loading = true;
        } */
      }
    });
  }

  Future<List<Article>> _loadPosts(int categoryId) async {
    List<Article> posts = [];
    if (_newsCache.getNews(categoryId) != null) {
      posts = _newsCache.getNews(categoryId)!;
    } else {
      posts = await Article.getAllNews(categoryId, 1);
      _newsCache.addNews(categoryId, posts);
      _page.addPage(categoryId, 1);
    }

    if(mounted)
    {
          setState(() {

      loading = false;
    });
    }


    return posts;
  }

  void _handleTabSelection() {
    if (_page.getPage(indexMappingList[currentTabIndex]!) == null) {
      _page.addPage(indexMappingList[currentTabIndex]!);
    }

    page = _page.getPage(indexMappingList[currentTabIndex]!)!;


    loadPosts = _loadPosts(indexMappingList[currentTabIndex]!);
  }

  Future<void> addNews(int categoryId) async {
    List<Article> posts = [];

    posts = await Article.getAllNews(categoryId, page);
    _page.addPage(categoryId, page);
    _newsCache.addNews(categoryId, posts);
  }

  void _onItemTapped(int index) {
    if(mounted){
          setState(() {
      _selectedIndex = index;
    });
    }
    if(_selectedIndex!=0)
    {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages[_selectedIndex]),
      );
    }

  }

  final List<Widget> _pages = [
    const Directionality(textDirection: TextDirection.rtl, child: Home()),
    const Directionality(textDirection: TextDirection.rtl,child:  MostViewedScreen()),
    const Directionality(
        textDirection: TextDirection.rtl, child: FavoritesScreen())
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: categoriesList.values.length,
        child: Scaffold(
            drawer: Directionality(
              textDirection: TextDirection.ltr,

                child: Drawer(
                  backgroundColor:white,
                  child: SizedBox(
                    height: tileHeight,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0.0),
                        itemCount: menuContentList.length,
                        itemBuilder: (context, index) {
                          MenuContent element = menuContentList[index];
                          return !element.isTitle?
                          ListTile(
                            tileColor: element.isSelected? mainColor:white,
                            trailing:Icon(element.icon),
                            iconColor : element.isSelected? white:mainColor,
                            title: Text(
                              element.content,
                              style: TextStyle(
                                color:element.isSelected? white:mainColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            onTap: () {
                              element.hasLink ? _launchUrl(Uri.parse(element.link)):null;
                              if(mounted)
                              {
                              setState((){
                                Navigator.pop(context);
                                if(element.content=='الطقس')
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const  WeatherPage()));
                                }
                                else if(element.content=='اوقات الصلاة')
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const  AdhanPage()));
                                }
                                else{
                                  // Si on clique sur un boutton de catégorie,les articles de celle-ci vont etre rechargés
                                  int itemIndex = index-1;
                                  if(itemIndex!=_tabController.index && !element.hasLink )
                                  {
                                    setState(() {
                                      currentTabIndex = itemIndex;
                                    });
                                    _tabController.animateTo(itemIndex);
                                    _handleTabSelection();
                                  }
                                }
                              }
                              );
                              }
                            },
                          ):
                          Container(
                              decoration:const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(color: Color.fromARGB(255, 225, 217, 217)))),
                              child: ListTile(
                                  tileColor: white,
                                  title:Text(
                                    element.content,
                                    style:
                                    const TextStyle(
                                      color:Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,

                                  )));
                        }
                    ),
                  ),

                ),
              ),
            appBar:PreferredSize(
    preferredSize: const Size.fromHeight(100),child: Directionality(
    textDirection: TextDirection.ltr, // Set the desired text direction (RTL)
    child: AppBar(
              title: const Text('المراكشية',
                  style: TextStyle(
                    color: Color(0xFFa80d14),
                    fontSize: 30.0,
                  )),
              centerTitle: true,
              backgroundColor: const Color(0xFFFFFFFF),
              iconTheme: const IconThemeData(color: Color(0xFFa80d14)),
              elevation: 0,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: Directionality(
                    
                    textDirection: TextDirection.rtl,
                    child: TabBar(
                        isScrollable: true,
                        labelColor: const Color(0xFFa80d14),
                        unselectedLabelColor: Colors.black,
                        indicatorColor: const Color(0xFFa80d14),
                        controller: _tabController,
                        onTap: (index) {
                          if (index != currentTabIndex) {
                            if(mounted)
                            {
                              setState(() {
                              currentTabIndex = index;
                            });
                            }
                            _handleTabSelection();
                          }
                        },
                        tabs: categoriesList.values
                            .toList()
                            .map((category) => Tab(
                          child: Text(category,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ))
                            .toList()),
                  )),
              actions: [
                
                IconButton(
                  onPressed: () {

                    showSearch(

                        context: context,

                        delegate: CustomSearchDelegate()
                    );                    },
                  icon: const Icon(Icons.search),
                  iconSize: 35,
                  color: const Color(0xFFa80d14),
                )
              ],
            )) ),
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
            ),
            body: Center(
              child: FutureBuilder<List<Article>>(
                future: loadPosts,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Article>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Afficher un indicateur de chargement pendant que la Future est en attente
                    return const CircularProgressIndicator(
                      color: Color(0xFFa80d14),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Afficher les données une fois que la Future est résolue
                    List<Article>? articles = snapshot.data;
                    return ListView(
                      controller: _scrollController,
                      children: articles!.map((article) {
                        return NewsCard(
                          article: article,
                        );
                      }).toList(),
                    );
                  }
                  else{
                    return RetryScreen();
                  }
                },
              ),
            )));
  }
  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

}