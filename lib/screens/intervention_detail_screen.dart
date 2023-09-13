import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:mobile/models/intervention_model.dart';
import 'package:mobile/services/intervention_service.dart';
import 'package:mobile/widgets/interventions/note.dart';
import 'package:mobile/widgets/interventions/notes.dart';
import 'package:mobile/widgets/side_menu.dart';
import 'package:mobile/widgets/side_menu_button.dart';

class InterventionDetailsScreen extends StatefulWidget {
  late InterventionModel intervention;

  InterventionDetailsScreen({
    Key? key,
    required this.intervention,
  }) : super(key: key);

  @override
  InterventionDetailsScreenState createState() =>
      InterventionDetailsScreenState();
}

class InterventionDetailsScreenState extends State<InterventionDetailsScreen> {
  final interventionService = InterventionService();
  final imagePicker = ImagePicker();
  late File? _image = null;

  Future<InterventionModel> _reload(String id) async {
    var newInterventionData = await interventionService.getById(id);
    setState(() {
      widget.intervention = newInterventionData;
    });
    return newInterventionData;
  }

  Future _getImageFromCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageFile = File(image.path);

    setState(() {
      _image = imageFile;
    });

    await interventionService.sendImage(widget.intervention.id!, imageFile);
  }

  Future _deletePicture() async {
    await interventionService.deletePicture(widget.intervention.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Color(0xFFff6b35), Color(0xFFf7c59f), Color(0xFFefefd0)],
            ),
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
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const Text(
                              "Intervention",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ],
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
                            topRight: Radius.circular(60))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                widget.intervention.title,
                                style: const TextStyle(fontSize: 30),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Divider(color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Flex(
                                  direction: Axis.vertical,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "Description",
                                        style: TextStyle(
                                          fontSize: 30,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      child: Text(
                                        widget.intervention.description,
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 40,
                                          ),
                                          child: Center(
                                            child: _image == null
                                                ? const Text(
                                                    'Aucune image donné pour cette intervention.',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                : Image.file(_image!),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 40,
                                          ),
                                          child: InkWell(
                                            onTap: () => {_deletePicture()},
                                            child: Container(
                                              width: 260,
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color(0xFFff6b35),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons
                                                        .delete_right_fill,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: Text(
                                                      'Supprimer l\'image',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.calendar,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              DateFormat('dd/MM/yyyy HH:mm')
                                                  .format(
                                                DateTime.parse(
                                                    widget.intervention.date!),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.person_fill,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              "${widget.intervention.clientName}",
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.location_fill,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              "${widget.intervention.address}",
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) => SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: InterventionPopupWidget(
                                                intervention:
                                                    widget.intervention),
                                          ),
                                        );
                                      },
                                      child: widget
                                              .intervention.notes.isNotEmpty
                                          ? Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Notes",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: widget
                                                          .intervention
                                                          .notes
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Text(
                                                          widget
                                                              .intervention
                                                              .notes[index]
                                                              .text,
                                                          maxLines: 4,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Aucune note",
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              Container(
                width: double.infinity,
                height: 100,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: InterventionAddNotePopupWidget(
                                intervention: widget.intervention,
                              ),
                            ),
                          ).then((_) => _reload(widget.intervention.id!))
                        },
                        child: Container(
                          width: 130,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFff6b35),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                CupertinoIcons.plus,
                                color: Colors.white,
                                size: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Note',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _getImageFromCamera(),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFff6b35),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                CupertinoIcons.photo,
                                color: Colors.white,
                                size: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Photo',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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
