import 'package:http/http.dart' as http;

class Api {
  String mainUrl = 'https://pokeapi.co/api/v2/pokemon/';

  Future<http.Response> base({int count = 10}) {
    var url = Uri.parse('$mainUrl?offset=${count}limit=10');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> pokemonDetails(String url) {
    var res = http.get(Uri.parse(url));
    return res;
  }
}
