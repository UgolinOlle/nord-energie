import 'package:flutter/material.dart';

import 'package:mobile/models/intervention_model.dart';
import 'package:mobile/services/intervention_service.dart';

class InterventionAddNotePopupWidget extends StatefulWidget {
  final InterventionModel intervention;

  const InterventionAddNotePopupWidget({
    Key? key,
    required this.intervention,
  }) : super(key: key);

  @override
  InterventionAddNotePopupWidgetState createState() => InterventionAddNotePopupWidgetState();
}

class InterventionAddNotePopupWidgetState extends State<InterventionAddNotePopupWidget> {
  final InterventionService _interventionService = InterventionService();
  final TextEditingController _noteContent = TextEditingController();

  Future _addNote(BuildContext context, String id) async {
    var content = _noteContent.text.trim();

    await _interventionService.addNote(id, content);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Ajouter une note",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Contenu de la note",
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(225, 95, 27, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _noteContent,
                        minLines: 3,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            hintText: "Contenu de la note",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () => _addNote(context, widget.intervention.id!),
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 110),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFFff6b35),
                ),
                child: const Center(
                  child: Text(
                    "Ajouter",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
