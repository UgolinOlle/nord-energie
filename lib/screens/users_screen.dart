import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/widgets/side_menu.dart';
import 'package:mobile/widgets/side_menu_button.dart';
import 'package:mobile/widgets/user/create.dart';
import 'package:mobile/widgets/user/info.dart';
import 'package:mobile/widgets/user/update.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:mobile/models/user_model.dart';
import 'package:mobile/services/user_service.dart';
import 'package:mobile/providers/auth_provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final userService = UserService();
  late List<UserModel> _userModel = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final users = await userService.getAllUsers();
    setState(() {
      _userModel = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final String formatted =
        DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now()).toUpperCase();

    return Scaffold(
      drawer: const SideMenu(),
      body: RefreshIndicator(
        onRefresh: () async {
          _getData();
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Color(0xFFff6b35),
              Color(0xFFf7c59f),
              Color(0xFFefefd0)
            ]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bonjour ${user?.firstName}!",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                        ),
                        Builder(builder: (BuildContext context) {
                          return SideMenuButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      formatted,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        const Text(
                          "Utilisateurs",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _userModel.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Card(
                                    elevation: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) => SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            child: UserPopupWidget(
                                                user: _userModel[index]),
                                          ),
                                        );
                                      },
                                      child: Slidable(
                                        key: UniqueKey(),
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SlidableAction(
                                              flex: 2,
                                              onPressed: (_) =>
                                                  showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) => SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.9,
                                                  child: UserUpdatePopupWidget(
                                                    user: _userModel[index],
                                                  ),
                                                ),
                                              ).then(
                                                (_) => {
                                                  _getData(),
                                                },
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              backgroundColor:
                                                  Colors.deepOrangeAccent,
                                              foregroundColor: Colors.white,
                                              icon: Icons.update,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SlidableAction(
                                              flex: 2,
                                              onPressed: (_) async {
                                                await userService
                                                    .delete(
                                                        _userModel[index].id!)
                                                    .then((_) => _getData());
                                              },
                                              backgroundColor: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10),
                                              )
                                            ],
                                          ),
                                          child: SizedBox(
                                            height: null,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.person),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${_userModel[index].firstName} ${_userModel[index].lastName}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 100,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () => {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: UserCreatePopupWidget(),
                        ),
                      ).then(
                        (_) => {
                          _getData(),
                        },
                      ),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFff6b35),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.plus_app_fill,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Utilisateur',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
