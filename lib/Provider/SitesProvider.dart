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
  Set<String> get followedSites {
    return source.followedSites;
  }

  Set<String> get followedSitesWithDefault {
    final fs = source.followedSites;
    if (fs.isEmpty) return {'https://moderator.rocks'};
    return fs;
  }

  String currentSite = 'https://moderator.rocks';
  Future<bool> switchSite(
      String name, String uri, String nick, String avatar) async {
    if (name.isEmpty && uri.isEmpty) {
      //assume we have a site we know of
      uri = source.followedSites.first;
    }
    bool a = await source.switchSite(name, uri, nick, avatar);
    if (a) {
      //REMOVE this hack
      source.setIpfsCredentials(
          '',
          'e94a2eba4b88b6e1d7a0',
          'e8f3357b3494fc48ac8b3baa8164a075e7bed86b675f06141e4ab0ceedf085ae',
          '');

      currentSite = uri;
      source.housekeep(); //save prefs
      smoothNotifyListeners();
    }
    return a;
  }

  Future<bool> followSite(
      String name, String uri, String nick, String avatar) async {
    bool a = await source.followSite(name, uri, nick, avatar);
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
    final t = await source.likeEntry(shortLink);
    if (t < 0) return false;
    source.outgoingMessageCacheSend(t);
    smoothNotifyListeners();
    return true;
  }

  Future<int> unlikeEntry(String shortLink) async {
    final t = await source.unlikeEntry(shortLink);
    source.outgoingMessageCacheSend(t);
    smoothNotifyListeners();
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
        .replyEntry(_currentThreadShortLink, replyText, pp, attachment, '')
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
        .postEntry(shortLink, text, attachment, '')
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

  ImageProvider readImageProvider(String site, int attachmentLinkAsXXint,
      String shortLink, String ipfsCid, String bHash) {
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
      smoothNotifyListeners();
      //return _bhaCache[bHash];
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
