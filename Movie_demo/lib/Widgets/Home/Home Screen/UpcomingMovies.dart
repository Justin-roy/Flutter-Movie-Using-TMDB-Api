import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Player%20Screen/Widgets/MainPlayerScreen.dart';
import 'package:movie_demo/Widgets/constraint.dart';

class UpComingMovies extends StatelessWidget {
  const UpComingMovies({
    Key? key,
    required List trendingTv,
    required this.txtDesign,
  })  : _trendingTvShows = trendingTv,
        super(key: key);

  final List _trendingTvShows;
  final Design txtDesign;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: _trendingTvShows.length,
      itemBuilder: (context, index, realIndex) {
        final img = _trendingTvShows[index]['backdrop_path'] != null
            ? "https://image.tmdb.org/t/p/w500" +
                _trendingTvShows[index]['backdrop_path']
            : 'https://image.tmdb.org/t/p/w500/xBaeUYKNJfX8VhIFvvgPpFSYxBZ.jpg';
        final String title =
            _trendingTvShows[index]['original_title'] ?? "Loading";
        final String moviedesp = _trendingTvShows[index]['overview'];
        final String releasedate =
            _trendingTvShows[index]['release_date'] ?? 'Loading';
        final String vote = _trendingTvShows[index]['vote_average'].toString();
        final String popularity =
            _trendingTvShows[index]['popularity'].toString();
        final int movieId = _trendingTvShows[index]['id'];
        return buildImage(img, title, moviedesp, releasedate, vote, popularity,
            movieId, context);
      },
      options: CarouselOptions(
        autoPlay: true,
        enableInfiniteScroll: true,
        viewportFraction: 0.9,
      ),
    );
  }
}

Widget buildImage(
  String img,
  String txt,
  String moviedesp,
  String releasedate,
  String vote,
  String popularity,
  int movieId,
  BuildContext context,
) =>
    Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contex) => TvShowScreen(
                      imageUrl: img,
                      movieTitle: txt,
                      movieDesp: moviedesp,
                      movieReleasedate: releasedate,
                      vote: vote,
                      popularity: popularity,
                      movieId: movieId,
                      checkMovie: false,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: img,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 15,
            left: 15,
          ),
          child: Text(
            txt,
            style: Design().txt3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
