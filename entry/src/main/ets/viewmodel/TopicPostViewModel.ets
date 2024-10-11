import { CommonConstants, HttpCode } from '../common/constants/CommonConstant';
import { httpRequestGet, httpRequestPost } from '../common/utils/HttpUtil';
import PreferencesUtil from '../common/utils/PreferencesUtil';
import { TopicPostParam } from '../model/TopicPost';
import { preferences } from '@kit.ArkData';

export class TopicPostViewModel {

  post(postEntity: TopicPostParam): Promise<boolean> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url: string = this._buildUrl(postEntity);
      let param: Record<string, number> = {"page": 1 };
      httpRequestPost(url, param, await this._buildHeader()).then((data) => {
        if (data.code !== HttpCode.SUCCESS) {
          reject(false);
        } else {
          resolve(true);
        }
      }).catch(() => {
        reject(false);
      });
    });
  }

  private _buildUrl(postEntity: TopicPostParam): string {
    return "https://bbs.nga.cn/post.php?" + postEntity.toUrlString();
  }

  private async _buildHeader(): Promise<Record<string, string>> {
    let cookies = await PreferencesUtil.getPreferenceValue(CommonConstants.COOKIE_TITLE, CommonConstants.G_EMPTY);
    let header: Record<string, string> = {
      "Cookie" : cookies.toString(),
      "Accept-Charset" : "GBK",
      "Content-Type" : "application/x-www-form-urlencode",
      "User-Agent" : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36"
    };
    return header;
  }
}