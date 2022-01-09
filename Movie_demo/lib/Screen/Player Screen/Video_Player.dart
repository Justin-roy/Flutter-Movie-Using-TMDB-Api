import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    Key? key,
    required this.videoKey,
  }) : super(key: key);

  final String videoKey;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _waitForData = true;

  _callInit() async {
    setState(() {
      _waitForData = false;
    });
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoKey,
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
