
import 'dart:convert';
import 'dart:async';
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:hello_world/models/models.dart';

class LotApiClient {
  var baseUrl;
  final http.Client httpClient;

  LotApiClient(this.baseUrl, {@required this.httpClient}) : assert(httpClient != null);

  Future<List<Movie>> getMovies() async {
    final locationUrl = '$baseUrl/movies';
    final locationResponse = await this.httpClient.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw Exception('error getting movies');
    }
    final locationJson = jsonDecode(locationResponse.body).cast();
    print("jello pudding");
    final List<Movie> mapped = locationJson['data'].map<Movie>((model) => Movie.fromJson(model)).toList();
    return mapped;
  }

  Future<List<Episode>> getEpisodes() async {
    try {
    final locationUrl = '$baseUrl/episodes';
    final locationResponse = await this.httpClient.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw Exception('error getting movies');
    }
    final locationJson = jsonDecode(locationResponse.body).cast();
    print(locationJson['data'].runtimeType.toString());
    final List<Episode> mapped = locationJson['data'].map<Episode>((model) => Episode.fromJson(model)).toList();
    print(mapped.runtimeType.toString());
    return mapped;
    } catch(e) {
      print(e);
    }
  }
}