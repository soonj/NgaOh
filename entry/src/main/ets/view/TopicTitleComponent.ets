import { PullToRefresh } from '@ohos/pulltorefresh'
import { NewsDataSource } from '../viewmodel/TitleDataSource';
import { TopicTitleInfo, TopicTitleInfo as ViewData } from '../model/TopicTitleInfo';
import { TopicTitleViewModel } from '../viewmodel/TopicTitleViewModel';
import { BoardInfo } from '../model/BoardInfo';
import { TopicListBeanResult } from '../model/TopicTitle';
import { Expose, Transform, Type } from 'class-transformer';
import { newsItem } from './TopicTitleItem';

@Entry
@Preview
@Component
export default struct TopicTitleComponent {
  boardInfo = new BoardInfo();
  @State newsData: NewsDataSource = new NewsDataSource();
  titleModel: TopicTitleViewModel = new TopicTitleViewModel();
  private scroller: Scroller = new Scroller();
  @State currentPage: number = 0;
  @State firstIndex: number = 0;
  @State totalPage: number = 0;
  readonly ANIMATION_DURATION: number = 500;
  readonly SWITCH_BUTTON: number = 3;
  @Consume('pageStack') pageStack: NavPathStack;

  async aboutToAppear() {

    this.getNews();

  }

  build() {
    NavDestination() {
      Column() {
        this.Title()
        Column() {
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
        .backgroundColor("#F1F3F5")
        .height('87%')
      }
    }
    .hideTitleBar(true)
  }

  @Builder
  Title() {
    Flex({ direction: FlexDirection.Column }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
        Text('日报')
          .height('14vp')
      }
      .backgroundColor('#add8e6')

      Column() {
      }
      .width('100%')
    }
    .height('5%')

  }

  @Builder
  private getListView() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      List({ space: 3, scroller: this.scroller }) {
        LazyForEach(this.newsData, (item: ViewData) => {
          ListItem() {
            newsItem({ entity: item })
              .onClick(() => {
                this.pageStack.pushPathByName("NewsContent", null)
              })
          }
          .backgroundColor("#FFFFFFFF")
          .margin({
            bottom: $r('app.string.news_list_margin_bottom'),
          })
          .borderRadius(16)
        }, (item: ViewData, index?: number) => JSON.stringify(item) + index);
      }
      .onScrollIndex((first: number) => {
        this.firstIndex = first;
      })
      .height("100%")
      .width("100%")
      .cachedCount(5)
      .backgroundColor("#F1F3F5")
      .edgeEffect(EdgeEffect.None)
    }.height("100%")
    .margin({ bottom: '20vp' })
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
    });
  }
}

