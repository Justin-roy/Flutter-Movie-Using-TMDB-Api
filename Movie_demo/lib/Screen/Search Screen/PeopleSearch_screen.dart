import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Player%20Screen/MainPlayerScreen.dart';
import 'package:movie_demo/Screen/Search%20Screen/Query_Screen.dart';
import 'package:movie_demo/constraint.dart';

List _recentsearchData = [];
List _newSearchData = [];
String _queryData = '';

class PeopleSearchScreen extends StatefulWidget {
  const PeopleSearchScreen({Key? key, required this.choice}) : super(key: key);
  final String choice;

  @override
  State<PeopleSearchScreen> createState() => _PeopleSearchScreenState();
}

class _PeopleSearchScreenState extends State<PeopleSearchScreen> {
  QuerySearchScreen searchQuery = QuerySearchScreen();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    _recentsearchData = await searchQuery.loadDataFromTMDB2();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ),
                      child: Text(
                        "Search Your ${widget.choice} From Here...",
                        style: Design().txt5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        showSearch(context: context, delegate: DataSearch());
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  QuerySearchScreen searchQuery = QuerySearchScreen();
  _getData(String query) async {
    return _newSearchData =
        await searchQuery.loadDataFromTMDB2(searchQuery: query);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            _getData(_queryData);
            _recentsearchData = _newSearchData;
          },
          icon: const Icon(Icons.search)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //  _recentsearchData = _newSearchData;
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _queryData = query;
    final queryData = query.isEmpty ? _recentsearchData : _newSearchData;
    return ListView.builder(
        itemCount: queryData.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (contex) => TvShowScreen(
                    imageUrl: "https://image.tmdb.org/t/p/w500" +
                        queryData[index]['backdrop_path'],
                    movieTitle: queryData[index]['original_title'] ??
                        queryData[index]['original_name'],
                    movieDesp: queryData[index]['overview'],
                    movieReleasedate: queryData[index]['release_date'] ??
                        queryData[index]['first_air_date'],
                    vote: queryData[index]['vote_average'].toString(),
                    popularity: queryData[index]['popularity'].toString(),
                    movieId: queryData[index]['id'],
                    checkMovie: false,
                  ),
                ),
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
                          queryData[index]['poster_path'],
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
