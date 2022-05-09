part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

//event to add item to the wish list
class AddToWishList extends WishlistEvent {
  final Movie favouriteMovie;

  AddToWishList({required this.favouriteMovie});
}

//event to remove item from the wish list
class RemoveFromWishList extends WishlistEvent {
  final Movie favouriteMovie;

  RemoveFromWishList({required this.favouriteMovie});
}
