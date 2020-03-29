import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';
import 'package:hello_world/repositories/repositories.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {

  VideoPlayerController _controller;

  @override
  VideoPlayerState get initialState => VideoPlayerInit();

  @override
  Stream<VideoPlayerState> mapEventToState(
    VideoPlayerEvent event,
  ) async* {
    print("mapEventToState");
    if (event is NewVideoPlayerController) {
      if (_controller != null) _controller.dispose();
      _controller = event._controller;
    }
  }
}

abstract class VideoPlayerEvent extends Equatable {
  const VideoPlayerEvent();
}

class NewVideoPlayerController extends VideoPlayerEvent {
  NewVideoPlayerController(this._controller);

  final VideoPlayerController _controller;

  @override
  List<Object> get props => [_controller];
}

class SetNetworkVideoPlayer extends VideoPlayerEvent {
  @override
  List<Object> get props => [];
}

abstract class VideoPlayerState extends Equatable {
  const VideoPlayerState();
}

class VideoPlayerInit extends VideoPlayerState {
  @override
  List<Object> get props => [];
}

class VideoPlayerLoading extends VideoPlayerState {
  @override
  List<Object> get props => [];
}

class VideoPlayerNotLoaded extends VideoPlayerState {
  @override
  List<Object> get props => [];
}

class VideoPlayerLoaded extends VideoPlayerState {
  final String host;

  const VideoPlayerLoaded(this.host);

  @override
  List<Object> get props => [host];
}

