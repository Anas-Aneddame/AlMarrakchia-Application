import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/Article.dart';
import 'RetryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';
import '../models/Article.dart';
import '../services/sqflite.dart';
import '../services/parser.dart';



class ArticleScreen extends StatefulWidget {
  Article article;
  ArticleScreen({required this.article});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {


  late YoutubePlayerController _youtubePlayerController;
  void initState() {
    super.initState();
    initFavoriteButton();
    if(widget.article.image.contains("ytimg"))
    {
      final videoId = widget.article.image.split('vi/')[1].split('/0')[0];
    _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId, flags: YoutubePlayerFlags(autoPlay: false));
    }
  }

  Future<void> initFavoriteButton() async {
    bool result = await sqflite.isPostFavorite(widget.article.id);
    if(mounted)
    {
      setState(() {
      widget.article.isFavorite = result;
    });
    }

  }

  void _bookmarkToggleButton() {
    if(mounted)
    {
      setState(() {
      if (widget.article.isFavorite == true) {
        widget.article.isFavorite = false;
        sqflite.removeFavoriteArticle(widget.article);
      } else {
        widget.article.isFavorite = true;
        sqflite.insertFavoriteArticle(widget.article);
      }
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    Html htmlContent = Html(data: widget.article.content);
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: const Text('قراءة المقال',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 24)),
          ),
          backgroundColor: Color(0xffA80D14),
          // automaticallyImplyLeading: false,
          actions: <Widget>[
            !widget.article.image.contains("ytimg")?
            Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: IconButton(
                tooltip: 'Book mark Icon',
                onPressed: () => {
                  _bookmarkToggleButton(),
                },
                icon: widget.article.isFavorite
                    ? Icon(Icons.bookmark_outlined)
                    : Icon(Icons.bookmark_border),
              ),
            ):
            const SizedBox(
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Setting Icon',
                onPressed: () {
                  Share.share(widget.article.link);
                },
              ),
            ),
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                getImageOrVideo(),
                const SizedBox(height: 10.0),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Text(Parser.titleDecoder(widget.article.title),
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textDirection: TextDirection.rtl)),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                  padding : const EdgeInsets.only(right: 10.0),
                    child: Text(
                      Parser.getDate(widget.article.date),
                      textDirection: TextDirection.ltr,
                      // textDirection: TextDirection.ltr,
                      style: TextStyle(fontSize: 15.0, color: Colors.black54),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(Parser.getText(widget.article.content),
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 20.0, height: 1.7)),
                ),
              ],
            ),
          ),
        ));
  }

  getImageOrVideo() {
    if (widget.article.image != null &&
        widget.article.image.contains('i3.ytimg.com/vi')) {
      String videoId = widget.article.image.split('vi/')[1].split('/0')[0];
      return Padding(
        padding: const EdgeInsets.all(2),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: YoutubePlayer(
            controller: _youtubePlayerController,
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
    } else {
      return Image.network(
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset('assets/images/image_error.PNG',
              height: 250, width: double.infinity, fit: BoxFit.cover);
        },
        widget.article.image,
        // height: 250,
        // width: double.infinity,
        // fit: BoxFit.cover,
      );
    }
  }
}
