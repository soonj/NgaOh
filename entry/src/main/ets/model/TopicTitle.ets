import { Expose, Transform, Type } from 'class-transformer';

export class TopicListBeanEntity {
  constructor(result: TopicListBeanResult | null, code: number, msg: string) {
    this.result = result;
    this.code = code;
    this.msg = msg;
  }
  result: TopicListBeanResult | null = null;
  code: number = 0;
  msg: string = "";
}

export class TopicListBeanResult {

  @Expose({name: 'iTRows'})
  __T__ROWS: number = 0;

  @Expose({name: 'iRows'})
  __ROWS: number = 0;

  @Expose({name: 'lT'})
  @Type(() => TopicListBeanResultT )
  __T: TopicListBeanResultT[] = [];

  @Expose({name: 'tF'})
  @Type(() => TopicListBeanResultF )
  __F: TopicListBeanResultF = new TopicListBeanResultF;


  tGlobal: TopicListBeanResultGlobal = new TopicListBeanResultGlobal;
  tCu: TopicListBeanResultCu = new TopicListBeanResultCu;
  iTRowsPage: number = 0;
  iRRowsPage: number = 0;
}

export class TopicListBeanResultT {
  constructor(fid: number, parent: TopicListBeanResultTParent | null, tpcurl: string, quoteFrom: number, author: string,
    subject: string, quoteTo: object | null, icon: number, postdate: number,
    topicMiscVar: TopicListBeanResultTTopicMiscVar | null,
    recommend: number, authorid: number, type: number, tid: number, replies: number, lastposter: string,
    lastpost: number, titlefont: string, topicMisc: string, lastmodify: number) {
    this.fid = fid;
    this.parent = parent;
    this.tpcurl = tpcurl;
    this.quoteFrom = quoteFrom;
    this.author = author;
    this.subject = subject;
    this.quoteTo = quoteTo;
    this.icon = icon;
    this.postdate = postdate;
    this.topicMiscVar = topicMiscVar;
    this.recommend = recommend;
    this.authorid = authorid;
    this.type = type;
    this.tid = tid;
    this.replies = replies;
    this.lastposter = lastposter;
    this.lastpost = lastpost;
    this.titlefont = titlefont;
    this.topicMisc = topicMisc;
    this.lastmodify = lastmodify;
  }

  fid: number;
  parent: TopicListBeanResultTParent | null;
  tpcurl: string;
  quoteFrom: number;
  author: string;
  subject: string;
  quoteTo: object | string | null;
  icon: number;
  postdate: number;
  topicMiscVar: TopicListBeanResultTTopicMiscVar | null;
  recommend: number;
  authorid: number;
  type: number;
  tid: number;
  replies: number;
  lastposter: string;
  lastpost: number;
  titlefont: string;
  topicMisc: string;
  lastmodify: number;

  static fromJson(json: Map<string, object | null>): TopicListBeanResultT {
    return new TopicListBeanResultT(
      json['fid'],
      json['parent'] ? TopicListBeanResultTParent.fromJson(json['parent']) : null,
      json['tpcurl'],
      json['quote_from'],
      json['author'] === false ? "" : (json['author'] || ""),
      json['subject'],
      json['quote_to'],
      json['icon'],
      json['postdate'],
      json['topic_misc_var'] ? TopicListBeanResultTTopicMiscVar.fromJson(json['topic_misc_var']) : null,
      json['recommend'],
      Number(json['authorid']),
      json['type'],
      json['tid'],
      json['replies'],
      json['lastposter'] === false ? "" : json['lastposter'],
      json['lastpost'],
      json['titlefont'],
      json['topic_misc'],
      json['lastmodify']
    );
  }

  toJson(): Map<string, number | string | null | object> {
    let data = new Map<string, number | string | null | object>();
    data.set("fid", this.fid);
    data.set("tpcurl", this.tpcurl);
    data.set("quote_from", this.quoteFrom);
    data.set("author", this.author);
    data.set("subject", this.subject);
    data.set("quote_to", this.quoteTo);
    data.set("icon", this.icon);
    data.set("postdate", this.postdate);
    data.set("recommend", this.recommend);
    data.set("authorid", this.authorid);
    data.set("type", this.type);
    data.set("tid", this.tid);
    data.set("replies", this.replies);
    data.set("lastposter", this.lastposter);
    data.set("lastpost", this.lastpost);
    data.set("titlefont", this.titlefont);
    data.set("topic_misc", this.topicMisc);
    data.set("lastmodify", this.lastmodify);
    if (this.parent) {
      data['parent'] = this.parent.toJson();
    }
    if (this.topicMiscVar) {
      data['topic_misc_var'] = this.topicMiscVar.toJson();
    }
    return data;
  }
}

export class TopicListBeanResultTParent {
  data: object;

  constructor(data: object) {
    this.data = data;
  }

  static fromJson(json: object): TopicListBeanResultTParent {
    return new TopicListBeanResultTParent(json);
  }

  toJson(): object {
    return this.data;
  }
}

export class TopicListBeanResultTTopicMiscVar {
  data: object;

  constructor(data: object) {
    this.data = data;
  }

  static fromJson(json: object): TopicListBeanResultTTopicMiscVar {
    return new TopicListBeanResultTTopicMiscVar(json);
  }

  toJson(): object {
    return this.data;
  }
}

export class TopicListBeanResultF {

  fid: number = 0;

  // sub_forums: Map<string, Array<number | string | null>> = "";

  toppedTopic: number = 0;
}

// export function transferSubBoards(value: Map<string, Array<number | string | null>>) {
//   let subBoardMap: Map<string, Array<number | string | null>> = JSON.parse(value);
//   let subBoards: BoardInfo[] = [];
//   subBoardMap.forEach((v, k) => {
//     subBoards.push(new BoardInfo(v[1]?.toString(), Number(v[0])));
//   })
// }

export class TopicListBeanResultGlobal {
  @Expose({ name: "sAttachBaseView"})
  _ATTACH_BASE_VIEW: string = "";
}

export class TopicListBeanResultCu {
  rvrc: number = 0;
  uid: number = 0;
  @Expose({name: "groupBit"})
  group_bit: number = 0;
  admincheck: number = 0;

}
