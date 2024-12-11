import { PullToRefresh, PullToRefreshV2 } from '@ohos/pulltorefresh'
import { NewsDataSource } from '../viewmodel/TitleDataSource';
import { TopicTitleInfo as ViewData } from '../model/TopicTitleInfo';
import { TopicTitleViewModel } from '../viewmodel/TopicTitleViewModel';
import { BoardInfo } from '../model/BoardInfo';
import { TopicListBeanResult } from '../model/TopicTitle';
import { TopicTitleItem } from '../view/TopicTitleItem';
import { LoadingComponent } from '../view/LoadingComponent';
import { curves, promptAction } from '@kit.ArkUI';
import { TopicPostParam } from '../model/TopicPost';
import { CommonConstants, HttpCode } from '../common/constants/CommonConstant';


@Builder
export function TopicTitleBuilder() {
  TopicTitle();
}

@Entry
@Preview
@ComponentV2
struct TopicTitle {
  @Local boardInfo: BoardInfo = new BoardInfo();
  @Local newsData: NewsDataSource = new NewsDataSource();
  titleModel: TopicTitleViewModel = new TopicTitleViewModel();
  private scroller: Scroller = new Scroller();
  @Local currentPage: number = 1;
  @Local firstIndex: number = 0;
  @Local totalPage: number = 0;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  @Local isLoading: boolean = true;

  aboutToAppear() {

  }

  onDidBuild(): void {
    this.boardInfo = this.pageStack.getParamByName("TopicTitle")[0] as BoardInfo;
    this.getNews();
  }

  build() {
    NavDestination() {
      Column() {
        if (this.isLoading) {
          LoadingComponent()
        } else {
          PullToRefreshV2({
            scroller: this.scroller,
            customList: () => {
              this.getListView();
            },
            onRefresh: () => {
              return new Promise<string>((resolve, reject) => {
                this.newsData.clear();
                this.getNews().then(() => {
                  resolve("刷新成功");
                });
              });
            },
            onLoadMore: () => {
              return new Promise<string>((resolve, reject) => {
                this.currentPage++;
                this.getNews().then(() => {
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
    .menus(this.menus())
    .backgroundColor($r("app.color.nga_background"))
    .title(this.boardInfo?.name)
  }

  @Builder
  private getListView() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      List({ space: 1, scroller: this.scroller }) {
        LazyForEach(this.newsData, (item: ViewData, index: number) => {
          ListItem() {
            TopicTitleItem({ entity: item })
              .onClick(() => {
                this.pageStack.pushPathByName("TopicContent", item)
              })
              .backgroundColor(index % 2 == 0 ? $r('app.color.nga_background_secondary')
                : $r('app.color.nga_background'))
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
    }.height("100%")
    .margin({ bottom: '10vp' })
  }

  aboutToDisappear() {
    this.newsData.clear();
  }

  getNews(): Promise<boolean> {
    return new Promise((resolve: Function) => {
      this.titleModel.loadPage(this.boardInfo, this.currentPage)
        .then((newsModelData: TopicListBeanResult) => {
          let dataCount = newsModelData.__T.length;
          this.totalPage = Math.ceil(newsModelData.__ROWS / newsModelData.iTRowsPage);
          for (let j = 0; j < dataCount; j++) {
            let topicEntity: ViewData = TopicTitleViewModel._convertToTopicTitleInfo(newsModelData.__T[j]);
            this.newsData.pushData(topicEntity);
          }
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
            }
            this.pageStack.removeByName("TopicTitle")
            this.pageStack.pushPathByName("WebView", url)
          }
        })
        .finally(() => {
          this.isLoading = false;
          resolve(true);
        });
    });
  }

  menus(): NavigationMenuItem[] {
    return [
      {
        'value': "发帖",
        'icon': 'resources/base/media/ic_public_list_add_transparent.svg',
        'action': () => {
          let topicPostParam = new TopicPostParam;
          topicPostParam.fid = this.boardInfo.fid;
          topicPostParam.action = TopicPostParam.TOPIC_POST_ACTION_NEW;
          this.pageStack.pushPathByName("TopicPost", topicPostParam)
        }
      },
      {
        'value': "刷新",
        'icon': 'resources/base/media/ic_public_refresh.svg',
        'action': () => {
          this.isLoading = true;
          this.newsData.clear();
          this.getNews();
        }
      }
    ]
  }
}

