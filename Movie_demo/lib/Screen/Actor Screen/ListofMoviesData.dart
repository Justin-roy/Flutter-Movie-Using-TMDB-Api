import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/Widgets/constraint.dart';

class ListOfMoviesData extends StatelessWidget {
  const ListOfMoviesData({Key? key, required this.queryData}) : super(key: key);
  final List queryData;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: queryData.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                      height: 200,
                      imageUrl: queryData[index]['poster_path'] != null
                          ? "https://image.tmdb.org/t/p/w500" +
                              queryData[index]['poster_path']
                          : 'https://image.tmdb.org/t/p/w500/lmZFxXgJE3vgrciwuDib0N8CfQo.jpg',
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
                                queryData[index]['original_title'] ??
                                    queryData[index]['original_name'],
                                style: Design().txt4,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Release Date: ",
                                  style: Design().txt2,
                                ),
                                Text(
                                  queryData[index]['release_date'] ??
                                      queryData[index]['first_air_date'],
                                  style: Design().txt2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "⭐ Average Rating: " +
                                      queryData[index]['vote_average']
                                          .toString(),
                                  style: Design().txt2,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Discriptions", style: Design().txt),
                              ],
                            ),
                            SizedBox(
                              height: 100,
                              child: Text(
                                queryData[index]['overview'],
                                style: Design().txt2,
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
        });
  }
}
