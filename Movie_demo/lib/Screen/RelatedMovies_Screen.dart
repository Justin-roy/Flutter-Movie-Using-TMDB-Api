import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Player%20Screen/MainPlayerScreen.dart';
import 'package:movie_demo/TMDB%20API/ApiKey.dart';
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
    Map getRelatedMoviesResult;
    if (widget.checkScreen) {
      getRelatedMoviesResult =
          await tmdbWithCustomLogs.v3.movies.getSimilar(widget.movieId);
    } else {
      getRelatedMoviesResult =
          await tmdbWithCustomLogs.v3.tv.getSimilar(widget.movieId);
    }
    setState(() {
      _getRelatedMovies =
          getRelatedMoviesResult['results'] ?? getRelatedMoviesResult as List;
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
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TvShowScreen(
                      imageUrl: "https://image.tmdb.org/t/p/w500" +
                          _getRelatedMovies[index]['backdrop_path'],
                      movieTitle: _getRelatedMovies[index]['original_title'],
                      movieDesp: _getRelatedMovies[index]['overview'],
                      movieReleasedate: _getRelatedMovies[index]
                          ['release_date'],
                      vote: _getRelatedMovies[index]['vote_average'].toString(),
                      popularity:
                          _getRelatedMovies[index]['vote_count'].toString(),
                      movieId: _getRelatedMovies[index]['id'],
                      checkMovie: false,
                    ),
                  ),
                );
              },
              child: Container(
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
              ),
            );
          }),
    );
  }
}
