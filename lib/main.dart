import 'package:hive_flutter/hive_flutter.dart';

import 'Provider/MultiSiteModeratorEntrySetProvider.dart';
import 'Provider/SitesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:interzone/world.dart';
import 'package:interzone/ModeratorSites.dart';

import 'navigation/NavWrapper.dart';
import '/sites/omasomeLoc.dart';

void main() async {
  MODERATOR_LOC molo = MODERATOR_LOC();
  print('Hello world!');
  String nick = molo.defaultVisitorNick;

  final HiveInterface db = Hive;
  await db.initFlutter();
  final interzoneDisk hid = interzoneDisk(db);

  final sites = ModeratorSites();
  sites.init(hid);
  //await sites.followSite(
  //    'omasome', 'https://moderator.rocks', 'atacomer', '🐼');

  await sites.followSite('omasome', 'https://omasome.fi', 'atac012', '🐼');
  //await sites.followSite('chonky', 'https://chonky.rocks', 'wonky');

  sites.setIpfsCredentials('', 'e94a2eba4b88b6e1d7a0',
      'e8f3357b3494fc48ac8b3baa8164a075e7bed86b675f06141e4ab0ceedf085ae', '');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SitesProvider(sites)),
      ChangeNotifierProvider(
          create: (_) =>
              MultiSiteModeratorEntrySetProvider(sites.latestThreadsEntrySet)),
      ChangeNotifierProvider(
          create: (_) => BottomNavigationBarProvider('lomba')),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // For sharing images coming from outside the app while the app is closed
  //  https://github.com/KasemJaffer/receive_sharing_intent

  MyApp();

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
