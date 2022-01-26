import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// ignore: must_be_immutable
class NetworkPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  const NetworkPlayer(
      {Key key, @required this.videoPlayerController, this.looping})
      : super(key: key);

  @override
  _NetworkPlayerState createState() => _NetworkPlayerState();
}

class _NetworkPlayerState extends State<NetworkPlayer> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: widget.looping,
        errorBuilder: (context, errorMessage) {
          return Center(
            child:
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: appPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/back.svg',
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
       
      ),
      body: Chewie(controller: _chewieController),
    );
  }
}
