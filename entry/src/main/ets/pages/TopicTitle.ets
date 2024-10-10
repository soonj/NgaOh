import { PullToRefresh } from '@ohos/pulltorefresh'
import { NewsDataSource } from '../viewmodel/TitleDataSource';
import { TopicTitleInfo as ViewData } from '../model/TopicTitleInfo';
import { TopicTitleViewModel } from '../viewmodel/TopicTitleViewModel';
import { BoardInfo } from '../model/BoardInfo';
import { TopicListBeanResult } from '../model/TopicTitle';
import { TopicTitleItem } from '../view/TopicTitleItem';
import { LoadingComponent } from '../view/LoadingComponent';
import { curves } from '@kit.ArkUI';
import { TopicPostParam } from '../model/TopicPost';
import { CommonConstants } from '../common/constants/CommonConstant';


@Builder
export function TopicTitleBuilder() {
  TopicTitle();
}

@Entry
@Preview
@Component
struct TopicTitle {
  @State boardInfo: BoardInfo = new BoardInfo();
  @State newsData: NewsDataSource = new NewsDataSource();
  titleModel: TopicTitleViewModel = new TopicTitleViewModel();
  private scroller: Scroller = new Scroller();
  @State currentPage: number = 1;
  @State firstIndex: number = 0;
  @State totalPage: number = 0;
  @Consume('pageStack') pageStack: NavPathStack;
  @State isLoading: boolean = true;

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
          PullToRefresh({
            scroller: this.scroller,
            customList: () => {
              this.getListView();
            },
            onRefresh: () => {
              return new Promise<string>((resolve, reject) => {
                setTimeout(() => {
                  this.newsData.clear();
                  this.getNews();
                  resolve("刷新成功");
                }, 1000);
              });
            },
            onLoadMore: () => {
              return new Promise<string>((resolve, reject) => {
                setTimeout(() => {
                  this.currentPage++;
                  this.getNews();
                  resolve("刷新成功");
                }, 1000);
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
    .backgroundColor("#FFF0CD")
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
              .backgroundColor(index % 2 == 0 ? "#FFF8E7" : "#FFF0CD")
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

  getNews() {
    this.titleModel.loadPage(this.boardInfo, this.currentPage).then((newsModelData: TopicListBeanResult) => {
      let dataCount = newsModelData.__T.length;
      this.totalPage = Math.ceil(newsModelData.__ROWS / newsModelData.iTRowsPage);
      for (let j = 0; j < dataCount; j++) {
        let topicEntity: ViewData = TopicTitleViewModel._convertToTopicTitleInfo(newsModelData.__T[j]);
        this.newsData.pushData(topicEntity);
      }

    }).catch((code: number) => {
      if (code === 15) {
        this.pageStack.removeByName("TopicTitle")
        this.pageStack.pushPathByName("WebView", CommonConstants.LOGIN_WEB_PAGE_URL)
      }
    }).finally(() => {
      this.isLoading = false;
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

