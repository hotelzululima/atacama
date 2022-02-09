import 'package:flutter/material.dart';
import '../../Provider/SitesProvider.dart';
import 'package:interzone/world.dart';
import '../../navigation/NavWrapper.dart';
import 'viewHelpersFlutter.dart';
import '../MultiSiteThreadPage.dart';

ButtonBar MultiSiteReplyButtonBar(
    ModeratorEntry m,
    ModeratorViewSettings mflags,
    BottomNavigationBarProvider navi,
    SitesProvider source) {
  return ButtonBar(
    children: [
      /*TextButton(
                child: const Text('CONTACT AGENT'),
                onPressed: () {/* ... */},
              ),*/
      m.flags.isLiked
          ? TextButton(
              onPressed: () async {
                await source.unlikeEntry(m.shortLink);

                //navi.signal(AtacamaAction.viewThread, m.shortLink);
              },
              child: Icon(Icons.thumb_up))
          : TextButton(
              onPressed: () async {
                await source.LikeEntry(m.shortLink);

                //navi.signal(AtacamaAction.viewThread, m.shortLink);
              },
              child: Icon(Icons.thumb_up_outlined)),
      TextButton(
          onPressed: () async {
            await source.DropEntry(m.shortLink);

            //navi.signal(AtacamaAction.viewThread, m.shortLink);
          },
          child: Icon(Icons.delete)),
      /*TextButton(
        onPressed: () async {
          await source.ShareEntry(m);

          //navi.signal(AtacamaAction.viewThread, m.shortLink);
        },
        child: Icon(Icons.share),
      ),*/
    ],
  );
}

ButtonBar MultiSiteButtonBar(
    BuildContext bc,
    ModeratorEntry m,
    ModeratorViewSettings mflags,
    BottomNavigationBarProvider navi,
    SitesProvider source) {
  return ButtonBar(
    children: [
      /*TextButton(
                child: const Text('CONTACT AGENT'),
                onPressed: () {/* ... */},
              ),*/
      m.flags.isLiked
          ? TextButton(
              onPressed: () async {
                await source.unlikeEntry(m.shortLink);

                //navi.signal(AtacamaAction.viewThread, m.shortLink);
              },
              child: Icon(Icons.thumb_up))
          : TextButton(
              onPressed: () async {
                await source.LikeEntry(m.shortLink);
                //navi.signal(AtacamaAction.viewThread, m.shortLink);
              },
              child: Icon(Icons.thumb_up_outlined)),
      TextButton(
          onPressed: () async {
            await source.DropEntry(m.shortLink);
          },
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
          Navigator.push(
              bc,
              new MaterialPageRoute(
                  builder: (context) => new MultiSiteThreadPage()));

          //navi.showMultiSiteThreadPage(m.siteUrl, m.shortLink);
        },
        child: Text(articlePostCommentsHelper(
            m, source.threadByShortLink(m.shortLink))),
      ),
    ],
  );
}
