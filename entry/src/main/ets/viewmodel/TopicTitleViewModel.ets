import { http } from '@kit.NetworkKit';
import { CommonConstants, HttpCode } from '../common/constants/CommonConstant';
import { httpRequestGet } from '../common/utils/HttpUtil';
import PreferencesUtil from '../common/utils/PreferencesUtil';
import { convertAnonymousName } from '../common/utils/StringUtil';
import { Board } from '../model/Board';
import { BoardInfo } from '../model/BoardInfo';
import ResponseResult from '../model/Response';
import { TopicListBeanEntity, TopicListBeanResult, TopicListBeanResultT } from '../model/TopicTitle';
import { TopicTitleInfo } from '../model/TopicTitleInfo';
import { LengthMetrics } from '@kit.ArkUI';
import util from '@ohos.util';
import { JSON } from '@kit.ArkTS';

const MASK_FONT_RED = 1;
const MASK_FONT_BLUE = 2;
const MASK_FONT_GREEN = 4;
const MASK_FONT_ORANGE = 8;
const MASK_FONT_SILVER = 16;
const MASK_FONT_BOLD = 32;
const MASK_FONT_ITALIC = 64;
const MASK_FONT_UNDERLINE = 128;

// 主题被锁定 2^10
const MASK_TYPE_LOCK = 1024;
// 主题中有附件 2^13
const MASK_TYPE_ATTACHMENT = 8192;
// 合集 2^15
const MASK_TYPE_ASSEMBLE = 32768;

const REGEX_TCP_URL_TID = /tid=([0-9]+)/;

export class TopicTitleViewModel {
  private _hasNextPage: boolean = false;

  loadPage(board: BoardInfo, page: number): Promise<TopicListBeanResult> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url: string = this._buildUrl(board ,page);
      httpRequestGet(url, this._buildParam(board, page), await this._buildHeader()).then((data) => {
        if (data.code !== HttpCode.SUCCESS) {
          reject(data);
        } else {
          resolve(data.result);
        }
      }).catch((code: number) => {
        reject(code);
      });
    });
  }

  static _convertToTopicTitleInfo(bean: TopicListBeanResultT): TopicTitleInfo {
    const topicEntity = new TopicTitleInfo();
    topicEntity.title = bean.subject;
    topicEntity.tid = bean.tid;
    topicEntity.isAnonymous = bean.author.startsWith('#anony_');
    topicEntity.author = topicEntity.isAnonymous
      ? convertAnonymousName(bean.author)
      : bean.author;
    topicEntity.replyCount = bean.replies;
    topicEntity.lastReplyTime = _buildDate(bean.lastpost);

    const parentBoardInfo = bean.parent?.data;
    topicEntity.parentBoard = parentBoardInfo ? (parentBoardInfo[2] || '') : '';

    const type = bean.type;
    topicEntity.isLocked = (type & MASK_TYPE_LOCK) === MASK_TYPE_LOCK;
    topicEntity.isAssemble = (type & MASK_TYPE_ASSEMBLE) === MASK_TYPE_ASSEMBLE;

    topicEntity.titleStyle = _convertTextStyle(bean.topicMisc);

    if (bean.tpcurl) {
      const match = REGEX_TCP_URL_TID.exec(bean.tpcurl);
      if (match && match[1]) {
        topicEntity.tid = parseInt(match[1], 10);
      }
    }

    return topicEntity;
  }

  hasNextPage(): boolean {
    return this._hasNextPage;
  }

  private _buildUrl(board?: BoardInfo, page?: number): string {
    return `${CommonConstants.HOST}/thread.php?fid=${board?.fid}&page=${page}`;
  }

  private _buildParam(board: BoardInfo, page: number): Record<string, object | string | number> {
    let param: Record<string, object | string | number> = { "__output": '14', "page": page };

    if (board.favor) {
      param.favor = '1';
    } else {
      if (board.stid !== 0) {
        param.stid = board.stid;
      } else if (board.fid !== 0) {
        param.fid = board.fid;
      }

      if (board.recommend) {
        param.recommend = '1';
        param.order_by = 'postdatedesc';
        param.user = '1';
      }
    }
    return param;
  }

  private async _buildHeader(): Promise<Record<string, string>> {
    let cookie = await PreferencesUtil.getPreferenceValue(CommonConstants.COOKIE_TITLE, CommonConstants.G_EMPTY);
    if (cookie == CommonConstants.G_EMPTY) {

    }
    return { "Cookie": cookie.toString() };
  }
}

function _buildDate(milliseconds: number): string {
  const now = new Date();
  const postDate = new Date(milliseconds * 1000);
  const diff = now.getTime() - postDate.getTime();

  if (diff >= 365 * 24 * 60 * 60 * 1000) {
    return `${postDate.getFullYear()}-${String(postDate.getMonth() + 1).padStart(2, '0')}-${String(postDate.getDate())
      .padStart(2, '0')}`;
  } else if (diff >= 24 * 60 * 60 * 1000) {
    return `${String(postDate.getMonth() + 1).padStart(2, '0')}-${String(postDate.getDate()).padStart(2, '0')}`;
  } else if (diff >= 60 * 60 * 1000) {
    return `${Math.floor(diff / (60 * 60 * 1000))}小时前`;
  } else if (diff >= 60 * 1000) {
    return `${Math.floor(diff / (60 * 1000))}分钟前`;
  } else {
    return '刚刚';
  }
}

function _convertTextStyle(misc: string | null): TextStyle {
  if (!misc) {
    let textStyle = new TextStyle({fontSize: new LengthMetrics(17)});
    return textStyle;
  }

  while (misc.length % 4 !== 0) {
    misc += '=';
  }

  let that = new util.Base64Helper();
  let waitDecodeArr = that.decodeSync(misc)
  let base64Decoder = util.TextDecoder.create('base64')
  let utf8Decoder = util.TextDecoder.create('utf-8')
  let bytes = base64Decoder.decodeToString(waitDecodeArr)
  waitDecodeArr = that.decodeSync(bytes)
  let value = utf8Decoder.decodeToString(waitDecodeArr);
  let pos = 0;
  let fontWeight = 'normal';
  let color = 'black';
  let fontStyle = FontStyle.Normal;

  if (pos < bytes.length && bytes[pos] === '1') {
    const data = parseInt(value.substring(8), 2);
    if ((data & MASK_FONT_GREEN) === MASK_FONT_GREEN) {
      color = 'green';
    }
    if ((data & MASK_FONT_BLUE) === MASK_FONT_BLUE) {
      color = 'blue';
    }
    if ((data & MASK_FONT_RED) === MASK_FONT_RED) {
      color = 'red';
    }
    if ((data & MASK_FONT_ORANGE) === MASK_FONT_ORANGE) {
      color = 'orange';
    }
    if ((data & MASK_FONT_SILVER) === MASK_FONT_SILVER) {
      color = '#E6E8FA';
    }

    if ((data & MASK_FONT_BOLD) === MASK_FONT_BOLD) {
      fontWeight = 'bold';
    }
    if ((data & MASK_FONT_ITALIC) === MASK_FONT_ITALIC) {
      fontStyle = FontStyle.Italic;
    }

    pos += 4;
  }

  return new TextStyle({
    fontSize: new LengthMetrics(17),
    fontColor: color,
    fontStyle: fontStyle,
    fontWeight: fontWeight});
}


