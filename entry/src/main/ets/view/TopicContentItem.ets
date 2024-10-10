import { HPRichTextV2, ObservedHPRichText, RichTextOption, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';
import { TopicRowEntity } from '../model/TopicContent';


@ComponentV2
export struct contentItem {
  @Param @Once entity: TopicRowEntity = new TopicRowEntity;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  aboutToAppear(): void {
    this.richTextModel.richTextOption = {
      content: this.entity.content,
      imageProp:{objectFit: 'Auto'},
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
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        Image(this.entity.author?.avatarUrl)
          .alt($r('app.media.ic_public_person'))
          .height("50vp")
          .width("15%")
          .objectFit(ImageFit.Fill)
          .backgroundImageSize(ImageSize.FILL)
        // todo: 头像点击
          // .onClick(() => {
          //   this.pageStack.pushPathByName("WebView", e.link)
          // })
        Column() {
          Row() {
            Text(this.entity.author?.userName)
              .fontSize(15)
              .fontColor($r('app.color.news_title_fontColor'))
              .lineHeight("20vp")
              .maxLines(1)
              .maxFontSize(15)
              .minFontSize(10)
              .textAlign(TextAlign.Start)
              .fontWeight(300)

            Text(this.entity.postDate)
              .fontSize(13)
              .fontColor($r('app.color.news_time_fontColor'))
              .lineHeight("20vp")
              .textAlign(TextAlign.End)
              .maxLines(1)
          }
          .width("100%")
          .justifyContent(FlexAlign.SpaceBetween)


          Row() {
            Text(`级别: ${this.entity.author.level} 威望: ${this.entity.author.reputation} 发帖: ${this.entity.author.postCount} `)
              .fontSize(14)
              .maxFontSize(14)
              .minFontSize(10)
              .fontColor($r('app.color.news_time_fontColor'))
              .textAlign(TextAlign.Start)
              .lineHeight("20vp")
              .maxLines(1)

            Text(`[${this.entity.floor}]`)
              .fontSize($r('app.float.product_txt_fontSize'))
              .fontColor($r('app.color.news_time_fontColor'))
              .textAlign(TextAlign.End)
              .maxLines(1)
          }
          .width("100%")
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .height("50vp")
        .width("85%")
        .padding({left:"15vp",right:"10vp"})
        .justifyContent(FlexAlign.SpaceBetween)

      }
      .width("100%")
      .margin({ top: $r('app.string.news_content_margin'), bottom: $r('app.string.news_content_margin') })

      HPRichTextV2({richTextModel: this.richTextModel})
        .padding({top:"15vp", bottom:"15vp"})
      Divider().color($r('app.color.link_blue'))
    }
    .padding({
      left: $r('app.string.news_row_padding'),
      right: $r('app.string.news_row_padding')
    })
  }
}