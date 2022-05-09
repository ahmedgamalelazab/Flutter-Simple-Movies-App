import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Models/Movie.dart';
import 'package:movies_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movies_app/bloc/wishList_bloc/wishlist_bloc.dart';
import 'package:movies_app/screens/movieDetailPage.dart';
import 'package:movies_app/screens/wishListScreen.dart';
import 'package:movies_app/services/ApiService.dart';
import 'package:movies_app/utils/CustomizedEventEmitter.dart';

class HomeScreen extends StatefulWidget {
  static const PAGE_ROUTE = "HOMESCREEN";
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomEventEmitter pubsub = new CustomEventEmitter();

  @override
  void initState() {
    pubsub.on(
        event: "liked",
        handler: (data) {
          setState(() {});
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black45,
                ),
                onSelected: (String result) {
                  switch (result) {
                    case 'Popularity':
                      BlocProvider.of<MovieBloc>(context)
                          .add(GetMoviesByCategory(category: "popular"));
                      break;
                    case 'TopRated':
                      BlocProvider.of<MovieBloc>(context)
                          .add(GetMoviesByCategory(category: "top_rated"));
                      break;
                    case 'wishList':
                      Navigator.of(context)
                          .pushNamed(WishListScreen.SCREEN_ROUTE, arguments: {
                        "pubsub": pubsub
                      }); // sending it there in order to update the screen
                      break;
                    default:
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Popularity',
                    child: Text('Popularity'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'TopRated',
                    child: Text('TopRated'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'wishList',
                    child: Text('Wish list'),
                  ),
                ],
              ),
            ),
          ],
          title: const Text(
            "Movies App",
            style: TextStyle(
              color: Colors.black45,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _buildBody(context, deviceHeight, deviceWidth, pubsub));
  }
}

Widget _buildBody(BuildContext context, double deviceHeight, double deviceWidth,
    CustomEventEmitter pubsub) {
  final double itemHeight = (deviceHeight - kToolbarHeight - 24) / 2;
  final double itemWidth = deviceWidth / 2;
  return BlocBuilder<MovieBloc, MovieState>(
    builder: ((context, state) {
      if (state is MoviesLoading) {
        return const Center(
          child:
              CircularProgressIndicator(), // on opening we emitted getMovieByCategoryName(initial state popularity); then we emitted loading
        );
      } else if (state is MovieLoaded) {
        print(state.props); // testing the payload coming back from the server
        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: (itemWidth / itemHeight),
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4),
              itemCount: state.movieList.length,
              itemBuilder: (context, index) {
                return LayoutBuilder(
                  builder: ((context, constraints) {
                    return GestureDetector(
                      onTap: () async {
                        print(state.movieList[index].id);
                        //do query on the internet to fetch the videos of the movie
                        var movieVideoSrc = await ApiService()
                            .getMovieVideoSrcObject(
                                movieId:
                                    (state.movieList[index].id).toString());
                        //take arguments the current movie
                        Navigator.of(context).pushNamed(
                            MovieDetailScreen.SCREEN_ROUTE,
                            arguments: {
                              "currentMovie": state.movieList[index],
                              "movieVideoSrc": movieVideoSrc
                            });
                        //go to next page
                      },
                      child: Container(
                        child: Card(
                          child: Stack(
                            children: [
                              ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/original/${state.movieList[index].backdrop_path}',
                                  height: constraints.maxHeight,
                                  width: constraints.maxWidth,
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
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  height: constraints.maxHeight / 3,
                                  width: constraints.maxWidth,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text(state.movieList[index]
                                                    .original_title ??
                                                ""),
                                            Text(state.movieList[index]
                                                    .release_date ??
                                                "")
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text((state.movieList[index]
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
                                                  state.movieList[index].isFav =
                                                      !state.movieList[index]
                                                          .isFav;
                                                  //adding the item to the wish list bloc
                                                  //again we should save the content in sqlite data base
                                                  BlocProvider.of<WishlistBloc>(
                                                          context)
                                                      .add(AddToWishList(
                                                          favouriteMovie:
                                                              state.movieList[
                                                                  index]));

                                                  pubsub.emit(
                                                      event: "liked", data: "");
                                                },
                                                icon:
                                                    state.movieList[index].isFav
                                                        ? Icon(
                                                            Icons.favorite,
                                                            color: Colors.red,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_outline_outlined,
                                                            color: Colors.red,
                                                          ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
        );
      } else {
        return const Center(
          child: Text("error"),
        );
      }
    }),
  );
}
