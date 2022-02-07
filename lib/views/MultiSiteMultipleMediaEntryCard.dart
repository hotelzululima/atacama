import '../Provider/MultiSiteModeratorEntrySetProvider.dart';
import '../Provider/SitesProvider.dart';
import 'package:flutter/material.dart';
import 'package:interzone/world.dart';
import 'components/viewHelpersFlutter.dart';
import '../navigation/NavWrapper.dart';
import 'components/multiSiteButtonBar.dart';
import 'MultiSiteThreadPage.dart';
import 'videoPage.dart';

Card MultiSiteMultipleMediaEntryCard(
    BuildContext bc,
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
  //we are showing the data, mark it read
  if (!m.flags.isSeen) {
    source.markSeen(m.shortLink);
  }

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
                    source.refreshThreadViaHTTP(m.shortLink);
                    source.refreshAuthorViaHTTP(m.shortLink);
                    source.refreshTaggedViaHTTP(m.shortLink);
                    navi.setcurrentObservedPostIndex = parentListIndex;
                    Navigator.push(
                        bc,
                        new MaterialPageRoute(
                            builder: (context) => new MultiSiteThreadPage()));

                    //navi.showMultiSiteThreadPage(m.siteUrl, m.shortLink);
                  },
                  child: Ink.image(
                    image: i!,
                    fit: BoxFit.fitWidth,
                  ),
                )),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Wrap(children: articlePostWrapBodyHelper(m)),
              //child:RichText()
              /*child: Markdown(
                data: articlePostCleanBodyHelper(m),
              ),*/
            ),
            MultiSiteButtonBar(bc, m, mflags, navi, source),
          ],
        ));
  }
  if (m.flags.attachements && m.videoCid.isNotEmpty) {
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
                    source.refreshThreadViaHTTP(m.shortLink);
                    source.refreshAuthorViaHTTP(m.shortLink);
                    source.refreshTaggedViaHTTP(m.shortLink);
                    navi.setcurrentObservedPostIndex = parentListIndex;
                    Navigator.push(
                        bc,
                        new MaterialPageRoute(
                            builder: (context) => new VideoPage()));

                    //navi.showMultiSiteThreadPage(m.siteUrl, m.shortLink);
                  },
                  child: Ink.image(
                    image: i!,
                    fit: BoxFit.fitWidth,
                  ),
                )),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Wrap(children: articlePostWrapBodyHelper(m)),
              //child:RichText()
              /*child: Markdown(
                data: articlePostCleanBodyHelper(m),
              ),*/
            ),
            MultiSiteButtonBar(bc, m, mflags, navi, source),
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
            child: Wrap(children: articlePostWrapBodyHelper(m)),
          ),
          MultiSiteButtonBar(bc, m, mflags, navi, source),
        ],
      ));
}
