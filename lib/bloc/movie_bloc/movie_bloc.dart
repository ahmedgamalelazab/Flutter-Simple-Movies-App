import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../Models/Movie.dart';
import '../../services/ApiService.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieInitial()) {
    on<GetMoviesByCategory>((event, emit) async {
      //throw initial state for the consumer
      emit(MoviesLoading());
      //then ask the service to get the movies
      try {
        List<Movie> moviesList = await ApiService().getMoviesByCategory(
            category: (event as GetMoviesByCategory).category);
        emit(MovieLoaded(moviesList));
      } catch (error, stacktrace) {
        //in case of error
        emit(
            MovieError()); // later we can payload the state with error object or error string
      }
    });
  }
}
