class MODERATOR_LOC {
  String threadNotAvailable = 'thread not available';
  String threadsNotAvailable = 'all threads lost.fuck';
  String moderatorUserWidgetSaid = ' said:';
  String defaultVisitorNick = 'guest';
  String defaultVisitorAvatar = '🤓';
  String postBoxNewThread = 'new thread';
  String postBoxNick = 'nick';
  String postBoxNickPlaceholder = 'choose a nickname';
  String postBoxAvatar = 'avatar';
  String postBoxCommentButton = '💬 comment as';
  String postBoxCommentLabel = 'write a comment to this thread';
  String postBoxCommentPlaceholder = 'write your comment here';
  String mute = 'mute';
  String likeButton = 'love';
  String likeAmount = ' likes';
  String dropButton = 'trash';
  List<List<String>> navigation = [
    //['talk!', 'talk', 'free conversation. ask something, make a comment.'],
    ['mailbox', ':me', 'people mentioning you'],
    [
      'club chonky',
      'club',
      'join the club by saying hello! you can reply to anybody without an account.Go for it.'
    ],
    [
      'art',
      'drawings',
      'latest sketches by chonky. the loveliest boys on the planet!'
    ]
  ];

  String landingTag = 'chonky';
  String htmlTitle = '';
  String htmlDescription = 'club.chonky.rocks';
  String siteUrl = 'https://club.chonky.rocks';
  String siteName = 'clubchonky';
  String siteHeaderText = "club chonky loves big boys";
  String defaultAuthorNick = "chonky";
  String defaultAuthorAvatar = '🐼';
  String postBoxStartThread =
      'Feelzbox! Share a thought or a picture for us all to see. no account necessary.';
  String postBoxStartThreadButton = 'post as';

  String cssBase = '';
  List<String> groupLinkButton = ['see this collection', 'g'];
  String groupLinkButtonText = 'here';
  String backstageSubdomain = 'club';
  List<List<String>> backstageNavigation = [
    //['talk!', 'talk', 'free conversation. ask something, make a comment.'],
    ['mailbox', ':me', 'people mentioning you'],
    [
      'club talk',
      'all',
      'join the club by saying hello! you can reply to anybody without an account.Go for it.'
    ]
  ];
  Set<String> disallowWithNoAttachements = {'chonkynsfw', 'nsfw'};
  bool produceNSFW = true;
  bool displayNSFW = true;

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
  Set<String> reservedTags = {'#chonky'}; //, '#wip'};
  int port = 9114;
  bool ghostMode = false; //no disk usage
  bool showOnlyLocallyAuthored = true;
  bool sandbox = false;
  String ipfsCss = ''; //QmZ9cm8LVafqDhtUpqM7voykAWcFzGfUFEwyYoH74WByZT';
  String ipfsJs = ''; //QmWRY7CSixnavYEv9kqAr2mYN9uEYE5gzNQJY26vxaucBk';
  bool twitterPreviewCards = true;
  String twitterPreviewCardTitle = 'beautiful new drawings at chonky.rocks';
  String twitterPostHandle = '@polarbear1234';
  String mentionAuthorContentNotAvailable = 'no mentions found for @';
  String authorContentNotAvailable = 'no threads found for /';
  String mentioningMeNaviButton = 'mentioning ';
  String changeNickButton = 'change nick';
  Set<String> ignoredTagsOnBoot = {'boot', 'faq', 'test'};
  MODERATOR_LOC();
}
