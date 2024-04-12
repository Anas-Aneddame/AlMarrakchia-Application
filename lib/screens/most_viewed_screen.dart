import 'package:flutter/material.dart';
import 'package:new_app/models/Article.dart';
import 'package:new_app/services/network_connectivity.dart';
import 'package:new_app/widgets/newsCard.dart';
import '../models/most_viewed.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'FavoritesScreen.dart';
import 'Home.dart';

class MostViewedScreen extends StatefulWidget {
  const MostViewedScreen({Key? key}) : super(key: key);

  @override
  State<MostViewedScreen> createState() => _MostViewedScreenState();
}

class _MostViewedScreenState extends State<MostViewedScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const Directionality(textDirection: TextDirection.rtl, child: Home()),
    const Directionality(
        textDirection: TextDirection.rtl, child: MostViewedScreen()),
    const Directionality(
        textDirection: TextDirection.rtl, child: FavoritesScreen())
  ];
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
      MaterialPageRoute(builder: (context) => _pages[_selectedIndex]),
    );
  }

  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;

  final ScrollController scrollController = ScrollController();
  late Future<List<Article>> mostViewedList;
  int page = 1;
  List<Article> mostViewedPosts = [];
  bool isReady = false;
  bool isOnline = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          if (_source.values.toList()[0]) {
            isOnline = true;
          }

          break;
        case ConnectivityResult.wifi:
          if (_source.values.toList()[0]) {
            isOnline = true;
          }
          break;
        case ConnectivityResult.none:
        default:
      }
      if (isOnline) {
        mostViewedPosts = [];
        scrollController.addListener(_scrollListner);
        getMostViewedPosts();
      } else {
        if(mounted)
        {
          setState(() {
          isReady = true;
        });
        }
      }
    });
  }

  void getMostViewedPosts() {
      MostViewed.getAllArticles(page,count:10).then((posts) {
        if(mounted)
        {
          setState(() {
          if (page == 1 || mostViewedPosts.isEmpty) {
            mostViewedPosts = posts;
          } else {
            mostViewedPosts.addAll(posts);
          }
          isReady = true;
          isLoading =false;
        });
        }
      });
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('الأكثر مشاهدة',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 28,
                  // fontFamily: 'Kufi',
                  color: Color(0xFFFFFFFF),
                )),
          ),
          backgroundColor: const Color(0xFFa80d14),
          elevation: 0,
        ),
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
              label: 'الأكثر مشاهدة',
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
          child: getListView(),
        ));
  }

  getListView() {
    if (isReady && isOnline) {
      return ListView.builder(
          controller: scrollController,
          itemCount: mostViewedPosts.length,
          itemBuilder: (context, index) {
            return NewsCard(article: mostViewedPosts[index]);
          });
    } else {
      if (!isReady) {
        return const CircularProgressIndicator(
          color: Color(0xFFa80d14),
        );
      } else {
        return getRetryScreen();
      }
    }
  }

  void _scrollListner() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent && !isLoading) {
      page++;
      isLoading=true;
      getMostViewedPosts();
    }
  }

  SizedBox getRetryScreen() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                "ليس هناك اتصال",
                style: TextStyle(
                  // color:Colors.grey,
                  fontSize: 20,
                  color: Color(0xFFa80d14),
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: MostViewedScreen())),
                )
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                  // Customize the text style of the button
                  fontSize: 20,
                  color: Color(0xFFa80d14),
                )),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFFa80d14), // Set the text color to white

                  // Customize the background color of the button
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(5.0, 2, 5, 2),
                child: Text("أعد المحاولة"),
              ),
            )
          ],
        ));
  }
}


