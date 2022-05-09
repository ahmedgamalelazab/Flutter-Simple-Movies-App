import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/bloc/wishList_bloc/wishlist_bloc.dart';
import 'package:movies_app/utils/CustomizedEventEmitter.dart';

class WishListScreen extends StatefulWidget {
  static final String SCREEN_ROUTE = "WISHLIST";
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  WishlistBloc? wishListBloc;
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (initialized == false) {
      wishListBloc = BlocProvider.of<WishlistBloc>(context);
      initialized = true;
    }

    var pubSub = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)["pubsub"] as CustomEventEmitter;

    return Scaffold(
      body: BlocConsumer<WishlistBloc, WishlistState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is WishListOnRemove) {
            print(state.wishListMovies.length);
            return Container(
              alignment: Alignment.center,
              child: LayoutBuilder(
                builder: ((context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.8,
                    height: constraints.maxHeight,
                    child: ListView.builder(
                      itemCount: state.wishListMovies.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    state.wishListMovies[index].original_title!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ), // title
                              ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/original/${state.wishListMovies[index].backdrop_path}',
                                  height: screenHeight * 0.4,
                                  width: screenWidth * 0.8,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text((state.wishListMovies[index]
                                                .vote_average)
                                            .toString()),
                                        Icon(
                                          Icons.star,
                                          color: Colors.black45,
                                        )
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        wishListBloc!
                                                .favouriteMovies[index].isFav =
                                            !wishListBloc!
                                                .favouriteMovies[index].isFav;
                                        //adding the item to the wish list bloc
                                        //again we should save the content in sqlite data base
                                        pubSub.emit(event: "liked", data: "");

                                        BlocProvider.of<WishlistBloc>(context).emit(
                                            WishlistInitial()); //resetting the state

                                        BlocProvider.of<WishlistBloc>(context)
                                            .add(RemoveFromWishList(
                                                favouriteMovie: wishListBloc!
                                                    .favouriteMovies[index]));
                                      },
                                      icon: wishListBloc!
                                              .favouriteMovies[index].isFav
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_outline_outlined,
                                              color: Colors.red,
                                            ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            );
          } else if (state is EmptyWishList) {
            return Center(child: Text("No more favourite movies"));
          } else {
            return Container(
              alignment: Alignment.center,
              child: LayoutBuilder(
                builder: ((context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.8,
                    height: constraints.maxHeight,
                    child: ListView.builder(
                      itemCount: wishListBloc!.favouriteMovies.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    wishListBloc!
                                        .favouriteMovies[index].original_title!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ), // title
                              ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/original/${wishListBloc!.favouriteMovies[index].backdrop_path}',
                                  height: screenHeight * 0.4,
                                  width: screenWidth * 0.8,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text((wishListBloc!
                                                .favouriteMovies[index]
                                                .vote_average)
                                            .toString()),
                                        Icon(
                                          Icons.star,
                                          color: Colors.black45,
                                        )
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        wishListBloc!
                                                .favouriteMovies[index].isFav =
                                            !wishListBloc!
                                                .favouriteMovies[index].isFav;
                                        //adding the item to the wish list bloc
                                        //again we should save the content in sqlite data base
                                        pubSub.emit(event: "liked", data: "");

                                        BlocProvider.of<WishlistBloc>(context)
                                            .add(RemoveFromWishList(
                                                favouriteMovie: wishListBloc!
                                                    .favouriteMovies[index]));
                                      },
                                      icon: wishListBloc!
                                              .favouriteMovies[index].isFav
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_outline_outlined,
                                              color: Colors.red,
                                            ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            );
          }
          ;
        },
      ),
    );
  }
}
