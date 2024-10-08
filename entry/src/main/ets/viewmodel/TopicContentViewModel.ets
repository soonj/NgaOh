import { CommonConstants } from '../common/constants/CommonConstant';
import { HtmlDecoderManager } from '../common/utils/HtmlUtil';
import { httpRequestGet } from '../common/utils/HttpUtil';
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

export class TopicContentViewModel {
  // addFavorite(tid: number): Promise<void> {
  //   const url = `https://bbs.nga.cn/nuke.php?__lib=topic_favor&__output=8&noprefix&__act=topic_favor&action=add&tid=${tid}`;

  // let param: Map<string, string | number> = {
  //   "__output": '8',
  //   "__lib": 'topic_favor',
  //   "__act": 'topic_favor',
  //   "action": 'add',
  //   "tid": tid,
  // };

  // try {
  //   const response: AxiosResponse = await this.dio.post(url, null, { ...config, params: param });
  //   console.log(result);
  // } catch (error) {
  //   console.error(error);
  // }
  // }

  loadContent(tid: number, page: number): Promise<TopicContentEntity> {
    return new Promise((resolve: Function, reject: Function) => {
      let url: string = this._buildUrl(tid, page);

      httpRequestGet(url, this._buildParam(), this._buildHeader()).then((data) => {
        if (data.code === 1) {
          reject("error");
        } else {
          // resolve(data.result);
          let result: TopicContentResult = data.result as TopicContentResult;

          let entity: TopicContentEntity = new TopicContentEntity;
          let htmlDecoder = new HtmlDecoderManager();
          try {
            this._convertDataMap(result);
            this._convertAuthorMap(result, entity);
            Object.keys(result.data.__R).forEach((key) => {
              let v = Object(result.data.__R)[key] as TopicContentBeanDataRR;
              let rowEntity: TopicRowEntity = new TopicRowEntity;
              let louIndex: number = v.lou;
              rowEntity.content = htmlDecoder.decode(v.content);
              rowEntity.subject = v.subject;
              rowEntity.postDate = v.postdate;
              rowEntity.floor = `${louIndex}楼`;
              rowEntity.pid = v.pid.toString();
              rowEntity.page = page;
              let uid: string = v.authorid.toString();
              rowEntity.author = entity.authorMap[uid];
              rowEntity.isHidden = rowEntity.content == "" && v.alterinfo == "";
              this._convertDeviceType(v, rowEntity);
              this._convertComment(v, entity, rowEntity);
              this._convertAttachment(v, result.data.__GLOBAL._ATTACH_BASE_VIEW, rowEntity);
              entity.contentList.push(rowEntity);

            });
            entity.totalPage = Math.ceil(result.data.__ROWS / 20);
            entity.topicTitle = result.data.__T.subject;
            resolve(entity);
          } catch (error) {
            console.log("convertError" + error);
            reject("convertError");
          }
        }
      }).catch(() => {
        reject("loadContent Error");
      });
    });
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
    let authorMap: Map<string, TopicAuthorEntity> = new Map;
    Object.keys(dataBean.data.__U.dataMap).forEach((key) => {
      let uidBeanData: TopicContentBeanDataUid = Object(dataBean.data.__U.dataMap)[key] as TopicContentBeanDataUid;
      let uid = key
      let authorEntity = new TopicAuthorEntity(uidBeanData.username, uid, uidBeanData.avatar);
      authorEntity.postCount = uidBeanData.postnum;
      if (uidBeanData.rvrc != null) {
        authorEntity.reputation = uidBeanData.rvrc / 10.0;
      }
      const memberId = uidBeanData.memberid;
      authorEntity.level = dataBean.data.__U.__GROUPS[memberId]["0"];
      authorMap[uid] = authorEntity;
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
      commentEntity.authorEntity = contentEntity.authorMap[bean.authorid.toString()];
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


  private _buildUrl(tid: number, page: number = 1): string {
    return `https://bbs.nga.cn/read.php?__output=8&tid=${tid}&page=${page}`;
  }

  _buildWebViewUrl(tid: number, page: number = 1): string {
    return `https://bbs.nga.cn/read.php?tid=${tid}&page=${page}`;
  }

  private _buildParam(): Record<string, string | number> {
    return {
      "__output": '8'
    };
  }

  private _buildHeader(): Record<string, string> {
    let cookie = PreferencesUtil.getPreferenceValue(CommonConstants.COOKIE_TITLE, CommonConstants.G_EMPTY);
    return { "Cookie": cookie.toString() };
  }
}

class HtmlConvertFactory {
  static async convert2Html(entity: TopicContentEntity): Promise<string> {
    // Implement HTML conversion logic
    return '';
  }
}
