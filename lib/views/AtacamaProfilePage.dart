import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../navigation/NavWrapper.dart';
import 'package:provider/provider.dart';
import '../Provider/SitesProvider.dart';

import 'package:image_picker/image_picker.dart';

class AtacamaProfilePage extends StatefulWidget {
  @override
  _AtacamaProfilePageState createState() => _AtacamaProfilePageState();
}

class _AtacamaProfilePageState extends State<AtacamaProfilePage> {
  @override
  Widget build(BuildContext context) {
    final sites = context.watch<SitesProvider>();
    final navi = context.watch<BottomNavigationBarProvider>();
    final _focusNodeName = FocusNode();
    final _focusNodeQuantity = FocusNode();
    final size = MediaQuery.of(context).size;
    final myTextEditingController = TextEditingController(text: sites.nick);
    final ImagePicker _picker = ImagePicker();
    XFile? _pickedFile;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        child: Center(
          child: Theme(
            data: Theme.of(context).copyWith(
              disabledColor: Colors.blue,
              iconTheme: IconTheme.of(context).copyWith(
                color: Colors.red,
                size: 35,
              ),
            ),
            child: KeyboardActions(
              tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
              config: KeyboardActionsConfig(
                keyboardSeparatorColor: Colors.purple,
                actions: [
                  KeyboardActionsItem(
                    focusNode: _focusNodeName,
                  ),
                  KeyboardActionsItem(
                    focusNode: _focusNodeQuantity,
                  ),
                ],
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: size.height / 1.6,
                    child: Ink.image(
                      image: AssetImage('assets/moderatorSplash.jpeg'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  TextFormField(
                    controller: myTextEditingController,
                    maxLength: 10,
                    focusNode: _focusNodeQuantity,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "add your user handle here",
                    ),
                    onEditingComplete: () {
                      print('edco');
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: Text(
                      "I'm ready to go!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Uint8List upfile = Uint8List(0);
                      if (_pickedFile != null) {
                        upfile = await _pickedFile.readAsBytes();
                      }
                      if (myTextEditingController.text.isNotEmpty) {
                        sites.setNick(myTextEditingController.text, '');
                      }
                      //todo clean this page
                      navi.closeAtacamaProfilePage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } //build
}
