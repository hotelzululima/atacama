import 'dart:convert';
import '../constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interzone/world.dart';

class MultiSiteModeratorEntrySetProvider with ChangeNotifier {
  ModeratorEntrySet source;
  //MessageActionHandler acHandler;
  //List<ModeratorEntry> _entriesList = source.all;
  String _filterTag = '';
  String _filterAuthor = '';
  String _filterMentions = '';
  String _filterShortLink = '';
  ModeratorEntry? _currentThreadRoot;
  ModeratorEntry? _currentMultiSiteThreadRoot;
  set setCurrentThreadRoot(ModeratorEntry r) => source.currentThreadRoot = r;
  set setCurrentMultiSiteThreadRoot(ModeratorEntry r) =>
      _currentMultiSiteThreadRoot = r;

  get currentThread => source.currentThread.toList();
  get currentThreadRoot =>
      source.currentThread.where((element) => element.flags.isPost).first;

  repliesToThread(int h) {
    return source
        .childrenOf(h)
        .where((element) => element.flags.isReply)
        .toList();
  }

  void refresh() {
    notifyListeners();
  }

  //List<ModeratorEntry> childrenOf ()
  String get currentTag => _filterTag;
  List<ModeratorEntry> get postEntriesList =>
      source.all.where((element) => element.flags.isPost).toList();
  List<ModeratorEntry> get entriesList => source.all;
  List<ModeratorEntry> get tagEntriesList => source.taggedAs(_filterTag);
  List<ModeratorEntry> get authorEntriesList => source.authors(_filterAuthor);
  List<ModeratorEntry> get mentionEntriesList =>
      source.mentioning(_filterMentions);
  MultiSiteModeratorEntrySetProvider(this.source);
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
  /*void signal(AtacamaAction a, String shortLink) {
    switch (a) {
      case AtacamaAction.viewThread:
        acHandler.viewThread(shortLink);
        break;
      case AtacamaAction.dropThread:
        acHandler.dropThread(shortLink);
        break;
      case AtacamaAction.viewTaggedThreads:
        acHandler.viewTaggedThreads(shortLink);
        break;
      case AtacamaAction.viewAuthorThreads:
        acHandler.viewAuthorThreads(shortLink);
        break;
    }
  }*/

  set filterShortLink(String t) {
    _filterShortLink = t;
    //notifyListeners();
  }

  set filterTag(String t) {
    _filterTag = t;
    //notifyListeners();
  }

  set filterAuthor(String t) {
    _filterAuthor = t;
    //notifyListeners();
  }

  set filterMentions(String t) {
    _filterMentions = t;
    //notifyListeners();
  }

  void deleteCountry(int index) {
    if (entriesList.length >= index) {
      entriesList.removeAt(index);
    }
    //notifyListeners();
  }

  void getData() {}
}
