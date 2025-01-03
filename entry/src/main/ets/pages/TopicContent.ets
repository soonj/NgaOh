import { PullToRefresh, PullToRefreshConfigurator, PullToRefreshV2 } from '@ohos/pulltorefresh'
import { TopicContentViewModel } from '../viewmodel/TopicContentViewModel';
import {
  TopicContentEntity,
  TopicRowEntity as ViewData
} from '../model/TopicContent';
import { JSON } from '@kit.ArkTS';
import { ContentSource } from '../viewmodel/ContentDataSource';
import { contentItem } from '../view/TopicContentItem';
import { LoadingComponent } from '../view/LoadingComponent';
import { curves, promptAction } from '@kit.ArkUI';
import { TopicPostParam } from '../param/TopicPostParam';
import { CommonConstants, HttpCode } from '../common/constants/CommonConstant';
import { TextShare } from '../common/utils/TextShare';
import { ArticleListParam } from '../param/ArticleListParam';

@Builder
export function TopicContentBuilder() {
  TopicContent();
}

@Entry
@Preview
@ComponentV2
struct TopicContent {
  @Local articleListParam: ArticleListParam = new ArticleListParam();
  contentModel: TopicContentViewModel = new TopicContentViewModel();
  @Local contentData: ContentSource = new ContentSource();
  private scroller: Scroller = new Scroller();
  @Local firstIndex: number = 0;
  readonly ANIMATION_DURATION: number = 500;
  readonly SWITCH_BUTTON: number = 3;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  refreshConfigurator: PullToRefreshConfigurator = new PullToRefreshConfigurator()
  @Local isLoading: boolean = true;

  aboutToAppear() {
    let stackArray: Array<ArticleListParam> = this.pageStack.getParamByName("TopicContent") as Array<ArticleListParam>;
    if (stackArray.length > 0) {
      this.articleListParam = stackArray[stackArray.length - 1]
    }
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
                this.articleListParam.page = 1;
                this.getContents().then(() =>{
                  resolve("刷新成功");
                });
              });
            },
            onLoadMore: () => {
              return new Promise<string>((resolve, reject) => {
                this.articleListParam.page ++ ;
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
    .title(this.articleListParam.title)
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
    return new Promise((resolve: Function) => {this.contentModel.loadContent(this.articleListParam)
      .then((topicContentResult: TopicContentEntity) => {
        if (this.articleListParam.page >= topicContentResult.totalPage) {
          this.refreshConfigurator.setHasLoadMore(false);
        } else {
          this.refreshConfigurator.setHasLoadMore(true);
        }
        this.contentData.pushDataList(...topicContentResult.contentList)
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
            url = this.contentModel.buildWebViewUrl(this.articleListParam)
          }
          promptAction.showToast({
            message: '被封禁,正在跳转浏览器...',
            duration: 2000
          });
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
          topicPostParam.tid = this.articleListParam.tid;
          topicPostParam.action = TopicPostParam.TOPIC_POST_ACTION_REPLY;
          this.pageStack.pushPathByName("TopicPost", topicPostParam)
        }
      },
      {
        'value': "分享",
        'icon': 'resources/base/media/ic_public_sys_share.svg',
        'action': () => {
          let textShare = new TextShare(this.contentModel.buildWebViewUrl(this.articleListParam), this.articleListParam.title);
          textShare.share();
        }
      },
      {
        'value': "刷新",
        'icon': 'resources/base/media/ic_public_refresh.svg',
        'action': () => {
          this.isLoading = true;
          this.contentData.clear();
          this.articleListParam.page = 1;
          this.getContents();
        }
      }
    ]
  }
}

