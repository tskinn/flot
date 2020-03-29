import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hello_world/bloc/bloc.dart';
import 'package:hello_world/models/models.dart';
import 'package:hello_world/repositories/repositories.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final LotRepository lotRepository;

  SeriesBloc(this.lotRepository);

  @override
  SeriesState get initialState => SeriesInit();

  @override
  Stream<SeriesState> mapEventToState(
    SeriesEvent event,
  ) async* {
    if (event is FetchSeries) {
      print("fetching series");
      yield SeriesLoading();
      List<Episode> episodes =  await lotRepository.getEpisodes();
      print(episodes.runtimeType.toString());
      print("what are we waiting for?");
      yield SeriesLoaded(episodes);
      print("series fetched?");
    }
  }
}

abstract class SeriesEvent extends Equatable {
  const SeriesEvent();
}

class FetchSeries extends SeriesEvent {

  @override
  List<Object> get props => [];
}

abstract class SeriesState extends Equatable {
  const SeriesState();
}

class SeriesInit extends SeriesState {
  @override
  List<Object> get props => [];
}

class SeriesEmpty extends SeriesState {
  @override
  List<Object> get props => [];
}

class SeriesLoading extends SeriesState {
  @override
  List<Object> get props => [];
}

class SeriesLoaded extends SeriesState {
  final List<Episode> episodes;

  SeriesLoaded(this.episodes);

  @override
  List<Object> get props => [episodes];
}