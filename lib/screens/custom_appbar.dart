import 'package:flutter/material.dart';
import 'package:pmsmbileapp/style/constants.dart';
import 'package:pmsmbileapp/style/responsive.dart';
import 'package:pmsmbileapp/controllers/controller.dart';
import 'package:pmsmbileapp/screens/profile_info.dart';
import 'package:pmsmbileapp/screens/search_field.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          // IconButton(
          //   onPressed: context.read<Controller>().controlMenu,
          //   icon: Icon(Icons.menu,color: textColor.withOpacity(0.5),),
          // ),
        Expanded(child: SearchField()),
        ProfileInfo()
      ],
    );
  }
}
