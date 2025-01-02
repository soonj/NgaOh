import { CommonConstants, HttpCode } from '../common/constants/CommonConstant';
import { HtmlDecoderManager } from '../common/utils/HtmlUtil';
import { httpRequestGet, httpRequestPost } from '../common/utils/HttpUtil';
import PreferencesUtil from '../common/utils/PreferencesUtil';
import {
  AttachmentEntity,
  CommentEntity,
  TopicAuthorEntity,
  TopicContentBeanDataRR,
  TopicContentBeanDataUid,
  TopicContentEntity,
  TopicContentResult,
  TopicRowEntity
} from '../model/TopicContent';
import { JSON } from '@kit.ArkTS';
import json from '@ohos.util.json';
import { ArticleListParam } from '../param/ArticleListParam';

export class TopicContentViewModel {

  // loadContent(tid: number, page: number): Promise<TopicContentEntity> {
  loadContent(articleListParam: ArticleListParam): Promise<TopicContentEntity> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url: string = this._buildUrl(articleListParam);
      httpRequestGet(url, this._buildParam(), await this._buildHeader()).then((data) => {
        if (data.code !== HttpCode.SUCCESS) {
          reject(data.code);
        } else {
          try {
            let entity = this._parseResult(data.result, articleListParam);
            resolve(entity);
          } catch (error) {
            reject(HttpCode.PARSE_ERROR);
          }
        }
      }).catch((code: number) => {
        reject(code);
      });
    });
  }

  like(tid: number, pid: number, like: number): Promise<string> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url: string = this._likeUrl(tid, pid, like);
      httpRequestPost(url, this._buildParam(), await this._buildHeader()).then((data) => {
        if (data.code !== HttpCode.SUCCESS) {
          reject(data.code);
        } else {
          try {
            resolve("发送成功");
          } catch (error) {
            reject(HttpCode.PARSE_ERROR);
          }
        }
      }).catch((code: number) => {
        reject(code);
      });
    });
  }

  private _parseResult(resultObject: string | Object | ArrayBuffer, articleListParam: ArticleListParam): TopicContentEntity {
    let result: TopicContentResult = resultObject as TopicContentResult;
    let entity: TopicContentEntity = new TopicContentEntity;
    let htmlDecoder = new HtmlDecoderManager();
    this._convertDataMap(result);
    this._convertAuthorMap(result, entity);
    let topicOwner = "";
    Object.keys(result.data.__R).forEach((key) => {
      let v = Object(result.data.__R)[key] as TopicContentBeanDataRR;
      let rowEntity: TopicRowEntity = new TopicRowEntity;
      let louIndex: number = v.lou;
      let contentArray: string[] = htmlDecoder.decodeWithQuote(v.content);
      if (contentArray.length > 1) {
        rowEntity.quote = contentArray[1];
      }
      rowEntity.content = contentArray[0];
      rowEntity.subject = v.subject;
      rowEntity.postDate = v.postdate;
      rowEntity.floor = `${louIndex}楼`;
      rowEntity.pid = v.pid;
      rowEntity.tid = v.tid;
      rowEntity.page = articleListParam.page;
      rowEntity.score = v.score;
      rowEntity.author = entity.authorMap[v.authorid];
      if (v != null && louIndex == 0) {
        rowEntity.topicOwner = rowEntity.author.userName;
        topicOwner = rowEntity.author.userName;
      } else if (topicOwner != "") {
        rowEntity.topicOwner = topicOwner;
      }
      rowEntity.isHidden = rowEntity.content == "" && v.alterinfo == "";
      this._convertDeviceType(v, rowEntity);
      this._convertComment(v, entity, rowEntity);
      this._convertAttachment(v, result.data.__GLOBAL._ATTACH_BASE_VIEW, rowEntity);
      entity.contentList.push(rowEntity);

    });
    entity.totalPage = Math.ceil(result.data.__ROWS / 20);
    entity.topicTitle = result.data.__T.subject;
    return entity;
  }

  private _convertDeviceType(dataBean: TopicContentBeanDataRR, entity: TopicRowEntity): void {
    const fromClient = dataBean.from_client;
    if (!fromClient) {
      return;
    }

    const client = fromClient.split(' ');
    entity.deviceType = [parseInt(client[0], 10), client[1]];
  }

  private _convertAuthorMap(dataBean: TopicContentResult, entity: TopicContentEntity): void {
    let authorMap: Map<number, TopicAuthorEntity> = new Map;
    Object.keys(dataBean.data.__U.dataMap).forEach((key) => {
      let uidBeanData: TopicContentBeanDataUid = Object(dataBean.data.__U.dataMap)[key] as TopicContentBeanDataUid;
      let uidInt = parseInt(key);
      if (isNaN(uidInt)) {
        uidInt = 0;
      }
      let authorEntity = new TopicAuthorEntity(uidBeanData.username, uidInt, uidBeanData.avatar);
      authorEntity.postCount = uidBeanData.postnum;
      if (uidBeanData.rvrc != null) {
        authorEntity.reputation = uidBeanData.rvrc / 10.0;
      }
      const memberId = uidBeanData.memberid;
      authorEntity.level = dataBean.data.__U.__GROUPS[memberId]["0"];
      authorMap[uidInt] = authorEntity;
    });
    entity.authorMap = authorMap;
  }

  private _convertDataMap(dataBean: TopicContentResult): void {
    let dataMap: Map<string, TopicContentBeanDataUid> = new Map;
    Object.keys(dataBean.data.__U).forEach((key) => {
      if (key != '__GROUPS' && key != '__MEDALS' && key != '__REPUTATIONS') {
        try {
          dataMap[key] = Object(dataBean.data.__U)[key] as TopicContentBeanDataUid;
        } catch (error) {
          console.log("convertDataMapError" + error);
        }
      }
    });
    dataBean.data.__U.dataMap = dataMap;
  }

  private _convertComment(dataBean: TopicContentBeanDataRR, contentEntity: TopicContentEntity,
    entity: TopicRowEntity): void {
    dataBean.comments?.forEach(bean => {
      if (!entity.commentList) {
        entity.commentList = [];
      }
      const commentEntity = new CommentEntity();
      commentEntity.content = bean.content;
      commentEntity.postDate = bean.postdate;
      commentEntity.authorEntity = contentEntity.authorMap[bean.authorid];
      entity.commentList.push(commentEntity);
    });
  }

  private _convertAttachment(dataBean: TopicContentBeanDataRR, baseUrl: string, entity: TopicRowEntity): void {
    dataBean.attachments?.forEach(bean => {
      if (!entity.attachList) {
        entity.attachList = [];
      }
      const attachmentEntity = new AttachmentEntity();
      attachmentEntity.name = bean.name;
      attachmentEntity.attachUrl = `http://${baseUrl}/${bean.attachurl}`;
      entity.attachList.push(attachmentEntity);
    });
  }


  private _buildUrl(articleListParam: ArticleListParam): string {
    let tid: number = articleListParam.tid;
    let pid: number = articleListParam.pid;
    let authorId: number = articleListParam.authorId;
    let page: number = articleListParam.page
    let url = `https://bbs.nga.cn/read.php?__output=8&noprefix&v2&page=${page}`;
    if (tid != 0) {
      url = url + `&tid=${tid}`;
    }
    if (pid != 0) {
      url = url + `&pid=${pid}`;
    }
    if (authorId != 0) {
      url = url + `&authorid=${authorId}`;
    }
    return url;
  }

  private _likeUrl(tid: number, pid: number = 1, like: number = 1): string {
    return `https://bbs.nga.cn/nuke.php?__lib=topic_recommend&__act=add&raw=3&__output=8&tid=${tid}&pid=${pid}&value=${like}`;
  }

  buildWebViewUrl(articleListParam: ArticleListParam): string {
    let tid: number = articleListParam.tid;
    let page: number = articleListParam.page
    return `https://bbs.nga.cn/read.php?tid=${tid}&page=${page}`;
  }

  private _buildParam(): Record<string, string | number> {
    return {
      "__output": '8'
    };
  }

  private async _buildHeader(): Promise<Record<string, string>> {
    let cookie = await PreferencesUtil.getPreferenceValue(CommonConstants.COOKIE_TITLE, CommonConstants.G_EMPTY);
    return { "Cookie": cookie.toString() };
  }
}
