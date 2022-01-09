import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Actor%20Screen/ListofMoviesData.dart';
import 'package:movie_demo/Screen/Search%20Screen/Query_Screen.dart';
import 'package:movie_demo/Widgets/constraint.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({Key? key, required this.choice}) : super(key: key);
  final String choice;

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  List _recentsearchData = [];
  QuerySearchScreen searchQuery = QuerySearchScreen();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    _recentsearchData = await searchQuery.loadDataFromTMDB();
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
                        showSearch(
                          context: context,
                          delegate: DataSearch(
                            recentList: _recentsearchData,
                          ),
                        );
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
  DataSearch({
    required this.recentList,
  });
  final List recentList;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
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
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _queryData = query.isEmpty ? recentList : recentList;
    return ListOfMoviesData(queryData: _queryData);
  }
}
