import 'package:flutter/material.dart';

import 'package:mobile/models/intervention_model.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/services/intervention_service.dart';
import 'package:mobile/services/user_service.dart';

class InterventionCreatePopupWidget extends StatefulWidget {
  final List<UserModel> users;

  const InterventionCreatePopupWidget({Key? key, required this.users,}): super (key: key);

  @override
  InterventionCreatePopupWidgetState createState() => InterventionCreatePopupWidgetState();
}

class InterventionCreatePopupWidgetState extends State<InterventionCreatePopupWidget> {
  final InterventionService _interventionService = InterventionService();
  final UserService _userService = UserService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  String _selectedStatus = '';
  String? _selectedUser;

  String title = '';
  String description = '';
  String date = '';
  String address = '';
  String clientName = '';
  String status = '';
  UserModel? user;

  Future<void> _create(BuildContext context) async {
    title = _titleController.text.trim();
    description = _descriptionController.text.trim();
    date = _dateController.text.trim();
    address = _addressController.text.trim();
    clientName = _clientNameController.text.trim();
    status = _selectedStatus;

    if (_selectedUser != null) {
      user = await _userService.getUserById(_selectedUser!);
    }

    final InterventionModel intervention = InterventionModel(
      title: title,
      description: description,
      date: date,
      address: address,
      clientName: clientName,
      status: status,
      user: user,
      notes: [],
    );

    await _interventionService.create(intervention);
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
                  "Nouvelle intervention",
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
                      "Nom de l'intervention",
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
                        controller: _titleController,
                        decoration: const InputDecoration(
                            hintText: "Nom de l'intervention",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Description de l'intervention",
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
                        minLines: 3,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Description de l'intervention",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Date de l'intervention",
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
                      // DateFormat('dd/MM/yyyy HH:mm')
                      //     .format(
                      //   DateTime.parse(
                      //       intervention.date!),
                      // ),
                      child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFFff6b35),
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black, // body text color
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Color(0xFFff6b35),
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black, // body text color
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              DateTime pickedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              _dateController.text =
                                  pickedDateTime.toString().substring(0, 19);
                              // Format the date string
                            }
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Date de l\'intervention',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Adresse de l'intervention",
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
                        controller: _addressController,
                        decoration: const InputDecoration(
                            hintText: "Addresse de l'intervention",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Client de l'intervention",
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
                        controller: _clientNameController,
                        decoration: const InputDecoration(
                            hintText: "Client de l'intervention",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Statut de l'intervention",
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
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Choisir un status',
                          border: OutlineInputBorder(),
                        ),
                        value:
                            _selectedStatus.isNotEmpty ? _selectedStatus : null,
                        onChanged: (value) {
                          _selectedStatus = value!;
                        },
                        items: <String>["Active", "Inactive"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            key: UniqueKey(),
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Employé de l'intervention",
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
                      child: DropdownButtonFormField<String>(
                        value: _selectedUser,
                        decoration: const InputDecoration(
                          labelText: 'Choisir un utilisateur',
                          border: OutlineInputBorder(),
                        ),
                        items: widget.users
                            .map<DropdownMenuItem<String>>((UserModel user) {
                          return DropdownMenuItem<String>(
                            value: user.id,
                            child: Text('${user.firstName} ${user.lastName}'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          _selectedUser = newValue;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a user';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () => _create(context),
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 110),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFFff6b35),
                ),
                child: const Center(
                  child: Text(
                    "Créer",
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
