import 'dart:typed_data';
import 'dart:async';
import 'package:interzone/moderator/xxCache.dart';
import 'package:interzone/world.dart';
import '../Provider/MultiSiteModeratorEntrySetProvider.dart';
import '../Provider/SitesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MultiSiteSingleThreadCard.dart';
import 'ModeratorViewSettingsDefault.dart';
import '../navigation/NavWrapper.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MultiSiteThreadPage extends StatefulWidget {
  @override
  _MultiSiteThreadPageState createState() => _MultiSiteThreadPageState();
}

class _MultiSiteThreadPageState extends State<MultiSiteThreadPage> {
  get _refreshIndicatorKey => null;
  bool _refreshingData = false;
  bool _replied = false;
  @override
  Widget build(BuildContext context) {
    final sites = context.watch<SitesProvider>();
    final mes = context.watch<MultiSiteModeratorEntrySetProvider>();
    //world.refreshThreadViaHTTP(mes.currentThreadRoot.shortLink);
    final navi = context.watch<BottomNavigationBarProvider>();
    final myTextEditingController = TextEditingController();
    final currentThread = sites.currentThread;

    Future<void> _handleRefresh() async {
      await sites.refreshAllViaHTTP; //world keeps track of multiple requests.
      mes.refresh();
      final Completer<void> completer = Completer<void>();
      Timer(const Duration(seconds: 3), () {
        _refreshingData = false;
        completer.complete();
      });
      return completer.future.then<void>((_) {
        print('dild');
      });
      /*setState(() {
      refreshNum = new Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState!.show();
              })));
    });*/
    }

    final _focusNodeName = FocusNode();
    final _focusNodeQuantity = FocusNode();
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          /*appBar: AppBar(
          //title: Text('Country'),
          ),*/
          body: Column(
            children: <Widget>[
              currentThread.length == 0
                  ? Center(child: Text("No Data"))
                  : Expanded(
                      child: Scrollbar(
                          child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: currentThread.length,
                      itemBuilder: (context, i) {
                        return MultiSiteSingleThreadCard(
                            currentThread[i],
                            mes,
                            mDebugFlags,
                            currentThread[i].flags.attachements
                                ? sites.readImageProvider(
                                    currentThread[i].siteUrl,
                                    currentThread[i].attachmentLinkAsXXint,
                                    currentThread[i].shortLink,
                                    currentThread[i].ipfsCid,
                                    currentThread[i].blurHash)
                                : null,
                            navi,
                            sites,
                            i);
                      },
                    ))),
              //Expanded(
              //alignment: Alignment.bottomLeft,
              Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Visibility(
                    visible: !_replied,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: myTextEditingController,
                            maxLength: 1000,
                            focusNode: _focusNodeQuantity,
                            keyboardType: TextInputType.text,

                            /*decoration: InputDecoration(
                      labelText:
                          "your post here. use #hashtags @mention people at will",
                    ),*/
                            //initialValue: navi.postingKeyboardTextFormFieldSeed,
                            onEditingComplete: () async {
                              if (myTextEditingController.text.isEmpty) return;
                              _replied = true;
                              final String reps = myTextEditingController.text;

                              myTextEditingController.clear();
                              myTextEditingController.clearComposing();
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (currentFocus != null) {
                                currentFocus.unfocus();
                              }
                              await sites.replyEntry(
                                  sites.currentThread.first.shortLink,
                                  reps,
                                  sites.currentThread.last.shortLink);
                              /*await sites.replyToPost(
                                  currentThread
                                      .where((element) => element.flags.isPost)
                                      .first
                                      .siteUrl,
                                  reps,
                                  currentThread);*/
                            },
                          ),
                          /*
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),*/
                        ),
                        /*FloatingActionButton(
                  onPressed: () async {
                    if (myTextEditingController.text.isEmpty) return;
                    await world.replyToPost(
                        myTextEditingController.text, mes.currentThread);
                    await world
                        .refreshThreadViaHTTP(mes.currentThreadRoot.shortLink);
                    myTextEditingController.clear();
                    myTextEditingController.clearComposing();
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (currentFocus.hasPrimaryFocus != null) {
                      currentFocus.unfocus();
                    }

                    //navi.closeMultiSiteThreadPage();
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                )*/
                      ],
                    )),
              ),
              //),
            ],
          ),
          floatingActionButton: Visibility(
            child: FloatingActionButton(
              onPressed: () {
                //navi.signal(AtacamaAction.initPost, '');
                navi.closeMultiSiteThreadPage();
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
            visible: navi.keyboard == 0,
          ),
        ));
  }
}
