// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(200),
                          bottomRight: Radius.circular(200))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blueGrey.shade300],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.5, 0.9],
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage('assets/profile.jpg'),
                          radius: 60,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blueGrey,
                          ),
                          title: Text('Badrudin Mohamed Ali'),
                          subtitle: Text('Full name'),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.email,
                            size: 40,
                            color: Colors.blueGrey,
                          ),
                          title: Text('Badrudin@gmail.com'),
                          subtitle: Text('E-mail'),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.male,
                            size: 40,
                            color: Colors.blueGrey,
                          ),
                          title: Text('Male'),
                          subtitle: Text('Gender'),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.date_range,
                            size: 40,
                            color: Colors.blueGrey,
                          ),
                          title: Text('1997/2/3'),
                          subtitle: Text('Birthday'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
