import { UriEncoderWithCharset } from '../common/utils/UriEncoderWithCharset';

export class TopicPostParam {

  static readonly TOPIC_POST_ACTION_NEW = "new"
  static readonly TOPIC_POST_ACTION_REPLY = "reply";
  static readonly TOPIC_POST_ACTION_MODIFY = "modify";
  postContent: string = "";
  tid: number = 0;
  pid: number = 0;
  fid: number = 0;
  action: string = "";
  subject: string = "";
  anonymous: boolean = false;

  toUrlString() {
    let gbkContentStr: string = UriEncoderWithCharset.encode(this.postContent, undefined, "gbk");
    let gbkSubjectStr: string = UriEncoderWithCharset.encode(this.subject, undefined, "gbk");;
    let urlStr =
        "step=2&&__output=14" +
        `&post_content=${gbkContentStr}` +
        `&action=${this.action}` +
        `&post_subject=${gbkSubjectStr ?? ""}` +
        `&tid=${this.tid ?? ""}` +
        `&fid=${this.fid ?? ""}` +
        `&pid=${this.pid ?? ""}` +
        `&anony=${this.anonymous ? 1 : 0}`;
    return urlStr;
  }
}