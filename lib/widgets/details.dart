// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class Details extends StatefulWidget {
  const Details({
    Key? key,
    required this.details,
  }) : super(key: key);

  final Future details;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Color getColor() {
    List<Color> colors = [
      Colors.yellow,
      Colors.green,
      Colors.blueAccent,
      Colors.pink,
      Colors.orange,
      Colors.amber,
      Colors.blueGrey,
      Colors.lightBlueAccent
    ];
    Random random = Random();
    int cindex = random.nextInt(colors.length);
    Color tempcol = colors[cindex];

    return tempcol;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.details,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = jsonDecode(snapshot.data!.body);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.network(
                'https://unpkg.com/pokeapi-sprites@2.0.2/sprites/pokemon/other/dream-world/${data['id']}.svg',
                height: 300,
              ).pSymmetric(v: 30),
              data['name'].toString().text.bold.uppercase.size(20).make(),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        'Height'.text.make().pOnly(bottom: 5),
                        data['height'].toString().text.make(),
                      ],
                    ),
                    Column(
                      children: [
                        'Weight'.text.make().pOnly(bottom: 5),
                        data['weight'].toString().text.make(),
                      ],
                    ),
                    Column(
                      children: [
                        'Experience'.text.make().pOnly(bottom: 5),
                        data['base_experience'].toString().text.make(),
                      ],
                    ),
                  ],
                ).p12(),
              ).p8(),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data['stats'].length,
                  itemBuilder: (context, index) {
                    int percent = data['stats'][index]['base_stat'];

                    return Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: data['stats'][index]['stat']['name']
                              .toString()
                              .replaceAll(RegExp(r'[^\w\s]+'), ' ')
                              .text
                              .capitalize
                              .make(),
                        ),
                        Expanded(
                          flex: 2,
                          child: Stack(
                            children: [
                              Container(
                                color: Colors.grey,
                                width: MediaQuery.of(context).size.width,
                                height: 4,
                              ),
                              Container(
                                color: getColor(),
                                width: double.parse(percent.toString()),
                                height: 4,
                              ),
                            ],
                          ).pOnly(left: 20),
                        ),
                      ],
                    );
                  },
                ).p12(),
              ).p8(),
            ],
          ).p12();
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
