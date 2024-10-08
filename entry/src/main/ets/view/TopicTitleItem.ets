import { TopicTitleInfo } from '../model/TopicTitleInfo';

@Component
@Preview
export struct TopicTitleItem {
  private entity: TopicTitleInfo = new TopicTitleInfo;

  build() {
    Column({ space: 10 }) {
      Text(this.entity.title)
        .fontSize(16)
        .fontColor($r('app.color.news_title_fontColor'))
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({top:5})
        .fontWeight(400)
        .width("100%")

      Row() {

        Row() {
          Text(this.entity.author)
            .fontSize(18)
            .fontColor($r('app.color.news_time_fontColor'))
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(400)
            .width("100%")
        }.width("50%")
        .layoutWeight(1)
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Bottom)

        Row() {
          Text(this.entity.replyCount.toString())
            .fontSize($r('app.float.product_txt_fontSize'))
            .lineHeight(18)
            .fontColor($r('app.color.news_time_fontColor'))
            .height($r('app.string.news_content_height'))
            .textAlign(TextAlign.End)
            .width("50%")
            .maxLines(1)
            .margin({ top: $r('app.string.news_content_margin'), bottom: $r('app.string.news_content_margin') })
            .textOverflow({ overflow: TextOverflow.Ellipsis })


          Text(this.entity.lastReplyTime)
            .fontSize($r('app.float.product_txt_fontSize'))
            .fontColor($r('app.color.news_time_fontColor'))
            .height($r('app.string.news_content_height'))
            .lineHeight(18)
            .width("50%")
            .textAlign(TextAlign.End)
            .maxLines(1)
            .margin({
              top: $r('app.string.news_content_margin'),
              bottom: $r('app.string.news_content_margin')
            })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width("50%")
        .layoutWeight(1)
        .justifyContent(FlexAlign.End)

      }
    }
    .padding({
      top: $r('app.string.news_row_padding'),
      left: $r('app.string.news_row_padding'),
      right: $r('app.string.news_row_padding')
    })
    .height($r('app.string.news_item_height'))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}