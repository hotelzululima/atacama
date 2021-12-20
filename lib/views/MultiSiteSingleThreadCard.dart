import '../Provider/MultiSiteModeratorEntrySetProvider.dart';
import '../Provider/SitesProvider.dart';
import 'package:flutter/material.dart';
import 'package:interzone/world.dart';
import 'components/viewHelpersFlutter.dart';
import '../navigation/NavWrapper.dart';
import 'package:share_plus/share_plus.dart';

Card MultiSiteSingleThreadCard(
    ModeratorEntry m,
    MultiSiteModeratorEntrySetProvider mes,
    ModeratorViewSettings mflags,
    ImageProvider? i,
    BottomNavigationBarProvider navi,
    SitesProvider source,
    int parentListIndex) {
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
                height: 420.0,
                child: InkWell(
                  onTap: () {
                    source.threadByShortLink(m.shortLink);
                    mes.setCurrentThreadRoot = m;
                    //mes.filterShortLink = m.shortLink;
                    navi.setcurrentObservedPostIndex = parentListIndex;
                    navi.showThreadPage(m.shortLink);
                  },
                  child: Ink.image(
                    image: i!,
                    fit: BoxFit.cover,
                  ),
                )),
            Container(
              padding: EdgeInsets.all(4.0),
              alignment: Alignment.centerLeft,
              child: Text(articlePostCleanBodyHelper(m)),
            ),
            ButtonBar(
              children: [
                /*TextButton(
                child: const Text('CONTACT AGENT'),
                onPressed: () {/* ... */},
              ),*/
                TextButton(
                  onPressed: () {
                    String l = m.siteUrl + '/t/' + m.shortLink;
                    Share.share(l, subject: m.twitterPostContent);

                    //navi.signal(AtacamaAction.viewThread, m.shortLink);
                  },
                  child: Icon(Icons.share),
                ),
                /*TextButton(
                  onPressed: () {
                    mes.setCurrentThreadRoot = m;
                    //mes.filterShortLink = m.shortLink;
                    navi.showThreadPage(m.shortLink);
                    source.refreshThreadViaHTTP(m.siteUrl, m.shortLink);
                    //navi.signal(AtacamaAction.viewThread, m.shortLink);
                  },
                  child: Text(articlePostCommentsHelper(
                      m, mes.repliesToThread(m.keyHint))),
                ),*/
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
            child: Text(articlePostCleanBodyHelper(m)),
          ),
          ButtonBar(
            children: [
              /*TextButton(
                child: const Text('CONTACT AGENT'),
                onPressed: () {/* ... */},
              ),*/
              TextButton(
                onPressed: () {
                  mes.setCurrentThreadRoot = m;
                  //mes.filterShortLink = m.shortLink;
                  navi.showThreadPage(m.shortLink);
                  source.threadByShortLink(m.shortLink);
                  //navi.signal(AtacamaAction.viewThread, m.shortLink);
                },
                child: Text(articlePostCommentsHelper(
                    m, mes.repliesToThread(m.keyHint))),
              ),
            ],
          )
        ],
      ));
}
