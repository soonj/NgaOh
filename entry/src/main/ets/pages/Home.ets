import { Board, Contents } from '../model/Board';
import { initTabData } from '../viewmodel/TabViewModel';
import PreferencesUtil from '../common/utils/PreferencesUtil';
import { CommonConstants } from '../common/constants/CommonConstant';
import { TopicTitleBuilder } from './TopicTitle';
import { TopicContentBuilder } from './TopicContent';
import { BoardInfo } from '../model/BoardInfo';
import { WebViewBuilder } from './WebView';
import { util } from '@kit.ArkTS';
import { TopicPostBuilder } from './TopicPost';
import { PhotoPreviewBuilder } from '../view/photoPreviewComponent';

@Entry
@ComponentV2
struct Home {
  static readonly URL_BOARD_ICON: string = "http://img4.nga.178.com/ngabbs/nga_classic/f/app/%s.png";
  @Local tabArray: Array<Board> = [];
  @Local currentTabIndex: number = 0;
  @Provider('pageStack') pageStack: NavPathStack = new NavPathStack(); //导航栈管理类对象

  // 路由
  @Builder
  PagesMap(name: string) {
    if (name === 'Home') { // 主页
      Home()
    } else if (name === 'TopicTitle') { // 帖子列表
      TopicTitleBuilder();
    } else if (name === 'TopicContent') { // 帖子详情
      TopicContentBuilder();
    } else if (name === 'WebView') {
      WebViewBuilder();
    } else if (name === 'TopicPost') {
      TopicPostBuilder();
    } else if (name === 'PhotoPreview') {
      PhotoPreviewBuilder();
    }
  }

  aboutToAppear(): void {
    this.tabArray = initTabData();
  }

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontWeight(this.currentTabIndex === index ? FontWeight.Normal : FontWeight.Medium)
        .fontColor(this.currentTabIndex === index ? $r('sys.color.ohos_id_color_text_primary_activated')
          : $r('sys.color.ohos_id_color_text_primary'))
        .fontSize("15fp")
        .lineHeight("22vp")
        .margin({
          top: "5vp",
          bottom: "5vp",
          right: "5vp",
          left: "5vp"
        })
      Divider()
        .opacity(this.currentTabIndex === index ? 1 : 0)
        .width("48vp")
        .color($r('sys.color.ohos_id_color_emphasize'))
        .strokeWidth(2)
    }
  }

  @Builder
  contentBuilder(contentList: Array<Contents>) {
    List() {
      ForEach(contentList, (item: Contents) => {
        ListItem() {
          Column() {
            // Image($rawfile(`img/p${item.fid}.png`))
            Image(util.format(Home.URL_BOARD_ICON, item.fid))
              .alt($rawfile(`img/default_board_icon.png`))
              .size({ height: 50, width: 50 })
            Text(`${item.name}`)
              .width("100vp")
              .fontSize("16vp")
              .lineHeight("16vp")
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .maxLines(2)
              .maxFontSize("16vp")
              .minFontSize("13vp")
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .height('75vp')
          .margin({top:16, bottom:16})
          .justifyContent(FlexAlign.SpaceBetween)
          .onClick(() => {
            this.pageStack.pushPathByName("TopicTitle", new BoardInfo(item.name, item.fid))
          })
        }
      })
    }
    .width('100%')
    .height('100%')
    .lanes(3)
    .scrollBar(BarState.Off)
  }

  async startTopicListPage(board: Board) {
    let check = await PreferencesUtil.getPreferenceValue(CommonConstants.COOKIE_TITLE, CommonConstants.G_EMPTY)
    if (check != CommonConstants.G_EMPTY) {

    }
  }

  @Builder
  build() {
    Navigation(this.pageStack) {
      Column() {
        Tabs({ barPosition: BarPosition.Start }) {
          ForEach(this.tabArray, (item: Board) => {
            TabContent() {
              Row() {
                this.contentBuilder(item.content)
              }
              .justifyContent(FlexAlign.Center)
              .width("100%")
              .height("100%")

            }.tabBar(this.tabBuilder(item.id, item.name))
          }, (item: Board, index: number) => JSON.stringify(item) + index)
        }
        .barBackgroundColor($r("app.color.nga_background"))
        .barMode(BarMode.Scrollable)
        .barWidth("100%")
        .barHeight("52vp")
        .padding({ left: "18vp", right: "18vp" })
        .animationDuration(300)
        .onAnimationStart((index: number, targetIndex: number) => {
          this.currentTabIndex = targetIndex;
        })
        .width("100%")
        .height("100%")
        .vertical(false)
      }
      .height('100%')
      .width('100%')
    }.title("National Guy Alliances")
    .backgroundColor($r("app.color.nga_background"))
    .mode(NavigationMode.Stack)
    .navDestination(this.PagesMap)
  }
}