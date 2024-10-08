import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh'
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
import { curves } from '@kit.ArkUI';
import { TopicPostParam } from '../model/TopicPost';

@Builder
export function TopicContentBuilder() {
  TopicContent();
}

@Entry
@Preview
@Component
struct TopicContent {
  @State tid: number = 0;
  contentModel: TopicContentViewModel = new TopicContentViewModel();
  @State contentData: ContentSource = new ContentSource();
  private scroller: Scroller = new Scroller();
  @State currentPage: number = 1;
  @State firstIndex: number = 0;
  @State totalPage: number = 1;
  @State topicTitle: string = "";
  readonly ANIMATION_DURATION: number = 500;
  readonly SWITCH_BUTTON: number = 3;
  @Consume('pageStack') pageStack: NavPathStack;
  refreshConfigurator: PullToRefreshConfigurator = new PullToRefreshConfigurator()
    .setLoadTextPullUp1("上拉刷新")
    .setLoadTextPullUp2("放开刷新")
    .setLoadTextLoading("正在玩命加载中...");
  @State isLoading: boolean = true;

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
          PullToRefresh({
            scroller: this.scroller,
            refreshConfigurator: this.refreshConfigurator,
            customList: () => {
              this.getListView();
            },
            onRefresh: () => {
              return new Promise<string>((resolve, reject) => {
                this.contentData.clear();
                this.currentPage = 1;
                this.getContents();
                resolve("刷新成功");
              });
            },
            onLoadMore: () => {
              return new Promise<string>((resolve, reject) => {
                resolve("");
                this.currentPage++;
                this.getContents();
              });
            },
            customLoad: null,
            customRefresh: null,
          })
        }
      }
      .backgroundColor("#FFF8E7")
      .height('100%')
    }
    .backgroundColor("#FFF0CD")
    .menus(this.menus())
    .title(this.topicTitle)
  }

  @Builder
  private getListView() {
    Flex({ direction: FlexDirection.Column }) {
      List({ space: 1, scroller: this.scroller }) {
        LazyForEach(this.contentData, (item: ViewData) => {
          ListItem() {
            contentItem({ entity: item, richTextOption: {content: item.content, imageProp: {objectFit: 'Auto'}} })
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

  getContents() {
    this.contentModel.loadContent(this.tid, this.currentPage).then((topicContentResult: TopicContentEntity) => {
      if (this.currentPage >= topicContentResult.totalPage) {
        this.refreshConfigurator.setHasLoadMore(false);
      } else {
        this.refreshConfigurator.setHasLoadMore(true);
      }
      this.contentData.pushDataList(...topicContentResult.contentList)
      this.totalPage = topicContentResult.totalPage;
    }).catch(
      () => {
        this.pageStack.removeByName("TopicContent")
        this.pageStack.pushPathByName("WebView", this.contentModel._buildWebViewUrl(this.tid, this.currentPage))
      }
    ).finally(() => {
      this.isLoading = false;
    });
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

