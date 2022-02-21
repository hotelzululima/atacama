import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:peer_node_connection/peer_node_connection.dart';
import '../p4p/peerAdapter.dart';
import '../p4p/port_message.dart';

import 'package:flutter/material.dart';

import 'package:interzone/ModeratorSites.dart';
import 'package:interzone/world.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:image/image.dart' as img;
import 'package:udp/udp.dart';

import 'package:share_plus/share_plus.dart';

class SitesProvider with ChangeNotifier {
  ModeratorSites source;
  StreamSubscription _intentDataStreamSubscription =
      ReceiveSharingIntent.getMediaStream().listen(
          (List<SharedMediaFile> value) {
    print(
        'SitesProvider StreamSubscription _intentDataStreamSubscription received');
    value.forEach((element) {
      print(element.type);
    });
    //print("Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
    //_sharedFiles = value;
  }, onError: (err) {
    print("getIntentDataStream error: $err");
  });
  SitesProvider(this.source);
  dynamic get allSites => source.allSites;
  Set<String> get followedSites {
    return source.followedSites;
  }

  bool get isPrimed => source.isPrimed;
  UDP? _sender;
  UDP? _receiver;
  Endpoint? _multicastEndpoint;
  Set<String> _existingPeers = {};
  void udp() async {
    /*var sender = await UDP.bind(Endpoint.any(port: Port(65000)));

    // send a simple string to a broadcast endpoint on port 65001.
    var dataLength = await sender.send(
        "Hello World!".codeUnits, Endpoint.broadcast(port: Port(54321)));

    print("$dataLength bytes sent.");
*/
    // creates a new UDP instance and binds it to the local address and the port
    // 65002.
    /*var receiver = await UDP.bind(Endpoint.loopback(port: Port(65002)));

    // receiving\listening
    receiver.asStream(timeout: Duration(seconds: 20)).listen((datagram) {
      if (datagram != null) {
        var str = String.fromCharCodes(datagram.data);
        print(str);
      }
    });

    // close the UDP instances and their sockets.
    sender.close();
    receiver.close();*/

    // MULTICAST
    _multicastEndpoint =
        Endpoint.multicast(InternetAddress("224.0.0.1"), port: Port(54321));

    _receiver = await UDP.bind(_multicastEndpoint!);

    _sender = await UDP.bind(Endpoint.any());

    _receiver!.asStream().listen((datagram) {
      if (datagram != null) {
        print(datagram.address.address);
        if (!_existingPeers.contains(datagram.address.address)) {
          var b = new ByteData.view(datagram.data.buffer);
          final por = b.getUint64(0);
          if (por != node.port) {
            node.addPeer(Peer(datagram.address, por));
            _existingPeers.add(datagram.address.address);
            final su = node
                .sendMessage(PortMessage(por, 1, 0, source.outgoingCapsule));
            print(su);
          }
        } else {
          print('exha');
        }
      }
    });
    final pr = Uint8List(8)
      ..buffer.asByteData().setInt64(0, node.port, Endian.big);
    _sender?.send(pr, _multicastEndpoint!).then((value) {
      print(value.toString());
    });
  }

  // create a new peer node
  final node = Node();
  void p4pinit() {
    // create a new peer node

    PortMessage p4pOnConnect(PortMessage message) {
      return PortMessage(message.port, 1, 0, source.outgoingCapsule);
    }

    Future<PortMessage> p4pOnMessage(PortMessage message) async {
      switch (message.type) {
        case 0:
          //request for xx data
          return await source.incomingCapsule(message.data).then((value) async {
            if (value.isNotEmpty) {
              return PortMessage(message.port, 2, 0, value);
            }
            return PortMessage(0, 99, 0, Uint8List(0));
          });
          break;
        case 1:
          return await source.incomingCapsule(message.data).then((value) async {
            if (value.isNotEmpty) {
              return PortMessage(message.port, 2, 0, value);
            }
            return PortMessage(0, 99, 0, Uint8List(0));
          });

          break;
        case 2:
          return await source
              .incomingCapsuleXXdata(message.data)
              .then((value) async {
            /*if (value.isNotEmpty) {
              return PortMessage(message.port, 2, 0, value);
            }*/
            return PortMessage(0, 99, 0, Uint8List(0));
          });
        //satisfy xxs
        /*sites.injectXX(message.xx, message.data);
        //ask for more
        final Uint8List t = sites.xxWants;
        if (t.isNotEmpty) {
          return PortMessage(message.port, 1, 0, t);
        }
        break;*/
      }

      return PortMessage(0, 99, 0, Uint8List(0));
    }

    peerAdapterInit(node, p4pOnConnect, p4pOnMessage);
  }

  bool _p4pPrimed = false;
  bool prime() {
    if (!source.isPrimed) {
      source.followSite('', currentSite, 'guest', '🐑').then((value) => {
            source.switchSite('', currentSite, 'guest', '🐑').then((value) {
              if (!_p4pPrimed) {
                //defer this
                p4pinit();
                udp();
                _p4pPrimed = true;
              }
              smoothNotifyListeners();
            })
          });
    }

    return source.isPrimed;
  }

  Set<String> get followedSitesWithDefault {
    final fs = source.followedSites;
    if (fs.isEmpty) return {currentSite};
    return fs;
  }

  String currentSite = 'https://omasome.rocks';
  Future<bool> switchSite(
      String name, String uri, String nick, String avatar) async {
    if (name.isEmpty && uri.isEmpty) {
      //assume we have a site we know of
      uri = source.followedSites.first;
    }
    bool a = await source.switchSite(name, uri, nick, avatar);
    smoothNotifyListeners();
    if (a) {
      //REMOVE this hack
      source.setIpfsCredentials(
          '',
          'e94a2eba4b88b6e1d7a0',
          'e8f3357b3494fc48ac8b3baa8164a075e7bed86b675f06141e4ab0ceedf085ae',
          '');

      currentSite = uri;
      source.housekeep(); //save prefs

    }
    return a;
  }

  Future<bool> followSite(
      String name, String uri, String nick, String avatar) async {
    bool a = await source.followSite(name, uri, nick, avatar);
    smoothNotifyListeners();
    if (a) {
      currentSite = uri;
      source.housekeep(); //save prefs
      smoothNotifyListeners();
    }
    return a;
  }

  dynamic get homeSite => source.homeSite;
  /*void getData() async {
    http.Response response = await http.get(Constants.apiEndpoint);
    var data = jsonDecode(response.body);
    _countryList = List<CountryModel>();
    for (var country in data) {
      _countryList.add(CountryModel.fromMap(country));
    }
    notifyListeners();
  }
  */
  bool _notifying = false;
  void smoothNotifyListeners() {
    if (_notifying) return;
    _notifying = true;
    Timer(Duration(milliseconds: 800), () {
      notifyListeners();

      //save whatever
      source.housekeep();
      _notifying = false;
    });
  }

  ImageProvider get siteSplashImage {
    return llaama;
    //return cholo;
    final h = source.homeSite?.LatestThreads.all.last;
    if (h == null) {
      return llaama;
    }
    return readImageProvider(source.homeSite!.siteName, h.attachmentLinkAsXXint,
        h.shortLink, h.ipfsCid, h.blurHash);
  }

  String _currentThreadShortLink = '';
  void set currentThreadShortLink(String s) => _currentThreadShortLink = s;
  List<ModeratorEntry> get currentThread {
    return source.threadByShortLink(_currentThreadShortLink);
  }

  Future<bool> ShareEntry(ModeratorEntry m) async {
    //final w = source.findSite(m.siteUrl);
    final w = source.homeSite;
    if (w == null) return false;

    String url = w.baseUrl + '/t/' + m.shortLink;
    await Share.share(url);
    final t = source.shareEntry(m.shortLink);
    smoothNotifyListeners();
    return t;
  }

  Future<bool> LikeEntry(String shortLink) async {
    if (source.isLikedOmni(shortLink)) return false;

    final t = await source.likeEntry(shortLink);
    if (t < 0) return false;
    source.outgoingMessageCacheSend(t).then((value) {
      notifyListeners();
    });

    return true;
  }

  Future<int> unlikeEntry(String shortLink) async {
    if (!source.isLikedOmni(shortLink)) return -1;

    final t = await source.unlikeEntry(shortLink);
    source.outgoingMessageCacheSend(t).then((value) {
      notifyListeners();
    });
    return t;
  }

  Future<int> MuteAuthor(String shortLink) {
    final t = source.muteAuthor(shortLink);
    smoothNotifyListeners();
    return t;
  }

  Future<bool> DropEntry(String shortLink) {
    final t = source.dropEntry(shortLink);
    smoothNotifyListeners();
    return t;
  }

  String get nick => source.nick;
  String get avatar => source.avatar;
  List<ModeratorEntry> threadByShortLink(String shortLink) {
    //source.refreshThread(shortLink);
    return source.threadByShortLink(shortLink);
  }

  List<ModeratorEntry> unreadThreadByShortLink(String shortLink) {
    //filter with read / unread
    final t = source.unreadThreadByShortLink(shortLink);

    return t;
  }

  Future<bool> setNickAvatar(String nick, String avatar, String site) =>
      source.setNickAvatar(nick, avatar, site);
  Future<bool> get refreshAllViaHTTP {
    //if connection was lost, try to get it up again
    source.setOnline();
    final t = source.refreshAllViaHTTP;
    //send pending items if we have some
    source.outgoingMessageCacheSend(0);

    final su =
        node.sendMessage(PortMessage(node.port, 1, 0, source.outgoingCapsule));
    print(su);

    smoothNotifyListeners();
    return t;
  }

  Future<List<ModeratorEntry>?> refreshThreadViaHTTP(String shortLink) async {
    //source.refreshThread(shortLink);
    return await source.refreshThread(shortLink).then((data) {
      if (data != null && data.isNotEmpty) smoothNotifyListeners();
      return data;
    });
  }

  Future<List<ModeratorEntry>?> refreshTaggedViaHTTP(String shortLink) async {
    final t = source.refreshTagged(shortLink).then((data) {
      if (data != null && data.isNotEmpty) smoothNotifyListeners();
      return data;
    });
  }

  Future<List<ModeratorEntry>?> refreshAuthorViaHTTP(String shortLink) async {
    return source.refreshAuthor(shortLink).then((data) {
      if (data != null && data.isNotEmpty) smoothNotifyListeners();
      return data;
    });
  }

  Future<List<ModeratorEntry>?> replyEntry(
      String replyText, String pp, Uint8List attachment) async {
    return source
        .replyEntry(_currentThreadShortLink, replyText, pp, attachment, '', 0)
        .then((data) {
      if (data < 0) return [];
      return source.outgoingMessageCacheSend(data).then((data) {
        smoothNotifyListeners();
        return data;
      });
    });
  }

  Future<List<ModeratorEntry>?> postEntry(
      String shortLink, String text, Uint8List attachment) async {
    return await source
        .postEntry(shortLink, text, attachment, '', 0)
        .then((data) async {
      //if (data < 0) return [];
      return await source.outgoingMessageCacheSend(data).then((dara) {
        smoothNotifyListeners();
        return dara;
      });
    });
  }

  List<ModeratorEntry> get xcombinedEntrySetAsList =>
      source.combinedEntrySet.all;
  List<ModeratorEntry> get xcombinedPostEntrySetAsList =>
      xcombinedEntrySetAsList.where((element) => element.flags.isPost).toList();

  List<ModeratorEntry> get latestThreadsAsList =>
      source.latestThreadsEntrySet.all;
  List<ModeratorEntry> get latestThreadsAsListHomeSite =>
      source.HomeSiteLatestThreadsEntrySet.all;
  Map<int, MemoryImage> _images = {};
  Map<String, dynamic> _bhaCache = {};
  AssetImage pieru = AssetImage('assets/fetchingImagePlaceholder.png');
  AssetImage llaama = AssetImage('assets/atacamallama.jpg');
  AssetImage cholo = AssetImage('assets/clubchonky.jpg');

  ImageProvider readImageProvider(String site, int attachmentLinkAsXXint,
      String shortLink, String ipfsCid, String bHash) {
    //var multicastEndpoint =
    //    Endpoint.multicast(InternetAddress("239.1.2.3"), port: Port(54321));
//"FooGnidrolog\n"

    if (_images[attachmentLinkAsXXint] != null) {
      return _images[attachmentLinkAsXXint]!;
    }
    source.pullIPFScid(ipfsCid, attachmentLinkAsXXint).then((value) async {
      if (value.isNotEmpty) {
        _images[attachmentLinkAsXXint] = MemoryImage(value);
        //dont need blurhash anymore
        //_bhaCache.remove(bHash);
        smoothNotifyListeners();
      }
    });

    if (bHash.isNotEmpty) {
      if (_bhaCache[bHash] != null) return _bhaCache[bHash];
      final bim = BlurHash.decode(bHash).toImage(42, 42);
      final bia = Image.memory(Uint8List.fromList(img.encodeJpg(bim)));
      _bhaCache[bHash] = bia.image;
      //smoothNotifyListeners();
      return _bhaCache[bHash];
    }

    return pieru;
  }

  ImageProvider readMediaImageProvider(
      String site,
      int attachmentLinkAsXXint,
      String shortLink,
      String ipfsCid,
      String bHash,
      String videoCid,
      String audioCid) {
    //we dont want to trigger pulls to large media
    if (_images[attachmentLinkAsXXint] != null) {
      return _images[attachmentLinkAsXXint]!;
    }
    source.pullIPFScid(ipfsCid, attachmentLinkAsXXint).then((value) async {
      if (value.isNotEmpty) {
        _images[attachmentLinkAsXXint] = MemoryImage(value);
        smoothNotifyListeners();
      }
    });

    if (bHash.isNotEmpty) {
      if (_bhaCache[bHash] != null) return _bhaCache[bHash];
      final bim = BlurHash.decode(bHash).toImage(35, 20);
      final bia = Image.memory(Uint8List.fromList(img.encodeJpg(bim)));
      _bhaCache[bHash] = bia.image;
      return _bhaCache[bHash];
    }

    return pieru;
  }

  bool markSeen(String shortLink) => source.markSeenOmni(shortLink);

  int get ipfsQflushFailed => source.ipfsQflushFailed;
  get setOnline => source.setOnline();
  get setOffline => source.setOffline();
  get online => source.online;
}
