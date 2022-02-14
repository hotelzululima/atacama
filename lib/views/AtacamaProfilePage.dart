import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../navigation/NavWrapper.dart';
import 'package:provider/provider.dart';
import '../Provider/SitesProvider.dart';

import 'components/viewHelpersFlutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
    final myAvatarTextEditingController =
        TextEditingController(text: sites.avatar);

    final ImagePicker _picker = ImagePicker();
    final avvy = avatarCarouselSlider(sites.avatar);
    String _avatar = sites.avatar;
    String _nick = sites.nick;
    String _selectedSite = '';
    final acomu = Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        // When the field is empty
        if (value.text.isEmpty) {
          return [];
        }
        _selectedSite = value.text;
        // The logic to find out which ones should appear
        return sites.followedSitesWithDefault.where((suggestion) =>
            suggestion.toLowerCase().contains(value.text.toLowerCase()));
      },
      onSelected: (value) async {
        /*if (sites.followedSites.contains(value)) {
          await sites
              .switchSite(
                  '', value, myTextEditingController.value.text, _avatar)
              .then((v2) {
            setState(() {});
          });
        } else { */
        await sites
            .followSite('', value, myTextEditingController.value.text, _avatar)
            .then((v2) {
          if (v2) {
            sites.switchSite(
                '', value, myTextEditingController.value.text, _avatar);
          }
          setState(() {});
        });

        /*setState(() {
                _selectedAnimal = value;
              });*/
      },
    );
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
                      height: size.height / 3.6,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 400.0,
                          onPageChanged: (index, reason) {
                            //set avatarus
                            _avatar = avatarAvailableList(sites.avatar)[index];
                          },
                        ),
                        items: avvy.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration:
                                      BoxDecoration(color: Colors.amber),
                                  child: i);
                            },
                          );
                        }).toList(),
                      )),
                  Text('swipe to change your avatar',
                      style: TextStyle(fontSize: 18.0)),
                  TextFormField(
                    controller: myTextEditingController,
                    maxLength: 10,
                    focusNode: _focusNodeQuantity,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 16.0),
                      labelText: "add your user handle here",
                    ),
                    onEditingComplete: () {
                      print('edco');
                    },
                  ),
                  acomu,
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

                      await sites
                          .followSite(
                              '',
                              _selectedSite.isEmpty
                                  ? sites.currentSite
                                  : _selectedSite,
                              myTextEditingController.text,
                              _avatar)
                          .then((value) async {
                        if (value)
                          await sites.switchSite(
                              '',
                              _selectedSite.isEmpty
                                  ? sites.currentSite
                                  : _selectedSite,
                              myTextEditingController.text,
                              _avatar);
                      });

                      /*if (sites.homeSite == null) {
                        await sites.switchSite(_selectedSite, '',
                            myTextEditingController.text, _avatar);
                      }*/
                      if (myTextEditingController.text.isNotEmpty) {
                        sites.setNickAvatar(
                            myTextEditingController.text, _avatar, '');
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
