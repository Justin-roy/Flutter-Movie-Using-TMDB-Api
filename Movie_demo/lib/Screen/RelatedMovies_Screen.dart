import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class RelatedMoviesScreen extends StatefulWidget {
  const RelatedMoviesScreen(
      {Key? key, required this.movieId, required this.checkScreen})
      : super(key: key);
  final int movieId;
  final bool checkScreen;
  @override
  _RelatedMoviesScreenState createState() => _RelatedMoviesScreenState();
}

class _RelatedMoviesScreenState extends State<RelatedMoviesScreen> {
  List _getRelatedMovies = [];
  final String apiKey = 'b5355a8799858cec5961be5fb29a5b5f';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNTM1NWE4Nzk5ODU4Y2VjNTk2MWJlNWZiMjlhNWI1ZiIsInN1YiI6IjYxYzZlN2U0ZjY1OTZmMDA1ZjEwYjdkOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._YorbiCojt_n7ZDC8jkKT0I6a7BPxchmcEACim3LxdA';

  Future<String> loadDataFromTMDB() async {
    final tmdbWithCustomLogs = TMDB(
      ApiKeys(
        apiKey,
        readAccessToken,
      ),
      logConfig: ConfigLogger(
        showLogs: true, //must be true than only all other logs will be shown
        showErrorLogs: true,
      ),
    );
    Map getRelatedMoviesResult;
    if (widget.checkScreen) {
      getRelatedMoviesResult =
          await tmdbWithCustomLogs.v3.movies.getSimilar(widget.movieId);
    } else {
      getRelatedMoviesResult =
          await tmdbWithCustomLogs.v3.tv.getSimilar(widget.movieId);
    }
    setState(() {
      _getRelatedMovies = getRelatedMoviesResult['results'];
    });
    print(_getRelatedMovies);
    return 'Done';
  }

  @override
  void initState() {
    loadDataFromTMDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _getRelatedMovies.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8),
              child: CachedNetworkImage(
                imageUrl: "https://image.tmdb.org/t/p/w500" +
                    _getRelatedMovies[index]['poster_path'],
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            );
          }),
    );
  }
}
