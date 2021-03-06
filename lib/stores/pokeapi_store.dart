import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex_flutter/consts/consts_api.dart';
import 'package:pokedex_flutter/consts/consts_app.dart';
import 'package:pokedex_flutter/models/pokeapi.dart';
import 'package:http/http.dart' as http;

part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {
  @observable
  PokeAPI _pokeAPI;

  @observable
  Pokemon _pokemonCurrent;

  @observable
  dynamic colPokemon;

  @observable
  int positionCurrent;

  @computed
  PokeAPI get pokeAPI => _pokeAPI;

  @computed
  Pokemon get pokemonCurrent => _pokemonCurrent;

  @action
  fetchPokemonList() {
    _pokeAPI = null;
    loadPokeAPI().then((pokeList) {
      _pokeAPI = pokeList;
    });
  }

  Pokemon getPokemon({int index}) {
    return _pokeAPI.pokemon[index];
  }

  @action
  setPokemonCurrent({int index}) {
    _pokemonCurrent = _pokeAPI.pokemon[index];
    colPokemon = ConstsApp.getColorType(type: _pokemonCurrent.type[0]);
    positionCurrent = index;
  }

  @action
  Widget getImage({String number}) {
    return CachedNetworkImage(
      placeholder: (context, url) => new Container(
        color: Colors.transparent,
      ),
      imageUrl:
          'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$number.png',
    );
  }

  Future<PokeAPI> loadPokeAPI() async {
    try {
      final response = await http.get(ConstsAPI.pokeapiURL);
      var decodeJson = jsonDecode(response.body);
      return PokeAPI.fromJson(decodeJson);
    } catch (error, stacktrace) {
      print("Error loading list" + stacktrace.toString());
      return null;
    }
  }
}
