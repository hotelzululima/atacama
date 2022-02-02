import 'dart:io';
import 'dart:typed_data';
import 'package:interzone/disk.dart';
import 'package:process_run/shell.dart';
import 'package:interzone/interop/xxhash/lib/fast_hash.dart';
import 'dart:math';
import 'dart:async';
import 'dart:isolate';
import 'package:peer_node_connection/peer_node_connection.dart';

class xxCache {
  Map<int, Uint8List> _xxStash = {};
  Map<int, Uint8List> get xxStash => _xxStash;
  int get now => DateTime.now().millisecondsSinceEpoch;
  interzoneDisk? _io;
  int get dataPulledDisk => _io!.dataPulledDisk;
  int get dataPushedDisk => _io!.dataPushedDisk;

  int dataPulledIPFS = 0;
  bool _busy = false;
  bool get isBusy {
    return _busy;
  }

  bool online = true;
  void setOnline() => online = true;
  void setOffline() => online = false;

  Future<void> init(interzoneDisk io) async {
    _io = io;
    // MULTICAST
  }

  Uint8List get wantsBinary {
    if (_diskMissing.isEmpty) return Uint8List(0);
    int w = 0;
    Uint8List _l = Uint8List(128);
    var b0 = new ByteData.view(_l.buffer);
    List<int> dmi = _diskMissing.toList();
    dmi.shuffle();
    final t = dmi.sublist(0, 1);
    for (var id in t) {
      b0.setUint64(w, id);
      w += 8;
      if (w > _l.lengthInBytes) break;
    }
    return _l.sublist(0, w);
  }

  Future<bool> pushCidData(String cid, Uint8List data) async {
    return await _io!.commitCid(data, cid);
  }

  bool isXXcached(int xxInt) {
    /*List<int> xx = root.attachment.sublist(
        root.attachment.lengthInBytes - 8, root.attachment.lengthInBytes);
    String xxi = HEX.encode(xx);*/
    if (_xxStash[xxInt] != null) return true;
    return false;
  }

  bool _pulling = false;
  Set<int> _xxWants = {};
  Set<int> _diskFetch = {};
  Set<int> _diskMissing = {};

  Future<bool> pushXXbytes(int xxInt, Uint8List data, bool ghostMode) async {
    if (_xxStash[xxInt] != null) return false;
    _xxStash[xxInt] = data;
    _diskMissing.remove(xxInt);
    return true;
  }

  Future<Uint8List> pullXX(
      int xxInt, String shortLink, String pullFromUrl) async {
    //List<int> xx = attachment.sublist(attachment.length - 8, attachment.length);
    //String xxi = HEX.encode(xx);
    //if (_xxStash[xxInt] != null) return _xxStash[xxInt]!;
    //if (!molo.ghostMode) {
    //final value = _io?.readXX(xxInt.toString());
    //if (value != null) return value;
    return Uint8List(0);
/*
    if (!_diskFetch.contains(xxInt)) {
      _diskFetch.add(xxInt);
      try {
        var value = _io?.readXX(xxInt).then((value) {
          if (value != null) {
            if (value.isNotEmpty) {
              _xxWants.remove(xxInt);
              _diskFetch.remove(xxInt);
              _diskMissing.remove(xxInt);
              _xxStash[xxInt] = value.buffer.asUint8List();
              return _xxStash[xxInt]!;
            }
          }
        });

        _diskMissing.add(xxInt);
        return Uint8List(0);
        //});
      } catch (e) {
        //return null;
        _pulling = 0;
      }
      return Uint8List(0); //dont do disk check twice
    }

    if (_xxWants.contains(xxInt)) {
      //dont allow multi reqs for the same item
      return Uint8List(0);
    }

    _xxWants.add(xxInt);

    /*if (_pulling == 0) {
      _pulling = now;
    } else {
      if (now - _pulling < 500) {
        return Uint8List(0);
      }
      _pulling = now;
    }*/
    bool pl = false;
    if (shortLink.isEmpty) return Uint8List(0);
    Random rnd = new Random();
    var r = 50 + rnd.nextInt(500 - 100);

    HttpClient()
        .getUrl(Uri.parse(
            pullFromUrl + '/xx/' + shortLink)) // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) async {
      //print(response.toString());
      //var rp = await response.toList();
      //print(utf8.decode(rp[0]));
      if (response.statusCode == 200) {
        final rp = await response.toList();
        if (rp.isEmpty) {
          _pulling = 0;
          return;
        }
        Uint8List r = Uint8List(1000000);
        int ff = 0;
        for (var i in rp) {
          for (var ii in i) {
            r[ff++] = ii;
          }
          _xxStash[xxInt] = r.sublist(0, ff);
          _io?.commitXX(r.sublist(0, ff), xxInt);
          _xxWants.remove(xxInt);
          if (_pulling > 0) {
            _pulling = 0;
          }
        }
      } else {
        if (_pulling > 0) {
          _pulling = 0;
        }
      }
    });

    return Uint8List(0);
  */
    //response.transform(Utf8Decoder()).listen(print)); //
  }

  Set<int> _pullingXIP = {};
  Future<Uint8List> pullXXifps(int xxInt, String shortLink, String cid) async {
    //List<int> xx = attachment.sublist(attachment.length - 8, attachment.length);
    //String xxi = HEX.encode(xx);
    //if (_xxStash[xxInt] != null) return _xxStash[xxInt]!;
    //if (!molo.ghostMode) {
    if (_pullingXIP.contains(xxInt)) return Uint8List(0);
    _pullingXIP.add(xxInt);
    final value = _io?.readCid(
        cid); /*.then((value) {
          if (value != null) {
            if (value.isNotEmpty) {
              _xxWants.remove(xxInt);
              _diskFetch.remove(xxInt);
              _xxStash[xxInt] = value.buffer.asUint8List();
              return _xxStash[xxInt]!;
            }
          } else {
            return pullCidFromIPFS(cid, xxInt);
          }
        });*/
    if (value != null) {
      _pullingXIP.remove(xxInt);
      return value;
    }

    broadcastXXwantOverUDP(xxInt);

    pullCidFromIPFS(cid, xxInt).then((value) {
      _pullingXIP.remove(xxInt);
      //puts in the xxcache
    });
    return Uint8List(0);
/*
    if (!_diskFetch.contains(xxInt)) {
      _diskFetch.add(xxInt);
      try {
        var value = await _io?.readXX(xxInt).then((value) {
          if (value != null) {
            if (value.isNotEmpty) {
              _xxWants.remove(xxInt);
              _diskFetch.remove(xxInt);
              _xxStash[xxInt] = value.buffer.asUint8List();
              return _xxStash[xxInt]!;
            }
          } else {
            return pullCidFromIPFS(cid, xxInt);
          }
        });
        //return Uint8List(0);
        //});
      } catch (e) {
        //return null;
        return pullCidFromIPFS(cid, xxInt);
      }
    }

    return pullCidFromIPFS(cid, xxInt);

    if (_xxWants.contains(xxInt)) {
      //dont allow multi reqs for the same item

      return Uint8List(0);
    }
*/
    _xxWants.add(xxInt);

    /*if (_pulling == 0) {
      _pulling = now;
    } else {
      if (now - _pulling < 500) {
        return Uint8List(0);
      }
      _pulling = now;
    }*/

    /*bool pl = false;
    Random rnd = new Random();
    var r = 100 + rnd.nextInt(600 - 100);
    Timer(Duration(milliseconds: r), () {*/
  }

  Future<Uint8List> pullIPFScid(String cid, int xxHint) async {
    //check if we have this mapped on local cache

    final b = _io!.readCid(cid);
    if (b != null) {
      return b;
    }

    return pullCidFromIPFS(cid, xxHint).then((data) async {
      if (data.isEmpty) return Uint8List(0);
      //final xxInt = xxHash(data);

      return data;
    });
  }

  Map<String, int> _pullQueue = {};
  bool get pullQueueRefresh {
    if (_pullQueue.isEmpty) return false;
    if (_pulling) return false;

    final cid = _pullQueue.keys.first;
    final xx = _pullQueue.values.first;

    pullCidFromIPFS(cid, xx).then((value) {
      _pullQueue.remove(cid);
    });
    return true;
  }

  Map<String, int> _currentlyPulling = {};
  Future<Uint8List> pullCidFromIPFS(String cid, int xxInt) async {
    if (!online) return Uint8List(0);
    if (_currentlyPulling.containsKey(cid)) return Uint8List(0);
    if (_currentlyPulling.length > 5) {
      _pullQueue[cid] = xxInt;
      return Uint8List(0);
    }
    _currentlyPulling[cid] = xxInt;

    try {
      return HttpClient()
          .getUrl(Uri.parse('https://ipfs.io/ipfs/' + cid))
          .timeout(Duration(milliseconds: 1512)) // produces a request object
          .then((request) => request.close()) // sends the request
          .then((response) async {
        //print(response.toString());

        //print(utf8.decode(rp[0]));
        if (response.statusCode == 200) {
          final rp = await response.toList();
          Uint8List r = Uint8List(1000000);
          int ff = 0;
          for (var i in rp) {
            for (var ii in i) {
              r[ff++] = ii;
            }
          }
          if (xxInt == 0) {
            xxInt = await xxHash(r.sublist(0, ff)).bake();
          }
          _xxStash[xxInt] = r.sublist(0, ff);
          _io?.commitCid(r.sublist(0, ff), cid);

          _xxWants.remove(xxInt);
          _currentlyPulling.remove(cid);

          Random rnd = new Random();
          final rd = 30 + rnd.nextInt(200);
          Timer(Duration(milliseconds: rd), () {
            pullQueueRefresh;
          });

          return r.sublist(0, ff);
        } else {
          _currentlyPulling.remove(cid);
          Random rnd = new Random();
          final rd = 30 + rnd.nextInt(200);
          Timer(Duration(milliseconds: rd), () {
            pullQueueRefresh;
          });
          return Uint8List(0);
        }
      });
    } on TimeoutException catch (e) {
      _xxWants.remove(xxInt);
      _currentlyPulling.remove(cid);
      Random rnd = new Random();
      final rd = 30 + rnd.nextInt(200);
      Timer(Duration(milliseconds: rd), () {
        pullQueueRefresh;
      });
      return Uint8List(0);

      // handle timeout
    }
  }

  Future<bool> symlinkForIpfsEntry(String cid, String xx64) async {
    var shell = Shell();

    final xxfy = await shell.run('''ln -s ''' +
        Directory.current.path +
        '''/uppity/ipfs/''' +
        cid +
        ' ' +
        Directory.current.path +
        '/uppity/xx/' +
        xx64);

    return true;
  }

  Future<bool> satisfy(int xx, Uint8List data, bool ghostMode) async {
    if (isXXcached(xx)) return false;
    if (!_diskMissing.contains(xx)) return false;
    _xxStash[xx] = data;
    _xxWants.remove(xx);
    _diskMissing.remove(xx);
    if (!ghostMode) {
      //_io?.commitXX(data, xx);
    }
    return true;
  }

  List<int> get stats {
    final s = [
      0, //IOreceived
      0, //IOsent
      0, //memUsed
      0 //audience
    ];
    return s;
  }

  broadcastXXwantOverUDP(int xxHash) {}
}

class xxHash {
  xxHash(this._xxData);
  final List<int> _xxData;
  Future<int> bake() async {
    final p = ReceivePort();
    // spawn the isolate and wait for it to complete
    await Isolate.spawn(_xxHashIsolate, p.sendPort);
    // get and return the result data
    return await p.first;
  }

  Future<void> _xxHashIsolate(SendPort p) async {
    final digest = xxHash64.convert(_xxData);
    final ii = digest.x.toInt();
    Isolate.exit(p, ii);
  }
}
