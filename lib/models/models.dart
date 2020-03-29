
class Movie {
  String mime;
  String title;
  String id;

  Movie({this.mime, this.title, this.id});

  Movie.fromJson(dynamic json) {
    mime = json['mime'];
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mime'] = this.mime;
    data['title'] = this.title;
    data['id'] = this.id;
    return data;
  }
}

class Episode {
  String mime;
  int season;
  String id;
  String series;
  int number;

  Episode({this.mime, this.season, this.id, this.series, this.number});

  Episode.fromJson(dynamic json) {
    mime = json['mime'];
    season = json['season'];
    id = json['id'];
    series = json['series'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mime'] = this.mime;
    data['season'] = this.season;
    data['id'] = this.id;
    return data;
  }
}