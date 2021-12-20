import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
//import 'package:interzone/moderator/xxCache.dart';

import 'Provider/MultiSiteModeratorEntrySetProvider.dart';
import 'Provider/SitesProvider.dart';
import 'Provider/xxCacheProvider.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:interzone/world.dart';
import 'package:interzone/ModeratorSites.dart';

//import 'views/multipleEntryCard.dart';
//import 'views/ModeratorViewSettingsDefault.dart';
import 'navigation/NavWrapper.dart';
import '/sites/omasomeLoc.dart';

void main() async {
  MODERATOR_LOC molo = MODERATOR_LOC();
  print('Hello world!');
  String nick = molo.defaultVisitorNick;

  final HiveInterface db = Hive;
  await db.initFlutter();
  //db.init(molo.siteName + 'Data');
  final interzoneDisk hid = interzoneDisk(db);

  final sites = ModeratorSites();
  sites.init(hid);
  await sites.followSite('omasome', 'https://omasome.fi', 'majorllama');
  //await sites.followSite('clubchonky', 'https://club.chonky.rocks', 'chonky');

  //Directory appDocDir = await getApplicationDocumentsDirectory();
  //db.init(appDocDir.path);
  //db.init(path);
  /*world iz = world();
  iz.appSplashImage = molo.siteName;

  await iz.init(molo.siteUrl, molo.siteUrl, nick, hid);

  print(iz.nick);
  iz.primeCurrentViewWithCachedAttachments(iz.messages, 30);
  iz.scanForCachedAttachements(); //prime atts to pull
  iz.pullForCachedAttachements(); //pull first one
  */
  /*await iz.pullForCachedAttachements(); //pull first one
  await iz.pullForCachedAttachements(); //pull first one
  await iz.pullForCachedAttachements(); //pull first one
  await iz.pullForCachedAttachements(); //pull first one
  await iz.pullForCachedAttachements(); //pull first one
  await iz.pullForCachedAttachements(); //pull first one
  await iz.pullForCachedAttachements(); //pull first one */

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SitesProvider(sites)),
      ChangeNotifierProvider(
          create: (_) =>
              MultiSiteModeratorEntrySetProvider(sites.combinedEntrySet)),
      //ChangeNotifierProvider(
      //    create: (_) => xxCacheProvider(iz.xxC, iz.baseUrl)),
      ChangeNotifierProvider(
          create: (_) => BottomNavigationBarProvider('lomba')),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //final BottomNavigationBarProvider navi;
  /*StreamSubscription _intentDataStreamSubscription =
      ReceiveSharingIntent.getMediaStream().listen(
          (List<SharedMediaFile> value) {
    /*setState(() {
        print("Shared:" + (_sharedFiles?.map((f)=> f.path)?.join(",") ?? ""));
        _sharedFiles = value;
      });*/
  }, onError: (err) {
    print("getIntentDataStream error: $err");
  });*/

  // For sharing images coming from outside the app while the app is closed
  //  https://github.com/KasemJaffer/receive_sharing_intent

  MyApp();
  //final Widget? homePage;

  //final navi = BottomNavigationBarProvider();

  @override
  Widget build(BuildContext context) {
    final navi = context.watch<BottomNavigationBarProvider>();
    return ChangeNotifierProvider(
      create: (_) => navi,
      child: MaterialApp(
        title: 'atacama',
        home: NavWrapper(),
      ),
    );
  }
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CombinationPage(),
    );
  }
}*/
