import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Player%20Screen/Widgets/MainPlayerScreen.dart';

class GenericListOfData extends StatelessWidget {
  const GenericListOfData({Key? key, required this.catData}) : super(key: key);
  final List catData;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: catData.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TvShowScreen(
                    imageUrl: "https://image.tmdb.org/t/p/w500" +
                        catData[index]['backdrop_path'],
                    movieTitle: catData[index]['original_title'],
                    movieDesp: catData[index]['overview'],
                    movieReleasedate: catData[index]['release_date'],
                    vote: catData[index]['vote_average'].toString(),
                    popularity: catData[index]['vote_count'].toString(),
                    movieId: catData[index]['id'],
                    checkMovie: false,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.all(5),
              child: CachedNetworkImage(
                imageUrl: "https://image.tmdb.org/t/p/w500" +
                    catData[index]['poster_path'],
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    );
  }
}
