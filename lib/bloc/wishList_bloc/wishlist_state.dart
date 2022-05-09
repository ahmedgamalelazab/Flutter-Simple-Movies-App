part of 'wishlist_bloc.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishListOnAdd extends WishlistState {
  List<Movie> wishListMovies;

  WishListOnAdd({
    required this.wishListMovies,
  });
}

class WishListOnRemove extends WishlistState {
  List<Movie> wishListMovies;

  WishListOnRemove({
    required this.wishListMovies,
  });
}

class EmptyWishList extends WishlistState {
  List<Movie> wishListMovies = [];
}
