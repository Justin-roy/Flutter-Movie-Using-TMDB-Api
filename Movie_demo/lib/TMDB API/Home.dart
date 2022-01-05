import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:movie_demo/Screen/Genres%20Screen/Genres_Screen.dart';
import 'package:movie_demo/Screen/Search%20Screen/MovieSearch_screen.dart';
import 'package:movie_demo/Screen/Search%20Screen/PeopleSearch_screen.dart';
import 'package:movie_demo/Screen/View_All.dart';
import 'package:movie_demo/TMDB%20API/ApiKey.dart';
import 'package:movie_demo/Widgets/PopularMovies.dart';
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
  List _getPopularMovies = [];
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
    Map movieResult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map tvResult = await tmdbWithCustomLogs.v3.tv.getPouplar();
    Map getPoularResult = await tmdbWithCustomLogs.v3.movies.getPouplar();
    Map topRatedResult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map getCatoResult = await tmdbWithCustomLogs.v3.geners.getMovieList();
    Map getUpcomingResult = await tmdbWithCustomLogs.v3.movies.getUpcoming();
    //Map getPeoleResult = await tmdbWithCustomLogs.v3.people.getDetails();
    setState(() {
      _trendingMovies = movieResult['results'];
      _trendingTvShows = tvResult['results'];
      _topRatedMovies = topRatedResult['results'];
      _genresList = getCatoResult['genres'];
      _getUpcomingMovies = getUpcomingResult['results'];
      _getPopularMovies = getPoularResult['results'];
    });
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
                  Row(
                    children: [
                      headerText("Popular Movies"),
                      const Spacer(),
                      viewAllText(
                        _getPopularMovies,
                        "Popular Movies",
                        false,
                      ),
                    ],
                  ),
                  PopularMovies(
                    popularMovies: _getPopularMovies,
                    txtDesign: txtDesign,
                  ),
                ],
              ),
            ),
            floatingActionButton: SpeedDial(
              backgroundColor: Colors.grey[900],
              icon: Icons.search,
              children: [
                SpeedDialChild(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contex) =>
                            const MovieSearchScreen(choice: 'Movies'),
                      ),
                    );
                  },
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(
                    Icons.live_tv_outlined,
                  ),
                ),
                SpeedDialChild(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contex) =>
                            const PeopleSearchScreen(choice: 'Actors'),
                      ),
                    );
                  },
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.people_outlined),
                ),
              ],
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
