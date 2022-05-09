import 'package:dio/dio.dart';
import 'package:movies_app/Models/Movie.dart';

import '../Models/MovieVideoSrc.dart';

class ApiService {
  final Dio _dio = new Dio(); // dio instance // networking package

  final String baseUrl = "https://api.themoviedb.org/3";

  final String apiKey =
      "api_key=55ac345ad760edd037802b7583b09323"; //personal Key

  //async operations

  Future<List<Movie>> getMoviesByCategory({required String category}) async {
    print("someone called me !");
    try {
      final response = await _dio.get('$baseUrl/movie/$category?$apiKey');
      // print(response.data);
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((m) => Movie.fromMap(m)).toList();
      // print(movieList);
      // print(movieList);
      return movieList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception Thrown with error : $error , with stacktrace : $stacktrace');
    }
  }

  Future<MovieVideoSrc> getMovieVideoSrcObject({String? movieId}) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$movieId/videos?$apiKey');

      var movieSrcObject =
          MovieVideoSrc.fromJson((response.data['results'] as List)[0]);

      return movieSrcObject;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception Thrown with error : $error , with stacktrace : $stacktrace');
    }
  }
}



//tested [✅]