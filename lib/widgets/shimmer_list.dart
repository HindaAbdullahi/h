import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shimmer/shimmer.dart';

import '../utilis/colors.dart';

class LoadingList extends StatefulWidget {
  const LoadingList({super.key});

  @override
  State<LoadingList> createState() => _LoadingListState();
}

class _LoadingListState extends State<LoadingList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                  itemCount: 10,
                  itemBuilder: ((context, index) => Shimmer.fromColors(
                        enabled: true,
                        loop: 10,
                        baseColor: AppColors.backgroundColor1,
                        highlightColor: AppColors.backgroundColor2,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 4, top: 4, right: 16, left: 16),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            leading: CircleAvatar(),
                            title: Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height * 0.03,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width / 0.6,
                              height: MediaQuery.of(context).size.height * 0.02,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),
                );
  }
}