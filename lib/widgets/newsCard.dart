// import 'dart:js';

import 'package:html_unescape/html_unescape.dart';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/Article.dart';
import '../screens/ArticleScreen.dart';
import '../services/parser.dart';

class NewsCard extends StatelessWidget {
  late Article article;
  static final videoUrl = "https://www.youtube.com/watch?v=GQyWIur03aw";

  final videoId = YoutubePlayer.convertUrlToId(videoUrl);

  late YoutubePlayerController _youtubePlayerController =
      YoutubePlayerController(
          initialVideoId: videoId!, flags: YoutubePlayerFlags(autoPlay: false));

  NewsCard({super.key, required this.article});
  void selectNews() {}
  @override
  void init() {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId!, flags: YoutubePlayerFlags(autoPlay: false));
  }

  @override
  Widget build(BuildContext context) {
    if (article.image != null && article.image.contains('youtube.com')) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(article.image)!,
              flags: YoutubePlayerFlags(autoPlay: false),
            ),
            showVideoProgressIndicator: true,
            progressIndicatorColor:
                Colors.red, // Customize the color of the progress indicator
            progressColors: ProgressBarColors(
              playedColor:
                  Colors.red, // Customize the color of the progress bar
              handleColor:
                  Colors.red, // Customize the color of the progress bar handle
            ),
            controlsTimeOut: const Duration(
                seconds: 3), // Customize the timeout for hiding controls
            aspectRatio: 16 / 9, // Set the aspect ratio of the video player
          ),
        ),
      );
      // Text(
      // article.title,  // Replace with the actual video title
      // style: TextStyle(
      // fontSize: 18,
      // fontWeight: FontWeight.bold,
      // )
      // // Add any additional widgets below the title if needed
      // )
    } else {
      return InkWell(
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 7,
          margin: const EdgeInsets.all(7),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: Image.network(
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset('assets/images/image_error.png',
                        height: 250, width: double.infinity, fit: BoxFit.cover);
                  },
                  article.image,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: Alignment.bottomRight,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(1),
                        ],
                        stops: const [
                          0.4,
                          1
                        ]),
                  ),
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Text(
                            Parser.titleDecoder(article.title),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            Parser.getDate(article.date),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          )
                        ]),
                  )),
              FittedBox(
                child: Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.all(7),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: const Color(0xFFa80d14).withOpacity(0.8),
                  child: Text(
                    textDirection: TextDirection.rtl,
                    Article.categoriesList[article.category] ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
