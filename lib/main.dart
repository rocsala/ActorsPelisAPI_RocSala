import 'package:flutter/material.dart';

import 'package:scooby_app/src/pages/home_page.dart';
import 'package:scooby_app/src/pages/actor_detalle.dart';
import 'package:scooby_app/src/pages/pelicula_detalle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas TMDB',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'pelicula': (BuildContext context) => PeliculaDetalle(),
        'actor': (BuildContext context) => ActorDetalle(),
      },
    );
  }
}
