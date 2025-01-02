import { convertAnonymousName } from '../common/utils/StringUtil';

export class TopicContentResult {
  constructor(data: Data, encode: string, time: number) {
    this.data = data;
    this.encode = encode;
    this.time = time;
  }

  data: Data;
  encode: string;
  time: number;
}

export class __CU {
  constructor(uid: number, group_bit: number, admincheck: string, rvrc: number) {
    this.uid = uid;
    this.group_bit = group_bit;
    this.admincheck = admincheck;
    this.rvrc = rvrc;
  }

  uid: number;
  group_bit: number;
  admincheck: string;
  rvrc: number;
}

export class __GLOBAL {
  constructor(ATTACH_BASE_VIEW: string) {
    this._ATTACH_BASE_VIEW = ATTACH_BASE_VIEW;
  }

  _ATTACH_BASE_VIEW: string;
}

export class TopicContentBeanDataUid {
  constructor(uid: number, username: string, credit: number, medal: string, reputation: string, groupid: number,
    memberid: number, avatar: string, yz: number, site: string, honor: string, regdate: number, mute_time: string,
    postnum: number, rvrc: number, money: number, thisvisit: number, signature: string, nickname: string,
    bit_data: number) {
    this.uid = uid;
    this.username = username;
    this.credit = credit;
    this.medal = medal;
    this.reputation = reputation;
    this.groupid = groupid;
    this.memberid = memberid;
    this.avatar = avatar;
    this.yz = yz;
    this.site = site;
    this.honor = honor;
    this.regdate = regdate;
    this.mute_time = mute_time;
    this.postnum = postnum;
    this.rvrc = rvrc;
    this.money = money;
    this.thisvisit = thisvisit;
    this.signature = signature;
    this.nickname = nickname;
    this.bit_data = bit_data;
  }

  uid: number;
  username: string;
  credit: number;
  medal: string;
  reputation: string;
  groupid: number;
  memberid: number;
  avatar: string;
  yz: number;
  site: string;
  honor: string;
  regdate: number;
  mute_time: string;
  postnum: number;
  rvrc: number;
  money: number;
  thisvisit: number;
  signature: string;
  nickname: string;
  bit_data: number;
}

export class TopicContentBeanDataAttachment {
  constructor(attachurl: string, size: number, type: string, subid: number, url_utf8_org_name: string, dscp: string,
    path: string, name: string, ext: string, thumb: number) {
    this.attachurl = attachurl;
    this.size = size;
    this.type = type;
    this.subid = subid;
    this.url_utf8_org_name = url_utf8_org_name;
    this.dscp = dscp;
    this.path = path;
    this.name = name;
    this.ext = ext;
    this.thumb = thumb;
  }

  attachurl: string;
  size: number;
  type: string;
  subid: number;
  url_utf8_org_name: string;
  dscp: string;
  path: string;
  name: string;
  ext: string;
  thumb: number;
}

export class TopicContentBeanDataU {
  constructor(_GROUPS: Map<string, Map<string, string | number>>,
    _REPUTATIONS: Map<string, Map<string, string | number>>, dataMap: Map<string, TopicContentBeanDataUid>) {
    this.__GROUPS = _GROUPS;
    this.__REPUTATIONS = _REPUTATIONS;
    this.dataMap = dataMap;
  }
  //等级
  __GROUPS: Map<string, Map<string, string | number>>;
  __REPUTATIONS: Map<string, Map<string, string | number>>;
  dataMap: Map<string, TopicContentBeanDataUid>;
}

export class TopicContentBeanDataRR {
  constructor(pid: number, fid: number, tid: number, authorid: number, type: number, score: number, score_2: number,
    recommend: number, postdate: string, subject: string, alterinfo: string, content: string, lou: number,
    content_length: number, attachs: Map<string, TopicContentBeanDataAttachment>, from_client: string,
    postdatetimestamp: number, comment: Map<string, string>, comments: Array<TopicContentBeanDataComment>,
    attachments: Array<TopicContentBeanDataAttachment>) {
    this.pid = pid;
    this.fid = fid;
    this.tid = tid;
    this.authorid = authorid;
    this.type = type;
    this.score = score;
    this.score_2 = score_2;
    this.recommend = recommend;
    this.postdate = postdate;
    this.subject = subject;
    this.alterinfo = alterinfo;
    this.content = content;
    this.lou = lou;
    this.content_length = content_length;
    this.attachs = attachs;
    this.from_client = from_client;
    this.postdatetimestamp = postdatetimestamp;
    this.comment = comment;
    this.comments = comments;
    this.attachments = attachments;
  }
  pid: number;
  fid: number;
  tid: number;
  authorid: number;
  type: number;
  score: number;
  score_2: number;
  recommend: number;
  postdate: string;
  subject: string;
  alterinfo: string;
  content: string;
  lou: number;
  content_length: number;
  attachs: Map<string, TopicContentBeanDataAttachment>
  from_client: string;
  postdatetimestamp: number;
  comment: Map<string, string>;
  comments: Array<TopicContentBeanDataComment>;
  attachments: Array<TopicContentBeanDataAttachment>;
}

export class TopicContentBeanDataR {
  constructor(topicContentBeanData: Map<string, TopicContentBeanDataRR>) {
    this.topicContentBeanData = topicContentBeanData;
  }

  topicContentBeanData: Map<string, TopicContentBeanDataRR>
}

export class Post_misc_var {
  constructor(content_length: number, fid: number) {
    this.content_length = content_length;
    this.fid = fid;
  }

  content_length: number;
  fid: number;
}

export class TopicContentBeanDataT {
  constructor(fid: number, tid: number, topic_misc: string, subject: string, locked: number, recommend: number,
    quote_to: string, quote_from: number, type: number, replies: number, authorid: number, postdate: number,
    lastpost: number, jdata: string, author: string, lastposter: string, digest: number, lastmodify: number,
    tpid: number, post_misc_var: Post_misc_var, this_visit_rows: number) {
    this.fid = fid;
    this.tid = tid;
    this.topic_misc = topic_misc;
    this.subject = subject;
    this.locked = locked;
    this.recommend = recommend;
    this.quote_to = quote_to;
    this.quote_from = quote_from;
    this.type = type;
    this.replies = replies;
    this.authorid = authorid;
    this.postdate = postdate;
    this.lastpost = lastpost;
    this.jdata = jdata;
    this.author = author;
    this.lastposter = lastposter;
    this.digest = digest;
    this.lastmodify = lastmodify;
    this.tpid = tpid;
    this.post_misc_var = post_misc_var;
    this.this_visit_rows = this_visit_rows;
  }

  fid: number;
  tid: number;
  topic_misc: string;
  subject: string;
  locked: number;
  recommend: number;
  quote_to: string;
  quote_from: number;
  type: number;
  replies: number;
  authorid: number;
  postdate: number;
  lastpost: number;
  jdata: string;
  author: string;
  lastposter: string;
  digest: number;
  lastmodify: number;
  tpid: number;
  post_misc_var: Post_misc_var;
  this_visit_rows: number;
}

export class TopicContentBeanDataF {
  constructor(name: string) {
    this.name = name;
  }

  name: string;
}

export class Data {
  constructor(_CU: __CU, _GLOBAL: __GLOBAL, _U: TopicContentBeanDataU,
    _R: Map<string, TopicContentBeanDataRR>, _T: TopicContentBeanDataT, _F: TopicContentBeanDataF, _R__ROWS: number,
    _R__ROWS_PAGE: number, _ROWS: number, _PAGE: number) {
    this.__CU = _CU;
    this.__GLOBAL = _GLOBAL;
    this.__U = _U;
    this.__R = _R;
    this.__T = _T;
    this.__F = _F;
    this.__R__ROWS = _R__ROWS;
    this.__R__ROWS_PAGE = _R__ROWS_PAGE;
    this.__ROWS = _ROWS;
    this.__PAGE = _PAGE;
  }
  __CU: __CU;
  __GLOBAL: __GLOBAL;
  __U: TopicContentBeanDataU;
  __R: Map<string, TopicContentBeanDataRR>;
  __T: TopicContentBeanDataT;
  __F: TopicContentBeanDataF;
  __R__ROWS: number;
  __R__ROWS_PAGE: number;
  __ROWS: number;
  __PAGE: number;
}

export class TopicContentBeanDataComment {
  fid: number = 0;
  tid: number = 0;
  pid: number = 0;
  authorid: number = 0;
  postdate: string = "";
  content: string = "";
  from_client: string = "";
  lou: number = 0;
}

export class TopicContentEntity {
  contentList: TopicRowEntity[] = [];
  authorMap: Map<number, TopicAuthorEntity> = new Map;
  htmlContent: string = "";
  topicTitle: string = "";
  totalPage: number = 0;
}

export class TopicRowEntity {

  content: string = "";
  author: TopicAuthorEntity = new TopicAuthorEntity("", 0, "");
  floor: string = "";
  deviceType: Array<number | string> = new Array;
  postDate: string = "";
  subject: string = "";
  isHidden: boolean = false;
  tid: number = 0;
  pid: number = 0;
  page: number = 0;
  commentList: CommentEntity[] = [];
  attachList: AttachmentEntity[] = [];
  topicOwner: string = "";
  quote: string = "";
  score: number = 0;
}

export class CommentEntity {

  content: string = "";
  postDate: string = "";
  authorEntity: TopicAuthorEntity = new TopicAuthorEntity("", 0, "");
}

export class AttachmentEntity {
  attachUrl: string = "";
  name: string = "";
}

export class TopicAuthorEntity {
  constructor(userName: string, uid: number, avatarUrl: string) {
    if (userName.startsWith("#anony_")) {
      this.isAnonymous = true;
      this.userName = convertAnonymousName(userName);
    } else {
      this.isAnonymous = false;
      this.userName = userName;
    }
    this.uid = uid;
    this.avatarUrl = avatarUrl;
  }

  userName = "";
  isAnonymous = false;
  uid = 0;
  avatarUrl = "";
  level = "";
  postCount = 0;
  reputation = 0;
}
