
import 'dart:async';

import 'package:meta/meta.dart';

import 'package:hello_world/repositories/lot_api_client.dart';
import 'package:hello_world/models/models.dart';

class LotRepository {
  final LotApiClient lotApiClient;

  LotRepository({@required this.lotApiClient})
      : assert(lotApiClient != null);

  Future<List<Movie>> getMovies() {
    return lotApiClient.getMovies();
  }

  Future<List<Episode>> getEpisodes() {
    return lotApiClient.getEpisodes();
  }
}