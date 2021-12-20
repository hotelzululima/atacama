import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:interzone/moderator/xxCache.dart';

import '../constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interzone/world.dart';

class xxCacheProvider with ChangeNotifier {
  xxCache source;
  String pullFromUrl;
  Map<String, Uint8List> _images = {};
  final Image _defAsset =
      Image(image: AssetImage('assets/fetchingImagePlaceholder.png'));
  //List<ModeratorEntry> _entriesList = source.all;

  Future<Uint8List?> xread(int xxInt, String shortLink) async {
    await source.pullXX(xxInt, shortLink, pullFromUrl);
  }

  bool _notifying = false;
  void smoothNotifyListeners() {
    if (_notifying) return;
    _notifying = true;
    Timer(Duration(milliseconds: 600), () {
      notifyListeners();
      _notifying = false;
    });
  }

  Image? read(int xxInt, String shortLink) {
    if (_images[shortLink] != null) return Image.memory(_images[shortLink]!);
    source.pullXX(xxInt, shortLink, pullFromUrl).then((img) {
      if (!img.isEmpty) {
        _images[shortLink] = img;
        smoothNotifyListeners();
      }
    });
    return _defAsset;
    /*Uint8List bb = await source.pullXX(shortLink, pullFromUrl);
    if (bb.isNotEmpty) {
      return Image.memory(bb);
    }
    return Image.memory(bb);*/
  }

  ImageProvider readImageProvider(int xxInt, String shortLink, String cid) {
    if (_images[shortLink] != null) {
      return MemoryImage(_images[shortLink]!);
    }
    /*source.pullXX(xxInt, shortLink, 'http://omasome.fi').then((img) {
      if (!img.isEmpty) {
        _images[shortLink] = img;
        notifyListeners();
      }
    });*/
    print(xxInt);
    print(cid);
    if (cid.isEmpty) {
      source.pullXX(xxInt, shortLink, pullFromUrl).then((img) async {
        if (!img.isEmpty) {
          _images[shortLink] = img;
          smoothNotifyListeners();
        } else {}
      });
    } else {
      source.pullXXifps(xxInt, shortLink, cid).then((img) async {
        if (!img.isEmpty) {
          _images[shortLink] = img;
          smoothNotifyListeners();
        } else {}
      });
    }
    return AssetImage('assets/fetchingImagePlaceholder.png');
  }

  xxCacheProvider(this.source, this.pullFromUrl);
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

  /*void deleteCountry(int index) {
    if (entriesList.length >= index) {
      entriesList.removeAt(index);
    }
    notifyListeners();
  }*/

  void getData() {
    print('dipr');
  }
}
