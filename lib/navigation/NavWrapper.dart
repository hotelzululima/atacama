import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/MultiSiteThreadPage.dart';
import '../views/MultiSiteCombinationPage.dart';

import '../actions/MessageActions.dart';
import '../views/PostingKeyboardPage.dart';
import '../views/ImagePickerPage.dart';
import '../views/AtacamaProfilePage.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  // The index of the current tab
  int _currentTabIndex = 0;
  int _keyboard = 0;
  int _currentObservedPostIndex = 0;
  void set setcurrentObservedPostIndex(int x) => _currentObservedPostIndex = x;
  int get currentObservedPostIndex => _currentObservedPostIndex;

  bool _imagePickerPage = false;
  bool _atacamaProfilePage = true;
  bool get showTabBar {
    if (_keyboard != 0) return false;
    if (_imagePickerPage != 0) return false;
    if (_atacamaProfilePage != 0) return false;
    return true;
  }

  String _tag = '';
  String _author;
  int get currentTabIndex => _currentTabIndex;
  int get keyboard => _keyboard;
  // Sets the current tab's index

  BottomNavigationBarProvider(this._author);

  set currentTabIndex(int newIndex) {
    _currentTabIndex = newIndex;
    notifyListeners();
  }

  String get postingKeyboardTextFormFieldSeed {
    if (_tag.isEmpty && _author.isEmpty) return '';
    if (_tag.isNotEmpty) return '#' + _tag;
    return '@' + _author;
  }

  void closePostingKeyboardPage() {
    //hide
    _keyboard = 0;
    notifyListeners();
  }

  void showImagePickerPage() {
    if (_keyboard == 0) return;
    if (_imagePickerPage) return;
    _imagePickerPage = true;
    notifyListeners();
  }

  void closeAtacamaProfilePage() {
    _atacamaProfilePage = false;
    notifyListeners();
  }

  void showAtacamaProfilePage() {
    _atacamaProfilePage = true;
    notifyListeners();
  }

  bool _showThreadPage = false;
  String _threadShortLink = '';
  void showThreadPage(String shortLink) {
    _showThreadPage = true;
    _threadShortLink = shortLink;
    notifyListeners();
  }

  void closeThreadPage() {
    _showThreadPage = false;
    notifyListeners();
  }

  bool _showMultiSiteThreadPage = false;
  String _MultiSitethreadShortLink = '';
  String _currentSite = '';
  void showMultiSiteThreadPage(String url, String shortLink) {
    _showMultiSiteThreadPage = true;
    _MultiSitethreadShortLink = shortLink;
    _currentSite = url;
    notifyListeners();
  }

  void closeMultiSiteThreadPage() {
    _showMultiSiteThreadPage = false;
    notifyListeners();
  }

  void signal(AtacamaAction a, String shortLink) {
    switch (a) {
      case AtacamaAction.viewThread:
        //acHandler.viewThread(shortLink);
        break;
      case AtacamaAction.dropThread:
        //acHandler.dropThread(shortLink);
        break;
      case AtacamaAction.viewTaggedThreads:
        _currentTabIndex = 1;
        notifyListeners();
        //acHandler.viewTaggedThreads(shortLink);
        break;
      case AtacamaAction.viewAuthorThreads:
        //acHandler.viewAuthorThreads(shortLink);
        _currentTabIndex = 2;
        notifyListeners();
        break;
      case AtacamaAction.viewCombinationThreads:
        //acHandler.viewAuthorThreads(shortLink);
        _currentTabIndex = 0;
        notifyListeners();
        break;
      case AtacamaAction.initPost:
        _keyboard = 1;
        _tag = '';
        _author = '';
        notifyListeners();
        break;
      case AtacamaAction.initTaggedPost:
        _keyboard = 1;
        _tag = shortLink;
        _author = '';
        notifyListeners();
        break;
      case AtacamaAction.initMentioningPost:
        _keyboard = 1;
        _tag = '';
        _author = shortLink;
        notifyListeners();
        break;
    }
  }

  //Function which shows Alert Dialog
  alertDialog(BuildContext context) {
    // This is the ok button
    Widget ok = FlatButton(
      child: Text("Okay"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("I am Here!"),
          content: Text("I appeared because you pressed the button!"),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }
}

class NavWrapper extends StatelessWidget {
  final List<Widget> _tabs = [MultiSiteCombinationPage()];
  final Widget _postingKeyboard = PostingKeyboardPage();
  final Widget _imagePicker = ImagePickerPage();
  final Widget _profilePage = AtacamaProfilePage();
  final Widget _threadPage = MultiSiteThreadPage();

  @override
  Widget build(BuildContext context) {
    /*alertDialog(BuildContext context) {
      // This is the ok button
      Widget ok = FlatButton(
        child: Text("Okay"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      // show the alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("I am Here!"),
            content: Text("I appeared because you pressed the button!"),
            actions: [
              ok,
            ],
            elevation: 5,
          );
        },
      );
    }*/

    final BottomNavigationBarProvider _bottomNavigationBarProvider =
        context.watch<BottomNavigationBarProvider>();

    return Scaffold(
      body: _bottomNavigationBarProvider._showMultiSiteThreadPage
          ? _threadPage
          : _bottomNavigationBarProvider._atacamaProfilePage
              ? _profilePage
              : _bottomNavigationBarProvider._keyboard == 0
                  ? _tabs[_bottomNavigationBarProvider.currentTabIndex]
                  : _bottomNavigationBarProvider._imagePickerPage
                      ? _imagePicker
                      : _postingKeyboard,
      /*bottomNavigationBar: _bottomNavigationBarProvider.showTabBar
          ? BottomNavigationBar(
              currentIndex: _bottomNavigationBarProvider.currentTabIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.cloud_circle_outlined), label: 'world'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.deck_outlined), label: '#tags'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.child_care), label: 'author'),
              ],
              onTap: (index) =>
                  _bottomNavigationBarProvider.currentTabIndex = index,
            ) */
    );
  }
}
