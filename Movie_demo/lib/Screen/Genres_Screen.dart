import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_demo/Screen/GenresData_Screen.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({
    Key? key,
    required this.movieCato,
  }) : super(key: key);
  final List movieCato;

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  List _catoData = [];
  Future<String> loadDataFromTMDB(int movieId) async {
    String api =
        'https://api.themoviedb.org/3/discover/movie?api_key=b5355a8799858cec5961be5fb29a5b5f&with_genres=$movieId';
    var url = Uri.parse(api);
    var response = await http.get(url);
    var responseData;
    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    }
    Map catoData = responseData;
    setState(() {
      _catoData = catoData['results'];
    });
    return 'Done';
  }

  @override
  void initState() {
    loadDataFromTMDB(widget.movieCato[12]['id']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.movieCato.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    loadDataFromTMDB(widget.movieCato[index]['id']);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(widget.movieCato[index]['name']),
                  ),
                );
              }),
        ),
        GenericListOfData(catData: _catoData),
      ],
    );
  }
}
