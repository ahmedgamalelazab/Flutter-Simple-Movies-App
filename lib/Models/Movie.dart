import 'dart:convert';

//Movie Model from the response

class Movie {
  String? backdrop_path;
  int? id;
  String? original_language;
  String? original_title;
  String? overview;
  double? popularity;
  String? poster_path;
  String? release_date;
  String? title;
  bool? video;
  int? vote_count;
  double? vote_average;
  bool isFav = false;
  String? error;
  Movie({
    this.backdrop_path,
    this.id,
    this.original_language,
    this.original_title,
    this.overview,
    this.popularity,
    this.poster_path,
    this.release_date,
    this.title,
    this.video,
    this.vote_count,
    this.vote_average,
    this.error,
    this.isFav = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'backdrop_path': backdrop_path,
      'id': id,
      'original_language': original_language,
      'original_title': original_title,
      'overview': overview,
      'popularity': popularity,
      'poster_path': poster_path,
      'release_date': release_date,
      'title': title,
      'video': video,
      'vote_count': vote_count,
      'vote_average': vote_average,
      'isFav': isFav,
      'error': error,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      backdrop_path: map['backdrop_path'],
      id: map['id']?.toInt(),
      original_language: map['original_language'],
      original_title: map['original_title'],
      overview: map['overview'],
      popularity: map['popularity']?.toDouble(),
      poster_path: map['poster_path'],
      release_date: map['release_date'],
      title: map['title'],
      video: map['video'],
      vote_count: map['vote_count']?.toInt(),
      vote_average: map['vote_average']?.toDouble(),
      isFav: map['isFav'] ?? false,
      error: map['error'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));
}
