import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

import 'Provider/MultiSiteModeratorEntrySetProvider.dart';
import 'Provider/SitesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:interzone/world.dart';
import 'package:interzone/ModeratorSites.dart';

import 'navigation/NavWrapper.dart';
import '/sites/omasomeLoc.dart';
import 'p4p/nearbyPeerAdapter.dart';
import 'p4p/port_message.dart';
import 'package:typed_messages/typed_messages.dart';

Uint8List Uint64binaryList(List<int> d) {
  if (d.isEmpty) return Uint8List(0);
  int w = 0;
  Uint8List _l = Uint8List(128000);
  var b0 = new ByteData.view(_l.buffer);
  for (var id in d) {
    b0.setInt64(w, id);
    w += 8;
    if (w > _l.lengthInBytes) break;
  }
  return _l.sublist(0, w);
}

List<int> ListFromUint64binary(Uint8List data) {
  List<int> _l = [];
  if (data.isEmpty) return _l;
  var b = new ByteData.view(data.buffer);
  var w = 0;
  while (w < data.lengthInBytes) {
    _l.add(b.getInt64(w));
    w += 8;
  }
  return _l;
}

void main() async {
  MODERATOR_LOC molo = MODERATOR_LOC();
  print('Hello world!');
  String nick = molo.defaultVisitorNick;

  final HiveInterface db = Hive;
  await db.initFlutter();
  final interzoneDisk hid = interzoneDisk(db);

  final sites = ModeratorSites();
  sites.init(hid);

  await sites.followSite('omasome', 'https://omasome.fi', 'atac013', '🐼');
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
