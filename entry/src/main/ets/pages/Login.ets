import { webview } from '@kit.ArkWeb';
import { showDialog } from '../common/utils/DialogUtil';
import { CommonConstants } from '../common/constants/CommonConstant';
import { CookieUtil } from '../common/utils/CookieUtil';
import { GlobalContext } from '../common/utils/GlobalContext';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import PreferencesUtil from '../common/utils/PreferencesUtil';


@Entry
@Component
struct Login {
  @State message: string = 'Hello World';
  fileAccess: boolean = true;
  controller: webview.WebviewController = new webview.WebviewController();
  isRedirect: boolean = false;
  @State srcUrl: string = '';

  onPageShow(): void {
    this.isRedirect = false;
  }

  aboutToAppear() {
    // 配置Web开启调试模式
    webview.WebviewController.setWebDebuggingAccess(true);
  }

  build() {
    Column() {
      Navigator({ target: CommonConstants.PAGE_HOME, type: NavigationType.Back }) {
        Row() {
          Image($r('app.media.ic_back'))
            .width(CommonConstants.BACK_WIDTH)
            .height(CommonConstants.BACK_HEIGHT)
            .objectFit(ImageFit.Contain)

          Text($r('app.string.navigator_name'))
            .fontSize(CommonConstants.NAVIGATOR_SIZE)
            .fontWeight(CommonConstants.FONT_WEIGHT_DEEPER)
            .fontColor($r('app.color.navigator_black'))

        }
        .width(CommonConstants.FULL_WIDTH)
      }
      .width(CommonConstants.FULL_WIDTH)
      .margin({
        top: CommonConstants.NAVIGATOR_MARGIN_TOP,
        left: CommonConstants.NAVIGATOR_MARGIN_LEFT
      })

      Web({
        src: CommonConstants.LOGIN_WEB_PAGE_URL,
        controller: this.controller
      })
        .onControllerAttached(async () => {
          let check = await PreferencesUtil.getPreferenceValue(CommonConstants.COOKIE_TITLE, CommonConstants.G_EMPTY)
          console.log(`console-----------${check}`);
          if (check != CommonConstants.G_EMPTY) {

            webview.WebCookieManager.configCookieSync(CommonConstants.HOST,
              check.toString());
          } else {
            console.log("没有保存Cookie")
          }

        })
        .height(CommonConstants.WEB_HEIGHT)
        .width(CommonConstants.WEB_WIDTH)
        .fileAccess(this.fileAccess)
        .javaScriptAccess(true)
        .onOverrideUrlLoading((webResourceRequest: WebResourceRequest) => {
          console.log("getRequestUrl:" + webResourceRequest.getRequestUrl())
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
}