import 'package:flutter/material.dart';
import '../../Provider/SitesProvider.dart';
import 'package:interzone/world.dart';
import '../../navigation/NavWrapper.dart';
import 'viewHelpersFlutter.dart';

ButtonBar MultiSiteButtonBar(ModeratorEntry m, ModeratorViewSettings mflags,
    BottomNavigationBarProvider navi, SitesProvider source) {
  return ButtonBar(
    children: [
      /*TextButton(
                child: const Text('CONTACT AGENT'),
                onPressed: () {/* ... */},
              ),*/
      TextButton(
          onPressed: () async {
            await source.DropEntry(m.shortLink);

            //navi.signal(AtacamaAction.viewThread, m.shortLink);
          },
          /*child: Icon(Icons.delete_forever)),
      TextButton(
          onPressed: () async {
            await source.MuteAuthor(m.shortLink);

          },*/
          child: Icon(Icons.delete)),
      TextButton(
        onPressed: () async {
          await source.ShareEntry(m);

          //navi.signal(AtacamaAction.viewThread, m.shortLink);
        },
        child: Icon(Icons.share),
      ),
      TextButton(
        onPressed: () {
          //source.refreshThreadViaHTTP(m.siteUrl, m.shortLink);
          //source.currentThreadShortLink = m.shortLink;
          //navi.setcurrentObservedPostIndex = parentListIndex;
          source.threadByShortLink(m.shortLink);
          source.currentThreadShortLink = m.shortLink;
          navi.showMultiSiteThreadPage(m.siteUrl, m.shortLink);
        },
        child: Text(articlePostCommentsHelper(
            m, source.threadByShortLink(m.shortLink))),
      ),
    ],
  );
}
