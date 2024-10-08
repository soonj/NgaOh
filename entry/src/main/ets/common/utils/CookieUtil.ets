import { CommonConstants } from '../constants/CommonConstant';
export class CookieUtil {
  public static parseCookie(cookieStr: string): boolean {
    let cookieStrList = cookieStr.split(';');
    let uid = "";
    let uName = "";
    let cid = "";
    let cookies: Map<string, string> = new Map<string, string>();
    if (!cookieStrList || cookieStrList.length === 0) {
      return false;
    }
    cookieStrList.forEach((cookie) => {
      let cookieKV = cookie.split('=');
      let cookieName = cookieKV[0];
      let cookieValue = cookieKV[1];
      if (cookieName && cookieValue) {
        cookies.set(cookieName, cookieValue);
      }

    });
    cookies.forEach((value, key) => {
      console.log(`Key: ${key}, Value: ${value}`);
      if (key == CommonConstants.COOKIE_KEY_UID) {
        uid = value;
      } else if (key == CommonConstants.COOKIE_KEY_UNAME) {
        uName = value;
      } else if (key == CommonConstants.COOKIE_KEY_CID) {
        cid = value;
      }
    });
    console.log(`uid=${uid}, uName=${uName}, cid=${cid}`);
    return true;
  }
}
