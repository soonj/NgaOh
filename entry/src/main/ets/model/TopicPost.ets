import { util } from '@kit.ArkTS';

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
    let gbkContent: string = encodeURIComponent(this.postContent);
    let gbkSubject: string = encodeURIComponent(this.subject);

    let decoder = util.TextDecoder.create("gbk", {ignoreBOM:true});
    let gbkContentStr = decoder.decodeWithStream(new util.TextEncoder().encodeInto(gbkContent));
    let gbkSubjectStr = decoder.decodeWithStream(new util.TextEncoder().encodeInto(gbkSubject));
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