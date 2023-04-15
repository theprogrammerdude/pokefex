import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localstorage/localstorage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pokefex/methods/api.dart';
import 'package:pokefex/widgets/details.dart';
import 'package:velocity_x/velocity_x.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  final Api _api = Api();
  final LocalStorage _localStorage = LocalStorage('local');

  List<String> d = [];

  @override
  void initState() {
    d = _localStorage.getItem('saved') ?? [];
    super.initState();
  }

  details(String url) {
    showBarModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return Details(
          details: _api.pokemonDetails(url),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'My Pokemons'.text.make(),
      ),
      body: ListView.builder(
        itemCount: d.length,
        itemBuilder: (context, index) {
          var data = jsonDecode(d[index]);

          List<String> urlList = data['url'].toString().split('/');
          var id = urlList[urlList.length - 2];

          return GestureDetector(
            onTap: () => details(data['url']),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SvgPicture.network(
                    'https://unpkg.com/pokeapi-sprites@2.0.2/sprites/pokemon/other/dream-world/$id.svg',
                    height: 100,
                  ).w(125).pOnly(right: 10),
                  data['name']
                      .toString()
                      .text
                      .bold
                      .uppercase
                      .softWrap(true)
                      .size(16)
                      .make(),
                ],
              ).p12(),
            ).pOnly(bottom: 8),
          );
        },
      ),
    );
  }
}
