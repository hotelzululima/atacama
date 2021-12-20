import '../../navigation/NavWrapper.dart';
import 'package:flutter/material.dart';
import 'package:interzone/world.dart';
import '../../sites/clubChonkyLoc.dart';
import '../../actions/MessageActions.dart';

zlinkButtonHelper(String url, String text, String author, String mentions) {
  var s = '<form action="' +
      url +
      '" method="POST"><button type="submit">' +
      text +
      '</button>';
  if (author.isNotEmpty) {
    s += '<input type="hidden" name="qa" value="' + author + '" />';
  }
  if (mentions.isNotEmpty) {
    s += '<input type="hidden" name="qm" value="' + mentions + '" />';
  }

  s += '</form>';
  return s;
}

linkFakeButtonHelper(String url, String text, String author, String mentions) {
  //crawler friendly anchor that looks like a button
  var s = '<a href="' + url + '" class="fbtn">' + text + '</a>';
  return s;
}

parseLinksToHtml(ModeratorEntry m, bool useIpfs) {
  //dafuk with the ipfs crappo
  //attachm

  if (!m.flags.attachements) return m.body;

  String rem = '';
  String pee = '';
  bool disc = false;
  bool proc = false;
  var mam = m.body.replaceAll("\n", " ").trim().split(' ');
  mam.forEach((element) {
    if (element.startsWith('!&')) {
      disc = true;
      proc = false;
      var mop = element.substring(2, element.length);
      if (useIpfs) {
        rem += '<img src="https://ipfs.io/ipfs/' + mop + '" loading="lazy"/>';
      } else {
        rem += '<img src="/xx/' + m.shortLink + '" loading="lazy"/>';
      }
      return;
    }
    if (element.startsWith('http')) {
      //bake into mdlink
      var dom = element.split('/');
      rem += ' <a href="' + element + '">' + dom[2] + '</a>';
      return;
    }
    pee += element + ' ';
  });
  if (disc) return rem + '<p>' + pee + '</p>';
  //legacy shit
  pee = '';
  var mm = m.body.trim().split(')');
  if (mm.length < 2) {
    mm = m.body.split('(');
  }
  mm.forEach((element) {
    if (element.startsWith('!')) {
      if (useIpfs) {
        var d = element.split('/').last;
        var cid = d.substring(0, d.length - 1);
        rem += '<img src="https://ipfs.io/ipfs/' + d + '" loading="lazy"/>';
      } else {
        rem += '<img src="/xx/' + m.shortLink + '" loading="lazy"/>';
      }
      return;
    } else {
      pee += element + ' ';
    }
  });

  return rem + '<p>' + pee + '</p>';
}

timeHelper(int timeElapsedSincePostMs) {
  if (timeElapsedSincePostMs == 0) return 'lately';
  var t = (timeElapsedSincePostMs / 60000).round();
  if (t < 2) return 'just now';
  if (t < 20) return 'now';
  if (t < 60) return t.toString() + 'm ago';
  if (t < 400) {
    return 'lately';
  }
  if (t < 24 * 60) return 'today';
  if (t < 48 * 60) return 'yesterday';
  //if (t < 7 * 24 * 60) return 'few days ago';
  return 'previously';
}

String tagHelper(List<String> tags) {
  if (tags.isEmpty) return '';
  String s = '';
  tags.forEach((element) {
    s += '<dt>' +
        linkButtonHelper('/tg/' + element, '#' + element, '', '') +
        '</dt>';
  });
  return s;
}

xarticleAuthorHelper(ModeratorEntry p, bool parseLinks, bool useIpfs,
    int totalComments, String pp, bool mentions, bool threads, bool slim) {
  String s = '';
  if (slim) {
    s += '<div class="abarslim"><dl>';
  } else {
    s += '<div class="abar"><dl>';
  }
  s += '<dt>' +
      linkButtonHelper('/tg/all', '@' + p.softNick + '🌱', p.softNick, '') +
      '</dt>';
  String tl = timeHelper(p.timeElapsedSincePostMs);
  s += tagHelper(p.tags);
  //s += '<dt>' + linkButtonHelper('/tg/all', tl, p.softNick, '') + '</dt>';
  s += '<dt>' +
      linkFakeButtonHelper('/t/' + p.shortLink, tl, p.softNick, '') +
      '</dt>';

  return s + '</dl></div>';
}

articlePostCleanBodyHelper(ModeratorEntry p) {
  //clean out outbound scheisse, todo allow @mention clix

  var s = '';
  var su = p.body.split(' ');
  su.forEach((element) {
    if (element.startsWith('!')) return;
    if (element.startsWith('&')) return;
    s = s + element + ' ';
  });
  return s;
}

articleReplyHelperHTML(ModeratorEntry r, ModeratorEntry threadParent,
    bool parseLinks, bool useIpfs) {
  var s = '<dl>';
  //author shebango
  //s += '<dt>' + r.nick + '</dt>';
  //body texto
  s += '<p>' + (parseLinks ? parseLinksToHtml(r, useIpfs) : r.body) + '</p>';
  return s + '</dl>';
}

articleAddBoxHelperHTML(ModeratorEntry t, ModeratorViewSettings flags,
    MODERATOR_LOC molo, String pp) {
  var s = '';
  s += '<div class="postBox"><form action="/new/' +
      t.shortLink +
      '" method="POST" enctype="multipart/form-data">';
  s += '<label for="post">' + molo.postBoxStartThread + '</label><br>';

  /*if (flags.moderate) {
    s += '<span><label for="nick">' + molo.postBoxNick + '</label> :';
    s += '<input type="text" id="nick" maxlength="12" name="nick" value="' +
        t.nick +
        '"></span>';
    s += '<input type="text" id="avatar" name="avatar" value="' +
        t.avatar +
        '" maxlength="4"></span>';
  }*/

  //s += '<br>';

  s += '<textarea name="post" rows="5" maxlength="1024">';
  if (flags.rootPage != 'all') {
    //s += '/' + flags.nick + ' #' + flags.rootPage + ' ';
    s += '#' + flags.rootPage;
  } else {
    //s += '/' + flags.nick + ' ';
  }

  /*if (flags.rootPage != '') {
    s += '#' + flags.rootPage;
  }*/

  s += '</textarea>';
  //if (flags.moderate) {
  s +=
      '<input type="hidden" name="MAX_FILE_SIZE" value="430" /><input type="file" id="myFile" name="filename"/>';
  //}
  if (pp.isNotEmpty) {
    //send perceived previous
    s += '<input type="hidden" name="pp" value="' + pp + '" />';
  }
  s += '<button type="button" onclick="setNick()">' +
      molo.changeNickButton +
      '</button><button type="submit" >' +
      molo.postBoxStartThreadButton +
      ' @' +
      flags.nick +
      '</button></form>';

  return s + '</div>';
}

articleReplyBoxHelperHTML(ModeratorEntry t, ModeratorViewSettings flags,
    MODERATOR_LOC molo, String nick, String pp, bool slim) {
  var s = '';
  if (slim) {
    s += '<div class="rboxslim"><form action="/reply/' +
        t.shortLink +
        '" method="POST" enctype="multipart/form-data">';
  } else {
    s += '<div class="rbox"><form action="/reply/' +
        t.shortLink +
        '" method="POST" enctype="multipart/form-data">';
  }
  if (!slim) {
    s += '<label for="post">' + molo.postBoxCommentLabel + '</label><br>';
  }
  /*if (flags.moderate) {
    s += '<span><label for="nick">' + molo.postBoxNick + '</label> :';
    s += '<input type="text" id="nick" maxlength="12" name="nick" value="' +
        t.nick +
        '"></span>';
    s += '<input type="text" id="avatar" name="avatar" value="' +
        t.avatar +
        '" maxlength="4"></span>';
  }*/

  //s += '<br>';

  s += '<textarea name="reply" rows="5" maxlength="1024">';
  /*if (flags.rootPage != 'all') {
    s += '#' + flags.rootPage + ' ';
  } else {*/
  //s += '/' + flags.nick + ' ';
  //}

  /*if (flags.rootPage != '') {
    s += '#' + flags.rootPage;
  }*/
  s += '</textarea>';
  /*if (flags.moderate) {
    s +=
        '<input type="hidden" name="MAX_FILE_SIZE" value="430" /><input type="file" id="myFile" name="filename"/>';
  }*/

  if (pp.isNotEmpty) {
    //send perceived previous
    s += '<input type="hidden" name="pp" value="' + pp + '" />';
  }
  s += '<button type="button" onclick="setNick()">' +
      molo.changeNickButton +
      '</button><button type="submit" >' +
      molo.postBoxCommentButton +
      ' @' +
      nick +
      '</button></form>';
  //s += '</form>';
  return s + '</div>';
}

String tagCloudHelper(Map<String, int> tagsByPopularity) {
  if (tagsByPopularity.isEmpty) return '';
  var s = '<dl>';
  tagsByPopularity.forEach((key, value) {
    if (key == 'boot') return;
    if (key == 'test') return;
    if (value < 3) return;
    s += '<dt><form method="POST" action="/tg/' +
        key +
        '"><button type="submit" onclick="seeTagged(\"' +
        key +
        '\")">#' +
        key +
        '</button></form></dt>';
  });
  return s + '</dl>';
}

dynamic linkButtonHelper(
    String url, String text, String author, String mentions) {
  var s = '<form action="' +
      url +
      '" method="POST"><button type="submit">' +
      text +
      '</button>';
  if (author.isNotEmpty) {
    s += '<input type="hidden" name="qa" value="' + author + '" />';
  }
  if (mentions.isNotEmpty) {
    s += '<input type="hidden" name="qm" value="' + mentions + '" />';
  }

  s += '</form>';
  return s;
}

ButtonBar articleAuthorHelper(
    ModeratorEntry p, dynamic mes, BottomNavigationBarProvider navi) {
  NavigatorState navigatorState;

  List<Widget> s = [];
  /*if (slim) {
    s += '<div class="abarslim"><dl>';
  } else {
    s += '<div class="abar"><dl>';
  }*/

  //s.add(linkButtonHelper('/tg/all', '@' + p.softNick + '🌱', p.softNick, ''));
  s.add(TextButton(
    child: Text("@" + p.softNick + '🌱'),
    //textColor: Colors.white,
    //color: Colors.green,
    onPressed: () {
      mes.filterAuthor = p.softNick;
      //navi.signal(AtacamaAction.viewAuthorThreads, p.softNick);
    },
  ));

  if (p.tags.isNotEmpty) {
    p.tags.forEach((element) {
      s.add(TextButton(
        child: Text("#" + element),

        //textColor: Colors.white,
        //color: Colors.green,
        onPressed: () {
          mes.filterTag = element;
          //navi.signal(AtacamaAction.viewTaggedThreads, element);
        },
      ));
    });
  }
  s.add(TextButton(
    child: Text(timeHelper(p.timeElapsedSincePostMs)),
    //textColor: Colors.white,
    //color: Colors.green,
    onPressed: () {},
  ));

  /*s += '<dt>' +
      linkFakeButtonHelper('/t/' + p.shortLink, tl, p.softNick, '') +
      '</dt>';*/

  //return s + '</dl></div>';
  return ButtonBar(
    alignment: MainAxisAlignment.start,
    buttonPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    buttonMinWidth: 30,
    children: s,
  );
}

String articlePostCommentsHelper(ModeratorEntry p, List<ModeratorEntry> l) {
  if (l.isEmpty) return 'Comment now';
  return l.length.toString() + ' comments';
}
