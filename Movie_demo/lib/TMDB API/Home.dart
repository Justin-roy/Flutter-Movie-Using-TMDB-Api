import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Genres_Screen.dart';
import 'package:movie_demo/Screen/View_All.dart';
import 'package:movie_demo/Widgets/TopRatedMovies.dart';
import 'package:movie_demo/Widgets/TrendingMovies.dart';
import 'package:movie_demo/Widgets/TrendingTvShows.dart';
import 'package:movie_demo/Widgets/UpcomingMovies.dart';
import 'package:movie_demo/constraint.dart';
import 'package:tmdb_api/tmdb_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Design txtDesign = Design();
  bool _waitForData = true;
  List _trendingMovies = [];
  List _trendingTvShows = [];
  List _topRatedMovies = [];
  List _genresList = [];
  List _getUpcomingMovies = [];
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
    Map movieResult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map tvResult = await tmdbWithCustomLogs.v3.tv.getPouplar();
    Map topRatedResult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map getCatoResult = await tmdbWithCustomLogs.v3.geners.getMovieList();
    Map getUpcomingResult = await tmdbWithCustomLogs.v3.movies.getUpcoming();
    setState(() {
      _trendingMovies = movieResult['results'];
      _trendingTvShows = tvResult['results'];
      _topRatedMovies = topRatedResult['results'];
      _genresList = getCatoResult['genres'];
      _getUpcomingMovies = getUpcomingResult['results'];
    });
    print(_trendingTvShows);
    return 'Done';
  }

  @override
  void initState() {
    _callInit();
    super.initState();
  }

  _callInit() async {
    await loadDataFromTMDB();
    setState(() {
      _waitForData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _waitForData
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: const Icon(
                Icons.menu,
                color: Colors.black45,
              ),
              title: Text(
                "Flutter Movie".toUpperCase(),
                style: txtDesign.txt,
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('images/minion.png'),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      headerText("Upcoming Movies"),
                      const Spacer(),
                      viewAllText(
                        _getUpcomingMovies,
                        "Upcoming Movies",
                        true,
                      ),
                    ],
                  ),
                  UpComingMovies(
                    trendingTv: _getUpcomingMovies,
                    txtDesign: txtDesign,
                  ),
                  headerText("Genres"),
                  GenresScreen(movieCato: _genresList),
                  Row(
                    children: [
                      headerText("Tv Shows"),
                      const Spacer(),
                      viewAllText(
                        _trendingTvShows,
                        "Tv Shows",
                        true,
                      ),
                    ],
                  ),
                  TrendingTvShow(
                    trendingTv: _trendingTvShows,
                    txtDesign: txtDesign,
                  ),
                  Row(
                    children: [
                      headerText("Trending Movies"),
                      const Spacer(),
                      viewAllText(
                        _trendingMovies,
                        "Trending Movies",
                        false,
                      ),
                    ],
                  ),
                  TrendingMovieUI(
                    trendingMovies: _trendingMovies,
                    txtDesign: txtDesign,
                  ),
                  Row(
                    children: [
                      headerText("Top Rated Movies"),
                      const Spacer(),
                      viewAllText(
                        _topRatedMovies,
                        "Top Rated Movies",
                        false,
                      ),
                    ],
                  ),
                  TopRatedMovies(
                    trendingTopMovies: _topRatedMovies,
                    txtDesign: txtDesign,
                  ),
                ],
              ),
            ),
          );
  }

  Widget viewAllText(var trending, String appbarName, bool _checkScreen) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewAllScreen(
                txtDesign: txtDesign,
                trendingMovies: trending,
                appbarTitleName: appbarName,
                checkPage: _checkScreen,
              ),
            ),
          );
        },
        child: const Text(
          "View All",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget headerText(String txt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        txt,
        style: txtDesign.txt,
      ),
    );
  }
}
