import 'package:flutter/material.dart';
import 'package:mobile/models/intervention_model.dart';

class InterventionPopupWidget extends StatelessWidget {
  final InterventionModel intervention;

  const InterventionPopupWidget({Key? key, required this.intervention})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            "Notes",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: intervention.notes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        intervention.notes[index].text,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
