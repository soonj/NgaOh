import { HPRichTextV2, ObservedHPRichText, RichTextOption, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';
import { CommonConstants } from '../common/constants/CommonConstant';
import { TopicRowEntity } from '../model/TopicContent';
import { TopicContentViewModel } from '../viewmodel/TopicContentViewModel';
import { promptAction } from '@kit.ArkUI';
import { ArticleListParam } from '../param/ArticleListParam';


@ComponentV2
export struct contentItem {
  @Param @Once entity: TopicRowEntity = new TopicRowEntity;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();
  richTextModelQuote: RichTextOptionModelV2 = new RichTextOptionModelV2();
  topicContentModel: TopicContentViewModel = new TopicContentViewModel();

  aboutToAppear(): void {
    this.richTextModel.richTextOption = {
      content: this.entity.content,
      imageProp: { objectFit: 'Auto' },
      baseFontSize: 17,
      baseFontColor: $r("sys.color.ohos_id_color_text_primary")
    }
    this.richTextModel.needScroll = false;
    this.richTextModel.onLinkPress = (e) => {
      if (e.eventFnName == "photoPreview") {
        this.pageStack.pushPathByName("PhotoPreview", e.resourceSrc)
      } else {
        this.pageStack.pushPathByName("WebView", e.link)
      }
      return e;
    }

    if (this.entity.quote != "") {
      this.richTextModelQuote.richTextOption = {
        content: this.entity.quote,
        imageProp: { objectFit: 'Auto' },
        baseFontSize: 15,
        baseFontColor: $r("sys.color.ohos_id_color_text_primary")
      }
      this.richTextModelQuote.needScroll = false;
      this.richTextModelQuote.onLinkPress = (e) => {
        if (e.eventFnName == "photoPreview") {
          this.pageStack.pushPathByName("PhotoPreview", e.resourceSrc)
        } else {
          this.pageStack.pushPathByName("WebView", e.link)
        }
        return e;
      }
    }

  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        Image(this.entity.author?.avatarUrl)
          .alt($r('app.media.ic_public_person'))
          .height("50vp")
          .width("15%")
          .objectFit(ImageFit.Cover)
          .backgroundImageSize(ImageSize.FILL)
          .onClick(() => {
            this.pageStack.pushPathByName("WebView",
              CommonConstants.HOST + "nuke.php?func=ucp&uid=" + this.entity.author.uid.toString())
          })
        Column() {
          Row() {
            Text(this.entity.author?.userName + (this.entity.author.isAnonymous ? "(匿名)" : "") +
              (this.entity.topicOwner == this.entity.author.userName ? "(楼主)" : ""))
              .fontSize("14vp")
              .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
              .lineHeight("14vp")
              .maxLines(1)
              .maxFontSize(15)
              .minFontSize(10)
              .textAlign(TextAlign.Start)
              .fontWeight(300)

            Text(this.entity.postDate)
              .fontSize("14vp")
              .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
              .lineHeight("14vp")
              .textAlign(TextAlign.End)
              .maxLines(1)
          }
          .width("100%")
          .justifyContent(FlexAlign.SpaceBetween)


          Row() {
            Text(`级别: ${this.entity.author.level} 威望: ${this.entity.author.reputation} 发帖: ${this.entity.author.postCount} `)
              .fontSize("13vp")
              .maxFontSize(13)
              .minFontSize(10)
              .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
              .textAlign(TextAlign.Start)
              .lineHeight("20vp")
              .maxLines(1)

            Text(`[${this.entity.floor}]`)
              .fontSize($r('app.float.product_txt_fontSize'))
              .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
              .textAlign(TextAlign.End)
              .maxLines(1)
          }
          .width("100%")
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .height("50vp")
        .width("85%")
        .padding({ left: "15vp", right: "10vp" })
        .justifyContent(FlexAlign.SpaceBetween)

      }
      .width("100%")
      .margin({ top: $r('app.string.news_content_margin'), bottom: $r('app.string.news_content_margin') })

      if (this.entity.quote != "") {
        HPRichTextV2({ richTextModel: this.richTextModelQuote })
          .margin("5vp")
          .padding({left: "10vp", right: "10vp"})
          .backgroundColor($r('app.color.quote_background'))
          .border({
            color: "#e6e1d3",
            radius: 10,
            style: BorderStyle.Solid
          })
      }

      HPRichTextV2({ richTextModel: this.richTextModel })
        .padding({ top: "5vp", bottom: "5vp" })

      Row({ space: 20 }) {
        Row({ space: 6 }) {
          Image($r('app.media.ic_public_thumbsup_empty')).width("15vp").height("15vp")
          Text(this.entity.score.toString()).fontSize("14vp")
        }

        Image($r('app.media.ic_public_dot'))
          .width("15vp")
          .height("15vp")
          .bindMenu([
            {
              value: "支持",
              action: () => {
                this.topicContentModel.like(this.entity.tid, this.entity.pid, 1).then((result: string) => {
                  promptAction.showToast({
                    message: result,
                    duration: 2000
                  });
                }).catch((result: string) => {
                  promptAction.showToast({
                    message: result,
                    duration: 2000
                  });
                });
              }
            },
            {
              value: "反对",
              action: () => {
                this.topicContentModel.like(this.entity.tid, this.entity.pid, -1).then((result: string) => {
                  promptAction.showToast({
                    message: result,
                    duration: 2000
                  });
                }).catch((result: string) => {
                  promptAction.showToast({
                    message: result,
                    duration: 2000
                  });
                });
              }
            },
            {
              value: "只看此人",
              action: () => {
                let articleListParam : ArticleListParam = new ArticleListParam();
                articleListParam.tid = this.entity.tid;
                articleListParam.authorId = this.entity.author.uid;
                articleListParam.title = "指定用户发帖";
                this.pageStack.pushPathByName("TopicContent", articleListParam)
              }
            },
          ])
      }
      .justifyContent(FlexAlign.End)
      .width("100%")
      .padding({right: "10vp"})
      .margin({ right: "20vp", bottom: $r('app.string.news_content_margin') })

      Divider().color($r('sys.color.ohos_id_color_palette11'))
    }
    .padding({
      left: $r('app.string.news_row_padding'),
      right: $r('app.string.news_row_padding')
    })
  }
}