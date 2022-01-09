import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Player%20Screen/Widgets/Trailer_ListScreen.dart';
import 'package:movie_demo/Screen/RelatedMovies_Screen.dart';
import 'package:movie_demo/Widgets/constraint.dart';

class TvShowScreen extends StatelessWidget {
  final String imageUrl,
      movieTitle,
      movieDesp,
      movieReleasedate,
      vote,
      popularity;
  final int movieId;
  final checkMovie;
  const TvShowScreen({
    Key? key,
    required this.imageUrl,
    required this.movieTitle,
    required this.movieDesp,
    required this.movieReleasedate,
    required this.vote,
    required this.popularity,
    required this.movieId,
    this.checkMovie = true,
  }) : super(key: key);

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
                  imageUrl: imageUrl,
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
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.play_circle_outline,
                            size: 85,
                            color: Colors.yellowAccent,
                          ),
                        ),
                        Text(
                          movieTitle.toUpperCase(),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Casts", style: Design().txt),
                  ),
                ),
                TrailerListScreen(
                  videoKey: movieId.toString(),
                  chooseOptions: false,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Trailers", style: Design().txt),
                  ),
                ),
                TrailerListScreen(
                  videoKey: movieId.toString(),
                ),
                checkMovie
                    ? Text(
                        "Related Tv Shows",
                        style: Design().txt,
                      )
                    : Text(
                        "Related Movies",
                        style: Design().txt,
                      ),
                checkMovie
                    ? RelatedMoviesScreen(
                        movieId: movieId,
                        checkScreen: false,
                      )
                    : RelatedMoviesScreen(
                        movieId: movieId,
                        checkScreen: true,
                      ),
              ],
            ),
          ],
        ),
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
