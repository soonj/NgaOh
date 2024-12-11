import { TopicTitleInfo } from '../model/TopicTitleInfo';

@ComponentV2
export struct TopicTitleItem {
  @Param entity: TopicTitleInfo = new TopicTitleInfo;

  build() {
    Column({ space: 10 }) {
      Text(this.entity.title)
        .fontSize("17vp")
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({top:5})
        .fontWeight(400)
        .width("100%")

      Row() {

        Row() {
          Text(this.entity.author)
            .fontSize("15vp")
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .layoutWeight(1)
            .lineHeight("15vp")
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
            .fontSize("15vp")
            .lineHeight("15vp")
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .height($r('app.string.news_content_height'))
            .textAlign(TextAlign.End)
            .width("50%")
            .maxLines(1)
            .margin({ top: $r('app.string.news_content_margin'), bottom: $r('app.string.news_content_margin') })
            .textOverflow({ overflow: TextOverflow.Ellipsis })


          Text(this.entity.lastReplyTime)
            .fontSize("15vp")
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .height("15vp")
            .lineHeight("15vp")
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