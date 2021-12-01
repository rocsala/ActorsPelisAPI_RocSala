// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';

class ActoresProvider {
  String _apikey = 'fc093fb8f40d81b227c484d1a0e2e702';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Actor> _populares = [];

  final _popularesStreamController = StreamController<List<Actor>>.broadcast();

  Function(List<Actor>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Actor>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Actor>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final actores = new Actores.fromJsonList(decodedData['results']);

    return actores.items;
  }

  Future<List<Actor>> getLatest() async {
    final url = Uri.https(_url, '/3/person/popular',
        {'api_key': _apikey, 'language': _language}); // Actor
    return await _procesarRespuesta(url);
  }

  Future<List<Actor>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '/3/person/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    }); // Actor
    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Pelicula>> getRelacionados(String personId) async {
    final url = Uri.https(_url, '3/person/$personId/movie_credits',
        {'api_key': _apikey, 'language': _language}); // pelicula

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final relacionadas = new Relacionados.fromJsonList(decodedData['cast']);

    return relacionadas.peliculas;
  }

  Future<String> getDatos(int personId) async {
    final url = Uri.https(_url, '3/person/$personId',
        {'api_key': _apikey, 'language': _language}); // actor

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    return decodedData['biography'];
  }

  Future<List<Actor>> buscarActor(String query) async {
    final url = Uri.https(_url, '3/search/person',
        {'api_key': _apikey, 'language': _language, 'query': query}); // Actor

    return await _procesarRespuesta(url);
  }
}
