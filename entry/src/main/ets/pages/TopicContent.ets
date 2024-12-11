import { PullToRefresh, PullToRefreshConfigurator, PullToRefreshV2 } from '@ohos/pulltorefresh'
import { NewsDataSource } from '../viewmodel/TitleDataSource';
import { TopicContentViewModel } from '../viewmodel/TopicContentViewModel';
import {
  TopicContentBeanDataRR,
  TopicContentEntity,
  TopicContentResult,
  TopicRowEntity as ViewData
} from '../model/TopicContent';
import { JSON } from '@kit.ArkTS';
import { ContentSource } from '../viewmodel/ContentDataSource';
import { contentItem } from '../view/TopicContentItem';
import { LoadingComponent } from '../view/LoadingComponent';
import { TopicTitleInfo } from '../model/TopicTitleInfo';
import { curves, promptAction } from '@kit.ArkUI';
import { TopicPostParam } from '../model/TopicPost';
import { CommonConstants, HttpCode } from '../common/constants/CommonConstant';

@Builder
export function TopicContentBuilder() {
  TopicContent();
}

@Entry
@Preview
@ComponentV2
struct TopicContent {
  @Local tid: number = 0;
  contentModel: TopicContentViewModel = new TopicContentViewModel();
  @Local contentData: ContentSource = new ContentSource();
  private scroller: Scroller = new Scroller();
  @Local currentPage: number = 1;
  @Local firstIndex: number = 0;
  @Local totalPage: number = 1;
  @Local topicTitle: string = "";
  readonly ANIMATION_DURATION: number = 500;
  readonly SWITCH_BUTTON: number = 3;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  refreshConfigurator: PullToRefreshConfigurator = new PullToRefreshConfigurator()
  @Local isLoading: boolean = true;

  aboutToAppear() {
    let topicTitleInfo = this.pageStack.getParamByName("TopicContent")[0] as TopicTitleInfo;
    this.tid = topicTitleInfo.tid;
    this.topicTitle = topicTitleInfo.title;
    this.getContents();
  }

  build() {
    NavDestination() {
      Column() {
        if (this.isLoading) {
          LoadingComponent()
        } else {
          PullToRefreshV2({
            scroller: this.scroller,
            refreshConfigurator: this.refreshConfigurator,
            customList: () => {
              this.getListView();
            },
            onRefresh: () => {
              return new Promise<string>((resolve, reject) => {
                this.contentData.clear();
                this.currentPage = 1;
                this.getContents().then(() =>{
                  resolve("刷新成功");
                });
              });
            },
            onLoadMore: () => {
              return new Promise<string>((resolve, reject) => {
                this.currentPage++;
                this.getContents().then(() =>{
                  resolve("加载成功");
                });
              });
            },
            customLoad: null,
            customRefresh: null,
          })
        }
      }
      .height('100%')
    }
    .backgroundColor($r("app.color.nga_background"))
    .menus(this.menus())
    .title(this.topicTitle)
  }

  @Builder
  private getListView() {
    Flex({ direction: FlexDirection.Column }) {
      List({ space: 1, scroller: this.scroller }) {
        LazyForEach(this.contentData, (item: ViewData) => {
          ListItem() {
            contentItem({ entity: item })
          }
          .margin({
            bottom: $r('app.string.news_list_margin_bottom'),
          })
          .borderRadius(10)
        }, (item: ViewData, index?: number) => JSON.stringify(item) + index);
      }
      .height("100%")
      .width("100%")
      .cachedCount(5)
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Auto)
    }.height("100%")
    .margin({ bottom: '20vp' })
  }

  aboutToDisappear() {
    this.contentData.clear();
  }

  getContents(): Promise<boolean> {
    return new Promise((resolve: Function) => {this.contentModel.loadContent(this.tid, this.currentPage)
      .then((topicContentResult: TopicContentEntity) => {
        if (this.currentPage >= topicContentResult.totalPage) {
          this.refreshConfigurator.setHasLoadMore(false);
        } else {
          this.refreshConfigurator.setHasLoadMore(true);
        }
        this.contentData.pushDataList(...topicContentResult.contentList)
        this.totalPage = topicContentResult.totalPage;
      })
      .catch((code: number) => {
        if (code === HttpCode.TIMEOUT) {
          promptAction.showToast({
            message: '网络超时请重试',
            duration: 2000
          });
        } else {
          let url = "";
          if (code === HttpCode.NOT_LOGIN) {
            url = CommonConstants.LOGIN_WEB_PAGE_URL
          } else if (code === HttpCode.PARSE_ERROR) {
            url = this.contentModel._buildWebViewUrl(this.tid, this.currentPage)
          }
          this.pageStack.removeByName("TopicContent")
          this.pageStack.pushPathByName("WebView", url)
        }
      }
      )
      .finally(() => {
        this.isLoading = false;
        resolve(true);
      });});
  }

  menus(): NavigationMenuItem[] {
    return [
      {
        'value': "回复",
        'icon': 'resources/base/media/ic_public_list_add_transparent.svg',
        'action': () => {
          let topicPostParam = new TopicPostParam;
          topicPostParam.tid = this.tid;
          topicPostParam.action = TopicPostParam.TOPIC_POST_ACTION_REPLY;
          this.pageStack.pushPathByName("TopicPost", topicPostParam)
        }
      },
      {
        'value': "刷新",
        'icon': 'resources/base/media/ic_public_refresh.svg',
        'action': () => {
          this.isLoading = true;
          this.contentData.clear();
          this.currentPage = 1;
          this.getContents();
        }
      }
    ]
  }
}

