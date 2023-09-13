import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/screens/intervention_detail_screen.dart';
import 'package:mobile/services/intervention_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:mobile/models/user_model.dart';
import 'package:mobile/services/user_service.dart';
import 'package:mobile/widgets/side_menu.dart';
import 'package:mobile/widgets/side_menu_button.dart';
import 'package:mobile/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final InterventionService _interventionService = InterventionService();

  late UserModel user;
  bool _isLoadingUserData = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var authProvider = Provider.of<AuthProvider>(context);
    setState(() {
      user = authProvider.user!;
    });

    if (!_isLoadingUserData) {
      return;
    }

    _isLoadingUserData = false;

    _loadUserData().then((userData) {
      setState(() {
        user = userData;
      });
      authProvider.updateUser(userData);
    });
  }

  Future<UserModel> _loadUserData() async {
    final userData = await _userService.getUserById(user.id!);
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    final String formatted =
        DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now()).toUpperCase();

    return Scaffold(
      drawer: const SideMenu(),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadUserData();
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
                          "Bonjour ${user.firstName}!",
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
                          'Intervention du jour',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: user.interventions.where((intervention) {
                              final interventionAt = intervention.date != null
                                  ? DateTime.parse(intervention.date!)
                                  : null;
                              final currentDateTime = DateTime.now();
                              return interventionAt?.day == currentDateTime.day &&
                                  interventionAt?.month == currentDateTime.month &&
                                  interventionAt?.year == currentDateTime.year &&
                                  !intervention.archived!;
                            }).length,
                            itemBuilder: (context, index) {
                              final intervention = user.interventions[index];
                              final interventionAt = intervention.date != null
                                  ? DateTime.parse(intervention.date!)
                                  : null;
                              final currentDateTime = DateTime.now();

                              if (interventionAt?.day == currentDateTime.day &&
                                  interventionAt?.month ==
                                      currentDateTime.month &&
                                  interventionAt?.year ==
                                      currentDateTime.year && !intervention.archived!) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                InterventionDetailsScreen(
                                              intervention: intervention,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Slidable(
                                            key: UniqueKey(),
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                SlidableAction(
                                                  onPressed: (_) async {
                                                    await _interventionService
                                                        .archive(
                                                            intervention.id!)
                                                        .then((value) =>
                                                            _loadUserData());
                                                  },
                                                  backgroundColor: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.archive,
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
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    intervention.title,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  const Divider(
                                                    color: Colors.black,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(CupertinoIcons
                                                          .calendar),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                                'dd/MM/yyyy HH:mm')
                                                            .format(
                                                          DateTime.parse(
                                                              intervention
                                                                  .date!),
                                                        ),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        CupertinoIcons
                                                            .person_fill,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        intervention
                                                            .clientName!,
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(CupertinoIcons
                                                          .location_fill),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        intervention.address!,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                      ],
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
