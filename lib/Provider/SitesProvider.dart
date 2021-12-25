import 'dart:async';
import 'dart:typed_data';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:interzone/ModeratorSites.dart';
import 'package:interzone/world.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:image/image.dart' as img;

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
    Timer(Duration(milliseconds: 600), () {
      notifyListeners();
      _notifying = false;
    });
  }

  String appSplashImage(String site) {
    world? w = source.findSite(site);
    if (w == null) return '';
    return w.appSplashImage;
  }

  String _currentThreadShortLink = '';
  void set currentThreadShortLink(String s) => _currentThreadShortLink = s;
  List<ModeratorEntry> get currentThread {
    return source.threadByShortLink(_currentThreadShortLink);
  }

  Future<bool> ShareEntry(ModeratorEntry m) async {
    String url = m.siteUrl + '/t' + m.shortLink;
    await Share.share(url,
        subject: '@' + source.nick + ' is thinking of you now');
    final t = source.shareEntry(m.shortLink);
    smoothNotifyListeners();
    return t;
  }

  Future<bool> MuteAuthor(String shortLink) {
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
  List<ModeratorEntry> threadByShortLink(String shortLink) {
    final t = source.threadByShortLink(shortLink);
    smoothNotifyListeners();
    return t;
  }

  List<ModeratorEntry> unreadThreadByShortLink(String shortLink) {
    //filter with read / unread
    final t = source.unreadThreadByShortLink(shortLink);

    return t;
  }

  Future<bool> setNick(String nick, String site) => source.setNick(nick, site);
  Future<bool> get refreshAllViaHTTP {
    final t = source.refreshAllViaHTTP;
    smoothNotifyListeners();
    return t;
  }

  Future<List<ModeratorEntry>?> replyEntry(
      String shortLink, String replyText, String pp) async {
    final t = source.replyEntry(shortLink, replyText, pp);
    smoothNotifyListeners();
    return t;
  }

  Future<bool> postEntry(
      String shortLink, String text, Uint8List attachment) async {
    final t = await source.postEntry(shortLink, text, attachment);
    if (t == null) return false;

    smoothNotifyListeners();
    return true;
  }

  List<ModeratorEntry> get xcombinedEntrySetAsList =>
      source.combinedEntrySet.all;
  List<ModeratorEntry> get xcombinedPostEntrySetAsList =>
      xcombinedEntrySetAsList.where((element) => element.flags.isPost).toList();

  List<ModeratorEntry> get latestThreadsAsList =>
      source.latestThreadsEntrySet.all;

  Map<int, MemoryImage> _images = {};
  Map<String, dynamic> _bhaCache = {};
  AssetImage pieru = AssetImage('assets/fetchingImagePlaceholder.png');
  ImageProvider readImageProvider(String site, int attachmentLinkAsXXint,
      String shortLink, String ipfsCid, String bHash) {
    if (_images[attachmentLinkAsXXint] != null) {
      return _images[attachmentLinkAsXXint]!;
    }
    source.pullIPFScid(ipfsCid, attachmentLinkAsXXint).then((value) async {
      if (value.isNotEmpty) {
        _images[attachmentLinkAsXXint] = MemoryImage(value);
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
}
