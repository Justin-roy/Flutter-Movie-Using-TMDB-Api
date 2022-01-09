import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movie_demo/TMDB%20API/ApiKey.dart';

class QuerySearchScreen {
  Future<List> loadDataFromTMDB({String searchQuery = 'Batman'}) async {
    String find = ' ';
    String replaceWith = '+';
    String newString = searchQuery.replaceAll(find, replaceWith);
    String api =
        'http://api.themoviedb.org/3/search/movie?query=$newString&api_key=${KEY().apiKey}';
    var url = Uri.parse(api);
    var response = await http.get(url);
    var responseData;
    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    }
    Map catoData = responseData;
    return catoData['results'];
  }

  Future<List> loadDataFromTMDB2({String searchQuery = 'Tom Holland'}) async {
    String find = ' ';
    String replaceWith = '+';
    String newString = searchQuery.replaceAll(find, replaceWith);
    String api =
        'https://api.themoviedb.org/3/search/person?query=$newString&api_key=${KEY().apiKey}';
    var url = Uri.parse(api);
    var response = await http.get(url);
    var responseData;
    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    }
    Map catoData = responseData;
    return catoData['results'];
  }
}
