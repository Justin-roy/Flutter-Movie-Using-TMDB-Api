import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    Key? key,
    required this.movieBanner,
    required this.videoKey,
  }) : super(key: key);

  final String movieBanner, videoKey;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _waitForData = true;
  String _trendingVideoKey = 'N2G2CKudbeQ';
  final String apiKey = 'b5355a8799858cec5961be5fb29a5b5f';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNTM1NWE4Nzk5ODU4Y2VjNTk2MWJlNWZiMjlhNWI1ZiIsInN1YiI6IjYxYzZlN2U0ZjY1OTZmMDA1ZjEwYjdkOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._YorbiCojt_n7ZDC8jkKT0I6a7BPxchmcEACim3LxdA';
  Future<String> loadDataFromTMDB() async {
    final tmdbWithCustomLogs = TMDB(
      ApiKeys(
        apiKey,
        readAccessToken,
      ),
      logConfig: ConfigLogger(
        showLogs: true, //must be true than only all other logs will be shown
        showErrorLogs: true,
      ),
    );

    Map trendinglistVideos = await tmdbWithCustomLogs.v3.movies
        .getVideos(int.parse(widget.videoKey));
    Map trendingTvShowlistVideos =
        await tmdbWithCustomLogs.v3.tv.getVideos(widget.videoKey);
    setState(() {
      _trendingVideoKey = trendinglistVideos['results'][1]['key'];
    });
    //print("Data Are: " + trendingTvShowlistVideos.toString());
    return 'Done';
  }

  _callInit() async {
    await loadDataFromTMDB();
    setState(() {
      _waitForData = false;
    });
    _controller = YoutubePlayerController(
      initialVideoId: _trendingVideoKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    )..addListener(_listnear);
  }

  @override
  void initState() {
    _callInit();
    super.initState();
  }

  void _listnear() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      // use as u want
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _waitForData
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  _isPlayerReady = true;
                },
              ),
            ),
          );
  }
}
