import 'package:flutter/material.dart';

enum AtacamaAction {
  viewThread,
  replyToThread,
  dropThread,
  viewTaggedThreads,
  viewAuthorThreads,
  viewCombinationThreads,
  initReply, //open reply box
  initTaggedPost,
  initMentioningPost,
  initPost, //open post box
  initCameraThenPost, //take a pic and post
  initUploadThenPost, //select pic then post
  reply, //click submit then reply
  post, //click submit on post
  refresh, //pull shit from net
  setNick, //set your nick
  purgeOld, //purge excess data
  viewProfile //show prof screeno
}

class MessageActionHandler {
  void showDefaultView(dynamic context) {
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CombinationPage()),
    );*/
  }

  void viewThread(String shortLink) {}
  void replyToThread(String shortLink) {}
  void dropThread(String shortLink) {}
  void viewTaggedThreads(String shortLink) {
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TagPage()),
    );*/
  }

  void viewAuthorThreads(String shortLink) {
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthorPage()),
    );*/
  }
}
