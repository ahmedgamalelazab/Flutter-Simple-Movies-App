import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/Models/Movie.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  List<Movie> favouriteMovies =
      []; //error prone area .. in flutter design i always keep the data in sqlite data base

  WishlistBloc() : super(WishlistInitial()) {
    on<AddToWishList>((event, emit) {
      //usually if i have time i do this in internal sql db but we will store it in repository
      favouriteMovies.add((event as AddToWishList).favouriteMovie);
      emit(WishListOnAdd(wishListMovies: favouriteMovies));
    });
    on<RemoveFromWishList>((event, emit) {
      favouriteMovies.remove((event as RemoveFromWishList).favouriteMovie);
      List<Movie> temp = favouriteMovies;

      if (favouriteMovies.isEmpty) {
        emit(EmptyWishList());
        return;
      }
      //usually if i have time i do this in internal sql db but we will store it in repository
      emit(WishListOnRemove(wishListMovies: temp));
    });
  }
}
