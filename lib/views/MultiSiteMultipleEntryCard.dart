import '../Provider/MultiSiteModeratorEntrySetProvider.dart';
import '../Provider/SitesProvider.dart';
import 'package:flutter/material.dart';
import 'package:interzone/world.dart';
import 'components/viewHelpersFlutter.dart';
import '../navigation/NavWrapper.dart';
import 'components/multiSiteButtonBar.dart';

Card MultiSiteMultipleEntryCard(
    ModeratorEntry m,
    MultiSiteModeratorEntrySetProvider mes,
    ModeratorViewSettings mflags,
    ImageProvider? i,
    BottomNavigationBarProvider navi,
    SitesProvider source,
    int parentListIndex,
    String targetSite) {
  var heading = '\$2300 per month';
  var subheading = '2 bed, 1 bath, 1300 sqft';
  Image? cardImage;
  var supportingText =
      'Beautiful home to rent, recently refurbished with modern appliances...';
  if (m.flags.attachements && m.ipfsCid.isNotEmpty) {
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
                    source.currentThreadShortLink = (m.shortLink);
                    source.threadByShortLink(m.shortLink);
                    navi.setcurrentObservedPostIndex = parentListIndex;
                    navi.showMultiSiteThreadPage(m.siteUrl, m.shortLink);
                  },
                  child: Ink.image(
                    image: i!,
                    fit: BoxFit.fitWidth,
                  ),
                )),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(articlePostCleanBodyHelper(m)),
            ),
            MultiSiteButtonBar(m, mflags, navi, source),
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
          MultiSiteButtonBar(m, mflags, navi, source),
        ],
      ));
}
