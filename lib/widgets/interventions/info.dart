import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mobile/models/intervention_model.dart';

class InterventionInfoPopupWidget extends StatelessWidget {
  late final InterventionModel intervention;

  InterventionInfoPopupWidget({
    Key? key,
    required this.intervention,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    intervention.title,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Text(
                            intervention.description,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 40,
                              ),
                              child: Center(
                                child: intervention.picture == null
                                    ? const Text(
                                        'Aucune image donné pour cette intervention.',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      )
                                    : Image(
                                        image:
                                            NetworkImage(intervention.picture!),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                CupertinoIcons.calendar,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  DateFormat('dd/MM/yyyy HH:mm').format(
                                    DateTime.parse(intervention.date!),
                                  ),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                CupertinoIcons.person_fill,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "${intervention.clientName}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                CupertinoIcons.location_fill,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "${intervention.address}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        intervention.notes.isNotEmpty
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Notes",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: intervention.notes.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Text(
                                            intervention.notes[index].text,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 16),
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
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
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
    );
  }
}
