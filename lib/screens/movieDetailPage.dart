import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/Models/Movie.dart';
import 'package:movies_app/Models/MovieVideoSrc.dart';
import 'package:movies_app/utils/CustomizedEventEmitter.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatefulWidget {
  static final String SCREEN_ROUTE = "movieDetailScreen";
  MovieDetailScreen({Key? key}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final pubsub = CustomEventEmitter();

  var screenMovie = null;
  MovieVideoSrc? movieVideoSrcObj;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    if (screenMovie == null && movieVideoSrcObj == null) {
      screenMovie = (ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>)["currentMovie"] as Movie;
      movieVideoSrcObj = (ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>)["movieVideoSrc"] as MovieVideoSrc;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/original/${screenMovie.backdrop_path}',
                  height: deviceHeight,
                  width: deviceWidth,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Center(
                      child: Container(
                        height: 20,
                        width: 20,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: deviceHeight,
                width: deviceWidth,
                color: Colors.black.withOpacity(0.5),
              ),
              Container(
                height: deviceHeight,
                child: Center(
                  child: Container(
                    width: deviceWidth * 0.3,
                    height: deviceWidth * 0.3,
                    // color: Colors.black.withOpacity(0.4),
                    child: LayoutBuilder(
                      builder: ((context, constraints) {
                        return Container(
                          width: constraints.maxWidth * 0.3,
                          height: constraints.maxWidth * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.yellow, width: 7),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              if (await canLaunchUrl(Uri.parse(
                                  "https://www.youtube.com/watch?v=${movieVideoSrcObj!.key}")))
                                ;

                              await launchUrl(Uri.parse(
                                  "https://www.youtube.com/watch?v=${movieVideoSrcObj!.key}"));
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.yellow,
                              size: 60,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
