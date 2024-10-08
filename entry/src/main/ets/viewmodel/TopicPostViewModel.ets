import { CommonConstants } from '../common/constants/CommonConstant';
import { httpRequestPost } from '../common/utils/HttpUtil';
import PreferencesUtil from '../common/utils/PreferencesUtil';
import { TopicPostParam } from '../model/TopicPost';
import { preferences } from '@kit.ArkData';

export class TopicPostViewModel {

  post(postEntity: TopicPostParam): Promise<boolean> {
    return new Promise( (resolve: Function, reject: Function) => {
      let url: string = this._buildUrl(postEntity);
      httpRequestPost(url, "", this._buildHeader()).then((data) => {
        if (data.code === 1) {
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

  private _buildHeader(): Record<string, string> {
    let cookies = "";
    PreferencesUtil.getPreferenceValue(CommonConstants.COOKIE_TITLE, CommonConstants.G_EMPTY).then((cookie: preferences.ValueType) => {
      cookies = cookie as string;
    });
    let header: Record<string, string> = {
      "Cookie" : cookies,
      "Accept-Charset" : "GBK",
      "Content-Type" : "application/x-www-form-urlencode",
      "User-Agent" : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36"
    };
    return header;
  }
}