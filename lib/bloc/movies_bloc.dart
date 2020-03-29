import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hello_world/bloc/bloc.dart';
import 'package:hello_world/models/models.dart';
import 'package:hello_world/repositories/repositories.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final LotRepository lotRepository;

  MoviesBloc(this.lotRepository);

  @override
  MoviesState get initialState => MoviesInit();

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    print("MOVIES-EVENT");
    if (event is FetchMovies) {
      print("fetching Movie");
      yield MoviesLoading();
      List<Movie> movies =  await lotRepository.getMovies().then((mov) => mov, onError: (d) => print(d));
      yield MoviesLoaded(movies);
      print("Movie fetched?");
    }
  }
}

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
}

class FetchMovies extends MoviesEvent {

  @override
  List<Object> get props => [];
}

abstract class MoviesState extends Equatable {
  const MoviesState();
}

class MoviesInit extends MoviesState {
  @override
  List<Object> get props => [];
}

class MoviesEmpty extends MoviesState {
  @override
  List<Object> get props => [];
}

class MoviesLoading extends MoviesState {
  @override
  List<Object> get props => [];
}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;

  MoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}