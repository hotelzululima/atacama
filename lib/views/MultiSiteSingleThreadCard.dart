import '../Provider/MultiSiteModeratorEntrySetProvider.dart';
import '../Provider/SitesProvider.dart';
import 'package:flutter/material.dart';
import 'package:interzone/world.dart';
import 'components/viewHelpersFlutter.dart';
import '../navigation/NavWrapper.dart';
import 'package:share_plus/share_plus.dart';
import 'components/multiSiteButtonBar.dart';

Card MultiSiteSingleThreadCard(
    ModeratorEntry m,
    MultiSiteModeratorEntrySetProvider mes,
    ModeratorViewSettings mflags,
    ImageProvider? i,
    BottomNavigationBarProvider navi,
    SitesProvider source,
    int parentListIndex) {
  //we display this, mark it seen
  if (!m.flags.isSeen) {
    source.markSeen(m.shortLink);
  }
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
              child: Wrap(children: articlePostWrapBodyHelper(m)),
            ),
            //MultiSiteReplyButtonBar(m, mflags, navi, source),
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
          MultiSiteReplyButtonBar(m, mflags, navi, source),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Wrap(children: articlePostWrapBodyHelper(m)),
          ),
        ],
      ));
}
