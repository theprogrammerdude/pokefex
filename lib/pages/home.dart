import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localstorage/localstorage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pokefex/methods/api.dart';
import 'package:pokefex/pages/saved.dart';
import 'package:pokefex/widgets/details.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Api _api = Api();
  final LocalStorage _localStorage = LocalStorage('local');

  var rand = Random().nextInt(1200);
  List<dynamic> d = [];

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
  void initState() {
    d = _localStorage.getItem('saved') ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'POKEFEX'.text.make(),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Saved(),
              ),
            );
          },
          icon: const Icon(Iconsax.save_21),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  rand = Random().nextInt(1200);
                });
              },
              icon: const Icon(Iconsax.refresh)),
        ],
      ),
      body: FutureBuilder(
          future: _api.base(count: rand),
          builder: (context, AsyncSnapshot<Response> snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data!.body);
              var list = data['results'];

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  List<String> urlList =
                      list[index]['url'].toString().split('/');
                  var id = urlList[urlList.length - 2];
                  var l = jsonEncode(list[index]);

                  return GestureDetector(
                    onTap: () => details(list[index]['url']),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.network(
                                'https://unpkg.com/pokeapi-sprites@2.0.2/sprites/pokemon/other/dream-world/$id.svg',
                                height: 100,
                              ).w(125).pOnly(right: 10),
                              list[index]['name']
                                  .toString()
                                  .text
                                  .bold
                                  .uppercase
                                  .softWrap(true)
                                  .size(16)
                                  .make(),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              if (d.contains(l)) {
                                setState(() {
                                  d.remove(l);
                                });
                                _localStorage.setItem('saved', d);
                              } else {
                                setState(() {
                                  d.add(l);
                                });
                                _localStorage.setItem('saved', d);
                              }
                            },
                            icon: d.contains(l)
                                ? const Icon(
                                    Iconsax.heart5,
                                    color: Colors.red,
                                  )
                                : const Icon(Iconsax.heart),
                          )
                        ],
                      ).p12(),
                    ).pOnly(bottom: 8),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
