import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/RelatedMovies_Screen.dart';
import 'package:movie_demo/constraint.dart';

import 'Video_Player.dart';

class MovieDescription extends StatelessWidget {
  final String movieName,
      movieDesp,
      movieReleasedate,
      movieBanner,
      moviePoster,
      vote,
      popularity,
      videoKEy;

  const MovieDescription({
    Key? key,
    required this.movieName,
    required this.movieDesp,
    required this.movieReleasedate,
    required this.movieBanner,
    required this.moviePoster,
    required this.vote,
    required this.popularity,
    required this.videoKEy,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              VideoPlayer(
                movieBanner: movieBanner,
                videoKey: videoKEy,
              ),
              const SizedBox(height: 20),
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
                  movieOverview(movieDesp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          movieOverview("Release Date"),
                          movieOverview(movieReleasedate),
                        ],
                      ),
                      Column(
                        children: [
                          movieOverview("⭐ Average Rating"),
                          movieOverview(vote),
                        ],
                      ),
                      Column(
                        children: [
                          movieOverview("Popularity"),
                          movieOverview(popularity),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Text(
                "Related Movies",
                style: Design().txt,
              ),
              RelatedMoviesScreen(
                movieId: int.parse(videoKEy),
                checkScreen: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding descriptionsTXT(String txt, bool isCheck) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        txt,
        style: isCheck ? Design().txt2 : Design().txt,
      ),
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
