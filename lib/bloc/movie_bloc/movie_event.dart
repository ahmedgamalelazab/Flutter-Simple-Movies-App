part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class GetMoviesByCategory extends MovieEvent {
  final String category;

  const GetMoviesByCategory({this.category = "popular"});
}
