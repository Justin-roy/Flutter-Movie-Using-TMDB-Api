import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Player%20Screen/Widgets/MainPlayerScreen.dart';
import 'package:movie_demo/Widgets/constraint.dart';

class TopRatedMovies extends StatelessWidget {
  const TopRatedMovies({
    Key? key,
    required List trendingTopMovies,
    required this.txtDesign,
  })  : _topRatedMovies = trendingTopMovies,
        super(key: key);

  final List _topRatedMovies;
  final Design txtDesign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _topRatedMovies.length,
          itemBuilder: (contex, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contex) => TvShowScreen(
                      movieTitle:
                          _topRatedMovies[index]['original_title'] ?? 'Loading',
                      movieDesp: _topRatedMovies[index]['overview'],
                      movieReleasedate:
                          _topRatedMovies[index]['release_date'] ?? 'Loading',
                      imageUrl: "https://image.tmdb.org/t/p/w500" +
                          _topRatedMovies[index]['backdrop_path'],
                      vote: _topRatedMovies[index]['vote_average'].toString(),
                      movieId: _topRatedMovies[index]['id'],
                      popularity:
                          _topRatedMovies[index]['popularity'].toString(),
                      checkMovie: false,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CachedNetworkImage(
                        height: 200,
                        imageUrl: "https://image.tmdb.org/t/p/w500" +
                            _topRatedMovies[index]['poster_path'],
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Flexible(
                        child: Text(
                          _topRatedMovies[index]['original_title'] ?? "Loading",
                          style: txtDesign.txt2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
