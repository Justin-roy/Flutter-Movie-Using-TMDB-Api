import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Player%20Screen/MainPlayerScreen.dart';

import '../constraint.dart';

class ViewAllScreen extends StatelessWidget {
  const ViewAllScreen({
    Key? key,
    required this.txtDesign,
    required this.trendingMovies,
    required this.appbarTitleName,
    required this.checkPage,
  }) : super(key: key);
  final List trendingMovies;
  final Design txtDesign;
  final String appbarTitleName;
  final bool checkPage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          appbarTitleName.toUpperCase(),
          style: txtDesign.txt,
        ),
      ),
      body: ListView.builder(
          itemCount: trendingMovies.length,
          itemBuilder: (contex, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (contex) => TvShowScreen(
                            imageUrl: "https://image.tmdb.org/t/p/w500" +
                                trendingMovies[index]['backdrop_path'],
                            movieTitle: trendingMovies[index]
                                    ['original_title'] ??
                                trendingMovies[index]['original_name'],
                            movieDesp: trendingMovies[index]['overview'],
                            movieReleasedate: trendingMovies[index]
                                    ['release_date'] ??
                                trendingMovies[index]['first_air_date'],
                            vote: trendingMovies[index]['vote_average']
                                .toString(),
                            popularity:
                                trendingMovies[index]['popularity'].toString(),
                            movieId: trendingMovies[index]['id'],
                          )),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CachedNetworkImage(
                        height: 200,
                        imageUrl: "https://image.tmdb.org/t/p/w500" +
                            trendingMovies[index]['poster_path'],
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  trendingMovies[index]['original_title'] ??
                                      trendingMovies[index]['original_name'],
                                  style: txtDesign.txt4,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Release Date: ",
                                    style: txtDesign.txt2,
                                  ),
                                  Text(
                                    trendingMovies[index]['release_date'] ??
                                        trendingMovies[index]['first_air_date'],
                                    style: txtDesign.txt2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "⭐ Average Rating: " +
                                        trendingMovies[index]['vote_average']
                                            .toString(),
                                    style: txtDesign.txt2,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Discriptions", style: txtDesign.txt),
                                ],
                              ),
                              SizedBox(
                                height: 100,
                                child: Text(
                                  trendingMovies[index]['overview'],
                                  style: txtDesign.txt2,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                  softWrap: false,
                                ),
                              ),
                            ],
                          ),
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
