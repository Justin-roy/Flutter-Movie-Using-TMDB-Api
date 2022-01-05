import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_demo/Screen/Player%20Screen/Video_Player.dart';
import 'package:movie_demo/Screen/RelatedMovies_Screen.dart';
import 'package:movie_demo/TMDB%20API/ApiKey.dart';
import 'package:movie_demo/constraint.dart';

class TvShowVideosScreen extends StatefulWidget {
  const TvShowVideosScreen({
    Key? key,
    required this.videoKey,
    required this.imageUrl,
    required this.movieTitle,
    required this.movieDesp,
    required this.movieReleasedate,
    required this.vote,
    required this.popularity,
  }) : super(key: key);
  final String imageUrl,
      videoKey,
      movieTitle,
      movieDesp,
      movieReleasedate,
      vote,
      popularity;

  @override
  _TvShowVideosScreenState createState() => _TvShowVideosScreenState();
}

class _TvShowVideosScreenState extends State<TvShowVideosScreen> {
  List _trendingVideoKey = [];
  Future<String> loadDataFromTMDB() async {
    String api =
        'https://api.themoviedb.org/3/tv/${widget.videoKey}/videos?api_key=${KEY().apiKey}&language=en-US';

    var url = Uri.parse(api);
    var response = await http.get(url);
    var responseData;
    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    }
    Map catoData = responseData;
    setState(() {
      _trendingVideoKey = catoData['results'];
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              child: ClipRRect(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  imageUrl: widget.imageUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 120),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.play_circle_outline,
                          size: 85,
                          color: Colors.yellowAccent,
                        ),
                        Text(
                          widget.movieTitle.toUpperCase(),
                          style: Design().txt3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 210),
                      child: Text(
                        "OverView".toUpperCase(),
                        style: Design().txt,
                      ),
                    ),
                    movieOverview(widget.movieDesp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            movieOverview("Release Date"),
                            movieOverview(widget.movieReleasedate),
                          ],
                        ),
                        Column(
                          children: [
                            movieOverview("⭐ Average Rating"),
                            movieOverview(widget.vote),
                          ],
                        ),
                        Column(
                          children: [
                            movieOverview("Popularity"),
                            movieOverview(widget.popularity),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Trailers", style: Design().txt),
                  ),
                ),
                listOfTvShowTrailers(),
                Text(
                  "Related Tv Shows",
                  style: Design().txt,
                ),
                RelatedMoviesScreen(
                  movieId: int.parse(widget.videoKey),
                  checkScreen: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget listOfTvShowTrailers() {
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

  Padding movieOverview(String txt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        txt,
        style: Design().txt2,
      ),
    );
  }
}
