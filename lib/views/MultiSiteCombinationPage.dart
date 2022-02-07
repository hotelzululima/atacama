import 'dart:async';
import '../Provider/MultiSiteModeratorEntrySetProvider.dart';
import '../Provider/SitesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MultiSiteMultipleEntryCard.dart';
import 'MultiSiteMultipleMediaEntryCard.dart';

import 'ModeratorViewSettingsDefault.dart';
import '../navigation/NavWrapper.dart';
import '../actions/MessageActions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MultiSiteCombinationPage extends StatefulWidget {
  @override
  _MultiSiteCombinationPageState createState() =>
      _MultiSiteCombinationPageState();
}

class _MultiSiteCombinationPageState extends State<MultiSiteCombinationPage> {
  get _refreshIndicatorKey => null;
  bool _refreshingData = false;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    final sites = context.watch<SitesProvider>();
    final mes = context.watch<MultiSiteModeratorEntrySetProvider>();
    //final xxc = context.watch<xxCacheProvider>();
    final navi = context.watch<BottomNavigationBarProvider>();
    final allPostsFromAllSites = sites.latestThreadsAsList
        .where((element) => element.flags.isPost)
        .toList();
    /*final ju = Timer(Duration(milliseconds: 100), () {
      itemScrollController.scrollTo(
          index: navi.currentObservedPostIndex,
          duration: Duration(milliseconds: 300));
      //jumpTo(index: navi.currentObservedPostIndex);
    });*/
    Future<void> _handleRefresh() {
      sites.refreshAllViaHTTP; //world keeps track of multiple requests.
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

    return Scaffold(
      /*appBar: AppBar(
          //title: Text('Country'),
          ),*/

      body: mes.entriesList.length == 0
          ? Center(child: Text("No Data"))
          : Scrollbar(
              child: LiquidPullToRefresh(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                showChildOpacityTransition: false,
                child: ListView.builder(
                  itemCount: allPostsFromAllSites.length,

                  itemBuilder: (context, i) {
                    return allPostsFromAllSites[i].videoCid.isEmpty
                        ? MultiSiteMultipleEntryCard(
                            context,
                            allPostsFromAllSites[i],
                            mes,
                            mDebugFlags,
                            allPostsFromAllSites[i].flags.attachements
                                ? sites.readImageProvider(
                                    allPostsFromAllSites[i].siteUrl,
                                    allPostsFromAllSites[i]
                                        .attachmentLinkAsXXint,
                                    allPostsFromAllSites[i].shortLink,
                                    allPostsFromAllSites[i].ipfsCid,
                                    allPostsFromAllSites[i].blurHash)
                                : null,
                            navi,
                            sites,
                            i,
                            allPostsFromAllSites[i].siteUrl)
                        : MultiSiteMultipleMediaEntryCard(
                            context,
                            allPostsFromAllSites[i],
                            mes,
                            mDebugFlags,
                            allPostsFromAllSites[i].flags.attachements
                                ? sites.readMediaImageProvider(
                                    allPostsFromAllSites[i].siteUrl,
                                    allPostsFromAllSites[i]
                                        .attachmentLinkAsXXint,
                                    allPostsFromAllSites[i].shortLink,
                                    allPostsFromAllSites[i].ipfsCid,
                                    allPostsFromAllSites[i].blurHash,
                                    allPostsFromAllSites[i].videoCid,
                                    allPostsFromAllSites[i].audioCid)
                                : null,
                            navi,
                            sites,
                            i,
                            allPostsFromAllSites[i].siteUrl);
                  },
                  //itemScrollController: itemScrollController,
                  //itemPositionsListener: itemPositionsListener,
                ),
              ),
            ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            navi.signal(AtacamaAction.initPost, '');
            /*final ImagePicker _picker = ImagePicker();
          // Pick an image
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          if (image == null) return;
          world.postWithImage('#buugi', await image.readAsBytes());*/
          },
          tooltip: 'add post',
          child: Icon(Icons.post_add),
        ),
        visible: navi.keyboard == 0,
      ),
    );
  }
}
