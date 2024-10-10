import { webview } from '@kit.ArkWeb';
import { showDialog } from '../common/utils/DialogUtil';
import { CommonConstants } from '../common/constants/CommonConstant';
import { CookieUtil } from '../common/utils/CookieUtil';
import { GlobalContext } from '../common/utils/GlobalContext';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import PreferencesUtil from '../common/utils/PreferencesUtil';
import { preferences } from '@kit.ArkData';


@Builder
export function WebViewBuilder() {
  WebView();
}

@Entry
@ComponentV2
struct WebView {
  fileAccess: boolean = true;
  controller: webview.WebviewController = new webview.WebviewController();
  isRedirect: boolean = false;
  @Local srcUrl: string = '';
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();

  onPageShow(): void {
    this.isRedirect = false;
  }

  aboutToAppear() {
    this.srcUrl = this.pageStack.getParamByName("WebView")[0] as string;
    // 配置Web开启调试模式
    // webview.WebviewController.setWebDebuggingAccess(true);
  }

  build() {
    NavDestination() {
      Column() {
        Web({ src: this.srcUrl, controller: this.controller })
          .minFontSize(15)
          .onControllerAttached(() => {
            PreferencesUtil.getPreferenceValue(CommonConstants.COOKIE_TITLE, CommonConstants.G_EMPTY)
              .then((value: preferences.ValueType) => {
                let check = value;
                if (check != CommonConstants.G_EMPTY) {
                  webview.WebCookieManager.configCookieSync(this.srcUrl, check.toString());
                } else {
                  console.log("没有保存Cookie")
                  //跳转登录URL
                  if (this.srcUrl != CommonConstants.LOGIN_WEB_PAGE_URL) {
                    this.controller.loadUrl(CommonConstants.LOGIN_WEB_PAGE_URL);
                  }
                }
              })
            this.controller.setCustomUserAgent("Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36")
          })
          .height(CommonConstants.WEB_HEIGHT)
          .width(CommonConstants.WEB_WIDTH)
          .fileAccess(this.fileAccess)
          .javaScriptAccess(true)
          .onOverrideUrlLoading((webResourceRequest: WebResourceRequest) => {
            if (webResourceRequest.getRequestUrl().indexOf(CommonConstants.HOST) == 0) {
              // 存入本地cookie
              try {
                let value: string = webview.WebCookieManager.fetchCookieSync(CommonConstants.HOST);
                console.log("fetchCookieSync cookie = " + value);
                PreferencesUtil.putPreferenceValue(CommonConstants.COOKIE_TITLE, value);
                CookieUtil.parseCookie(value)
              } catch (error) {
                console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            }
            return false;
          })
          .onAlert((event) => {
            if (event) {
              console.log("event.url:" + event.url);
              console.log("event.message:" + event.message);
              AlertDialog.show({
                title: 'Alert',
                message: event?.message,
                confirm: {
                  value: 'Confirm',
                  action: () => {
                    event.result.handleConfirm();
                  }
                },
                cancel: () => {
                  event.result.handleCancel();
                }
              })
            }
            return true;
          })
          .onConfirm((event) => {
            if (event) {
              console.log("event.url:" + event.url);
              console.log("event.message:" + event.message);
              AlertDialog.show({
                title: 'Alert',
                message: event.message,
                confirm: {
                  value: 'Confirm',
                  action: () => {
                    event.result.handleConfirm();
                  }
                },
                cancel: () => {
                  event.result.handleCancel();
                }
              })
            }
            return true;
          })
      }
      .backgroundColor($r('app.color.page_background_grey'))
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)

    }
    .title("WebView")
  }

  onBackPress(): boolean | void {
    if (this.controller.accessBackward()) {
      this.controller.backward();
      return true;

    } else {
      this.pageStack.pop();
    }
  }
}