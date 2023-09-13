import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/icon_card.dart';
import 'package:provider/provider.dart';

import 'package:mobile/providers/auth_provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    return Drawer(
      child: Container(
        width: 288,
        height: double.infinity,
        color: const Color(0xFFff6b35),
        child: SafeArea(
          child: Column(
            children: [
              InfoCard(
                name: "${user?.firstName} ${user?.lastName}",
                profession: "${user?.role}",
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Divider(
                      color: Colors.white60,
                      height: 2,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (ModalRoute.of(context)?.settings.name != '/home' &&
                          user?.role != 'Admin') {
                        Navigator.pushNamed(context, '/home');
                      } else if (ModalRoute.of(context)?.settings.name !=
                              '/admin' &&
                          user?.role == 'Admin') {
                        Navigator.pushNamed(context, '/admin');
                      } else {
                        Navigator.maybePop(context);
                      }
                    },
                    child: const ListTile(
                      leading: SizedBox(
                        height: 34,
                        width: 34,
                        child: Icon(
                          CupertinoIcons.house_fill,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Accueil",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  if (isAdmin)
                    InkWell(
                      onTap: () {
                        if (ModalRoute.of(context)?.settings.name != '/users') {
                          Navigator.pushNamed(context, '/users');
                        } else {
                          Navigator.maybePop(context);
                        }
                      },
                      child: const ListTile(
                        leading: SizedBox(
                          height: 34,
                          width: 34,
                          child: Icon(
                            CupertinoIcons.person_2_fill,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "Utilisateurs",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      if (ModalRoute.of(context)?.settings.name !=
                          '/interventions') {
                        Navigator.pushNamed(context, '/interventions');
                      } else {
                        Navigator.maybePop(context);
                      }
                    },
                    child: const ListTile(
                      leading: SizedBox(
                        height: 34,
                        width: 34,
                        child: Icon(
                          CupertinoIcons.layers_alt_fill,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Interventions",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
