import { SayingConstants } from '../common/constants/SayingConstant'

@ComponentV2
export struct LoadingComponent {
  private saying: string = "";

  aboutToAppear(): void {
    this.saying = SayingConstants.SAYING_MAP[Math.floor(Math.random() * SayingConstants.SAYING_MAP.length)];
  }

  build() {
    Column({ space: 10 }) {
      LoadingProgress()
        .color(Color.Grey)
        .size({ width: 80, height: 80 })
        .backgroundColor(Color.Transparent)
      Text(this.saying)
        .padding({left:20,right:20})
      .maxLines(3)
    }
    .layoutWeight(1)
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }
}