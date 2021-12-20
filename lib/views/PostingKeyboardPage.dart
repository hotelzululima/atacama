import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../navigation/NavWrapper.dart';
import 'package:provider/provider.dart';
import '../Provider/SitesProvider.dart';

import 'package:image_picker/image_picker.dart';

class PostingKeyboardPage extends StatefulWidget {
  @override
  _PostingKeyboardPageState createState() => _PostingKeyboardPageState();
}

class _PostingKeyboardPageState extends State<PostingKeyboardPage> {
  Uint8List? _pickedFile;

  @override
  Widget build(BuildContext context) {
    final sites = context.watch<SitesProvider>();
    //world.refreshThreadViaHTTP(mes.currentThreadRoot.shortLink);
    final navi = context.watch<BottomNavigationBarProvider>();
    final _focusNodeName = FocusNode();
    final _focusNodeQuantity = FocusNode();
    final size = MediaQuery.of(context).size;
    final myTextEditingController = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    bool _pushingData = false;
    String ipfsImageQueued = '';
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,

      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        
      ),*/
      appBar: AppBar(
        title: Text("Post new message"),
      ),
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
                    height: size.height / 3,
                    child: _pickedFile == null
                        ? IconButton(
                            icon: const Icon(Icons.attachment_outlined),
                            tooltip: 'Attach a picture to post',
                            onPressed: () async {
                              try {
                                final pickedFile = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  maxWidth: 640,
                                  maxHeight: 640,
                                  imageQuality: 72,
                                );
                                if (pickedFile != null) {
                                  pickedFile.readAsBytes().then((pp) {
                                    _pickedFile = pp;
                                    setState(() {
                                      _pickedFile = pp;
                                    });
                                  });
                                }
                                /*
                                if (pickedFile != null) {
                                  //navi.setUploadImage(pickedFile);
                                  pickedFile.readAsBytes().then((pp) {
                                    sites
                                        .pushToPinataIPFS('', pp)
                                        .then((value) {
                                      setState(() {
                                        ipfsImageQueued = value!;

                                        _pickedFile = pp;
                                      });
                                    });
                                  });
                                  //print(pickedFile.name);
                                }*/

                              } catch (e) {}

                              //_focusNodeName.requestFocus();
                            },
                          )
                        : Ink.image(
                            image: MemoryImage(_pickedFile!),
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                  SizedBox(
                    height: size.height / 13,
                    child: _pickedFile == null
                        ? Text(
                            'tap on the red clip icon to attach a photograph',
                            textAlign: TextAlign.center,
                          )
                        : null,
                  ),
                  /*TextField(
                    focusNode: _focusNodeName,
                    decoration: InputDecoration(
                      labelText: "Product Name",
                    ),
                  ),*/
                  TextFormField(
                    controller: myTextEditingController,
                    maxLength: 1000,
                    focusNode: _focusNodeQuantity,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText:
                          "your post here. use #hashtags @mention people at will",
                    ),
                    //initialValue: navi.postingKeyboardTextFormFieldSeed,
                    onEditingComplete: () {
                      print('edco');
                    },
                  ),
                  TextButton(
                    child: Text("submit post"),
                    //textColor: Colors.white,
                    //color: Colors.green,
                    onPressed: () async {
                      if (_pushingData) return;
                      if (myTextEditingController.text.isEmpty) return;
                      _pushingData = true;
                      //todo clean this page
                      final snackBar = SnackBar(
                        content: const Text(
                            'uploading message,this might take up to 20 seconds, hang on!'),
                        /*action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),*/
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Timer(const Duration(seconds: 4), () {
                        sites.refreshAllViaHTTP;
                        navi.closePostingKeyboardPage();
                      });
                      sites
                          .postEntry('', myTextEditingController.text,
                              _pickedFile != null ? _pickedFile! : Uint8List(0))
                          .then((value) {
                        //postEntry autoqueues so no worriez there
                      });

                      //sites.refreshAllViaHTTP();

                      /*if (sites.ipfsImageQueued) {
                        sites.postWithIpfsImage(
                            '', myTextEditingController.text, _pickedFile!);
                      } else {
                        
                      }*/

                      //navi.signal(AtacamaAction.viewAuthorThreads, '');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            //navi.signal(AtacamaAction.initPost, '');
            navi.closePostingKeyboardPage();
            /*final ImagePicker _picker = ImagePicker();
          // Pick an image
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          if (image == null) return;
          world.postWithImage('#buugi', await image.readAsBytes());*/
          },
          tooltip: 'close',
          child: Icon(Icons.close),
        ),
        visible: true,
      ),
    );
  } //build
}
