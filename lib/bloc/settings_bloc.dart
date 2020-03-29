import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hello_world/bloc/bloc.dart';
import 'package:hello_world/models/models.dart';
import 'package:hello_world/repositories/repositories.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  final LotRepository lotRepository;

  SettingsBloc(this.lotRepository);

  @override
  SettingsState get initialState => SettingsInit();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    print("mapEventToState");
    if (event is SetHost) {
      print("whats");
      this.lotRepository.lotApiClient.baseUrl = event.host;
      print("whats goingon");
      yield SettingsLoaded(event.host);
    }
  }
}

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class FetchSettings extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SetHost extends SettingsEvent {
  final String host;
  const SetHost(this.host);

  @override
  List<Object> get props => [];
}

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInit extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoading extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsNotLoaded extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoaded extends SettingsState {
  final String host;

  const SettingsLoaded(this.host);

  @override
  List<Object> get props => [host];
}