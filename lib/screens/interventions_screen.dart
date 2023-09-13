import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/widgets/interventions/info.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:mobile/models/user_model.dart';
import 'package:mobile/providers/auth_provider.dart';

import 'package:mobile/services/user_service.dart';
import 'package:mobile/services/intervention_service.dart';

import 'package:mobile/widgets/interventions/create.dart';
import 'package:mobile/widgets/interventions/update.dart';
import 'package:mobile/widgets/side_menu.dart';
import 'package:mobile/widgets/side_menu_button.dart';

class InterventionScreen extends StatefulWidget {
  const InterventionScreen({Key? key}) : super(key: key);

  @override
  InterventionScreenState createState() => InterventionScreenState();
}

class InterventionScreenState extends State<InterventionScreen> {
  final userService = UserService();
  final interventionService = InterventionService();

  late List<UserModel> _userModel = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
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
                          'Toutes les interventions',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _userModel.length,
                            itemBuilder: (context, index) {
                              final interventions =
                                  _userModel[index].interventions;

                              if (interventions.isNotEmpty) {
                                return Column(
                                  children: [
                                    ...interventions.map(
                                      (intervention) {
                                        return InkWell(
                                          onTap: () => {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) => SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.7,
                                                child:
                                                    InterventionInfoPopupWidget(
                                                  intervention: intervention,
                                                ),
                                              ),
                                            ).then(
                                              (_) => {
                                                _getData(),
                                              },
                                            ),
                                          },
                                          child: Card(
                                            elevation: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
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
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) =>
                                                            SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.9,
                                                          child:
                                                              InterventionUpdatePopupWidget(
                                                            users: _userModel,
                                                            intervention:
                                                                intervention,
                                                          ),
                                                        ),
                                                      ).then(
                                                        (_) => {
                                                          _getData(),
                                                        },
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      backgroundColor: Colors
                                                          .deepOrangeAccent,
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.update,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    SlidableAction(
                                                      flex: 2,
                                                      onPressed: (_) async {
                                                        await interventionService
                                                            .archive(
                                                                intervention
                                                                    .id!);
                                                        await _getData();
                                                      },
                                                      backgroundColor:
                                                          Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.archive,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    SlidableAction(
                                                      flex: 2,
                                                      onPressed: (_) async {
                                                        await interventionService
                                                            .delete(intervention
                                                                .id!);
                                                        await _getData();
                                                      },
                                                      backgroundColor:
                                                          Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.delete,
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            225, 95, 27, .3),
                                                        blurRadius: 20,
                                                        offset: Offset(0, 2),
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        intervention.title,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(children: [
                                                        const Icon(CupertinoIcons.calendar),
                                                        const SizedBox(width: 10,),
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
                                                      ],),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                              CupertinoIcons
                                                                  .wrench_fill),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            '${_userModel[index].firstName} ${_userModel[index].lastName}',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            intervention.archived !=
                                                                        null &&
                                                                    intervention
                                                                        .archived!
                                                                ? Icons.auto_mode
                                                                : CupertinoIcons
                                                                    .check_mark_circled_solid,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            intervention
                                                                    .archived!
                                                                ? 'En cours'
                                                                : 'Terminé',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                        );
                                      },
                                    ).toList(),
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
                          child: InterventionCreatePopupWidget(
                            users: _userModel,
                          ),
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
                        width: 200,
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
                                CupertinoIcons.layers_alt_fill,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Interventions',
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
