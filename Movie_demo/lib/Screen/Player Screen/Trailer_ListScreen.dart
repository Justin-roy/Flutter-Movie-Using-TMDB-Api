import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/TMDB%20API/ApiKey.dart';
import 'package:movie_demo/constraint.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'Video_Player.dart';

class TrailerListScreen extends StatefulWidget {
  const TrailerListScreen({
    Key? key,
    required this.videoKey,
  }) : super(key: key);
  final String videoKey;
  @override
  _TrailerListScreenState createState() => _TrailerListScreenState();
}

class _TrailerListScreenState extends State<TrailerListScreen> {
  List _trendingVideoKey = [];
  Future<String> loadDataFromTMDB() async {
    final tmdbWithCustomLogs = TMDB(
      ApiKeys(
        KEY().apiKey,
        KEY().readAccessToken,
      ),
      logConfig: ConfigLogger(
        showLogs: true, //must be true than only all other logs will be shown
        showErrorLogs: true,
      ),
    );
    Map trendinglistVideos = await tmdbWithCustomLogs.v3.movies
        .getVideos(int.parse(widget.videoKey));
    setState(() {
      _trendingVideoKey = trendinglistVideos['results'];
    });
    return 'Done';
  }

  _callInit() async {
    await loadDataFromTMDB();
  }

  @override
  void initState() {
    _callInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _trendingVideoKey.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(5),
              width: 120,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (contex) => VideoPlayer(
                        videoKey: _trendingVideoKey[index]['key'],
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://img.youtube.com/vi/${_trendingVideoKey[index]['key']}/0.jpg',
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                      )),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Text(
                      _trendingVideoKey[index]['type'],
                      style: Design().txt5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
