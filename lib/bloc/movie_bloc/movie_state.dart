part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MoviesLoading extends MovieState {} // loading state

//this state will be later on payloaded with the movies
class MovieLoaded extends MovieState {
  final List<Movie> movieList;
  const MovieLoaded(this.movieList);

  @override
  List<Object> get props => [movieList];
}

//TODO handle this state
//handling the errors coming from the server like error with the api key or something like that
class MovieError extends MovieState {}
