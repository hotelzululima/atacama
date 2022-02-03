import '../../Provider/messages.dart';
import '../../actions/MessageActions.dart';
import 'package:flutter/material.dart';
import 'package:interzone/world.dart';
import 'viewHelpersFlutter.dart';
import '../../navigation/NavWrapper.dart';

Card multipleReplyCard(
  ModeratorEntry m,
  ModeratorEntrySetProvider mes,
  ModeratorViewSettings mflags,
  ImageProvider? i,
  BottomNavigationBarProvider navi,
) {
  var heading = '\$2300 per month';
  var subheading = '2 bed, 1 bath, 1300 sqft';
  Image? cardImage;
  var supportingText =
      'Beautiful home to rent, recently refurbished with modern appliances...';
  if (m.flags.attachements) {
    return Card(
        elevation: 4.0,
        child: Column(
          children: [
            ListTile(
              title: articleAuthorHelper(m, mes, navi),
              //subtitle: Text(subheading),
              //trailing: Icon(Icons.favorite_outline),
            ),
            Container(
                height: 360.0,
                child: InkWell(
                  onTap: () {
                    mes.filterShortLink = m.shortLink;
                    navi.showThreadPage(m.shortLink);
                  },
                  child: Ink.image(
                    image: i!,
                    fit: BoxFit.fitWidth,
                  ),
                )),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(articlePostCleanBodyHelper(m),
                  style: TextStyle(fontSize: 18.0)),
            ),
            ButtonBar(
              children: [
                /*TextButton(
                child: const Text('CONTACT AGENT'),
                onPressed: () {/* ... */},
              ),*/
                TextButton(
                  onPressed: () {
                    navi.signal(AtacamaAction.viewThread, m.shortLink);
                  },
                  child: Text(
                      articlePostCommentsHelper(
                          m, mes.source.childrenOf(m.hint)),
                      style: TextStyle(fontSize: 18.0)),
                ),
              ],
            )
          ],
        ));
  }
  return Card(
      elevation: 4.0,
      child: Column(
        children: [
          ListTile(
            title: articleAuthorHelper(m, mes, navi),
            //subtitle: Text(subheading),
            //trailing: Icon(Icons.favorite_outline),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(articlePostCleanBodyHelper(m),
                style: TextStyle(fontSize: 18.0)),
          ),
          ButtonBar(
            children: [
              /*TextButton(
                child: const Text('CONTACT AGENT'),
                onPressed: () {/* ... */},
              ),*/
              TextButton(
                onPressed: () {
                  navi.signal(AtacamaAction.viewThread, m.shortLink);
                },
                child: Text(
                    articlePostCommentsHelper(m, mes.source.childrenOf(m.hint)),
                    style: TextStyle(fontSize: 18.0)),
              ),
            ],
          )
        ],
      ));
}
