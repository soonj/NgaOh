import { PhotoView } from '@ohos/photoview';

//创建model对象

@Builder
export function PhotoPreviewBuilder() {
  photoPreview();
}

@Component
struct photoPreview {
  @State src: string = "";
  @Consume('pageStack') pageStack: NavPathStack;

  //设置图片源
  aboutToAppear() {
    this.src = this.pageStack.getParamByName("PhotoPreview")[0] as string;
  }

  build() {
    NavDestination() {
      PhotoView({
        // todo: 图片支持缩放
        model: new PhotoView.Model()
          .setImageURI(this.src)
          .setScale(1, true)
          .setZoomable(true)
          .setImageFit(ImageFit.Contain)
          .setOnPhotoTapListener({
            onPhotoTap(x: number, y: number) {
            }
          })
      })
    }.backgroundColor("#FFF0CD")
  }
}
