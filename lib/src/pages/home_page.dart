import 'package:flutter/material.dart';
import 'package:scooby_app/src/providers/actores_provider.dart';
import 'package:scooby_app/src/search/search_delegate.dart';
import 'package:scooby_app/src/widgets/card_swiper_widget.dart';
import 'package:scooby_app/src/widgets/actor_horizontal.dart';

class HomePage extends StatelessWidget {
  final actoresProvider = new ActoresProvider();

  @override
  Widget build(BuildContext context) {
    actoresProvider.getPopulares();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Actores i Películas TMDB'),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_swiperTarjetas(), _footer(context)],
          ),
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: actoresProvider.getLatest(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(actores: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.bodyText1)),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: actoresProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ActorHorizontal(
                  actores: snapshot.data,
                  siguientePagina: actoresProvider.getPopulares,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
