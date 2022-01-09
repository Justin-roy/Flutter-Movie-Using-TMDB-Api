import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/Screen/Player%20Screen/Video_Player.dart';
import 'package:movie_demo/TMDB%20API/ApiKey.dart';
import 'package:movie_demo/Widgets/constraint.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:http/http.dart' as http;

class TrailerListScreen extends StatefulWidget {
  const TrailerListScreen({
    Key? key,
    required this.videoKey,
    this.chooseOptions = true,
    this.type = 'movie',
  }) : super(key: key);
  final String videoKey, type;
  final bool chooseOptions;
  @override
  _TrailerListScreenState createState() => _TrailerListScreenState();
}

class _TrailerListScreenState extends State<TrailerListScreen> {
  List _trendingVideoKey = [];
  Future<String> loadDataFromTMDB() async {
    final tmdbWithCustomLogs = TMDB(
      ApiKeys(
        KEY().apiKey,
        KEY().readAccessToken,
      ),
      logConfig: ConfigLogger(
        showLogs: true, //must be true than only all other logs will be shown
        showErrorLogs: true,
      ),
    );
    Map trendinglistVideos = await tmdbWithCustomLogs.v3.movies
        .getVideos(int.parse(widget.videoKey));
    setState(() {
      _trendingVideoKey = trendinglistVideos['results'];
    });
    return 'Done';
  }

  //Getting Movies Cast
  List _moviesCast = [];
  Future<String> loadDataFromTMDBCAST() async {
    String api =
        'https://api.themoviedb.org/3/${widget.type}/${widget.videoKey}/credits?api_key=${KEY().apiKey}&language=en-US';

    var url = Uri.parse(api);
    var response = await http.get(url);
    var responseData;
    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    }
    Map catoData = responseData;
    setState(() {
      _moviesCast = catoData['cast'];
    });
    print(_moviesCast);
    return 'Done';
  }

  _callInit() async {
    await loadDataFromTMDB();
    await loadDataFromTMDBCAST();
  }

  @override
  void initState() {
    _callInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.chooseOptions
        ? SizedBox(
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
          )
        : SizedBox(
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _moviesCast.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    width: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(55),
                          child: CachedNetworkImage(
                            height: 90,
                            width: 90,
                            fit: BoxFit.fill,
                            imageUrl: "https://image.tmdb.org/t/p/w500" +
                                _moviesCast[index]['profile_path'],
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                            )),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Text(
                          _moviesCast[index]['name'],
                          style: Design().txt5,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
          );
  }
}
