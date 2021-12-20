class MODERATOR_LOC {
  String threadNotAvailable = 'thread not available';
  String threadsNotAvailable = 'all threads lost.fuck';
  String mentionAuthorContentNotAvailable = 'no mentions found for ';
  String authorContentNotAvailable = 'no treads found for ';
  String moderatorUserWidgetSaid = ' said:';
  String defaultVisitorNick = 'guest';
  String defaultVisitorAvatar = '🤓';
  String postBoxNewThread = 'new thread';
  String postBoxNick = 'nick';
  String postBoxNickPlaceholder = 'choose a nickname';
  String postBoxAvatar = 'avatar';
  String postBoxCommentLabel = 'write a comment to this thread';
  String postBoxCommentPlaceholder = 'write your comment here';
  String mute = 'mute';
  String likeButton = 'love';
  String likeAmount = ' likes';
  String dropButton = 'trash';
  List<List<String>> navigation = [
    ['mailbox', ':me', 'people mentioning you'],
    //['moderator', 'moderator', '#moderator foorumi ideat ym '],
    //['omasome', 'omasome', 'omasome jutut #omasome'],
    ['buugi', 'buugi', '#buugi, whats going on with you?'],
    ['latest', 'all', 'lastest brainfarts on omasome']
  ];
  String landingTag = 'all';
  String htmlTitle = 'omasome proto';
  String htmlDescription = 'omasome.fi';
  String siteUrl = 'https://www.omasome.fi';
  String siteName = 'omasome';
  String siteHeaderText = "omasome.fi";
  String defaultAuthorNick = "friend";
  String defaultAuthorAvatar = '🐼';
  String cssBase = 'Qmb7FX6rAMEXtJqWD95MSUJnJ4h1c759BPJGk3wFroZBWj';
  List<String> groupLinkButton = ['see this collection', 'g'];
  String groupLinkButtonText = 'here';
  String backstageSubdomain = 'club';
  List<List<String>> backstageNavigation = [
    ['mailbox', ':me', 'people mentioning you'],
    //['moderator', 'moderator', '#moderator foorumi ideat ym '],
    //['omasome', 'omasome', 'omasome jutut #omasome'],
    ['buugi', 'buugi', '#buugi, whats going on with you?'],
    ['latest', 'all', 'lastest brainfarts on omasome']
  ];
  Set<String> disallowWithNoAttachements = {'chonkynsfw', 'nsfw'};
  bool produceNSFW = false;
  bool displayNSFW = false;
  /*List<String> threadsUnlockNag = [
    'some galleries are exclusive to club chonky. click <a href="/join/',
    '">here</a> to join now!'
  ];
  List<String> threadUnlockNag = [
    'this galley is exclusive to club chonky. click <a href="/join/<a href="/join/',
    '">here</a> to join now!'
  ];*/
  List<String> threadsUnlockNag = [
    'some galleries contain explicit adult images. click <form method="post" action="/join/',
    '"><button class="btn-link jlink" type="submit">unlock now</button></form> if you have no problem with this'
  ];
  List<String> threadUnlockNag = [
    'this gallery contains explicit adult images. click <form method="post" action="/join/',
    '"><button class="btn-link jlink" type="submit">unlock now</button></form> if if you have no problem with this'
  ];
  Set<String> reservedTags = {''}; //, '#wip'};
  int port = 9099;
  bool ghostMode = false; //no disk usage
  bool sandbox = true;
  String ipfsCss = ''; //QmZ9cm8LVafqDhtUpqM7voykAWcFzGfUFEwyYoH74WByZT';
  String ipfsJs = ''; //QmWRY7CSixnavYEv9kqAr2mYN9uEYE5gzNQJY26vxaucBk';
  bool twitterPreviewCards = false;
  String twitterPreviewCardTitle = 'now bubbling at omasome.fi';
  String twitterPostHandle = '@null';
  String mentioningMeNaviButton = 'mentioning ';
  String postBoxStartThread =
      'Feelzbox! Share a thought or a picture for us all to see. no account necessary.';
  String changeNickButton = 'change nick';
  String postBoxCommentButton = '💬 comment as';
  String postBoxStartThreadButton = '🌱 post as';
  Set<String> ignoredTagsOnBoot = {'boot', 'faq', 'test'};

  MODERATOR_LOC();
}
