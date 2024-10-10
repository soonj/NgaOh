import { PhotoView } from '@ohos/photoview';

//创建model对象

@Builder
export function PhotoPreviewBuilder() {
  photoPreview();
}

@ComponentV2
struct photoPreview {
  src: string = "";
  @Local data: PhotoView.Model = new PhotoView.Model();
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack;

  //设置图片源
  aboutToAppear() {
    this.src = this.pageStack.getParamByName("PhotoPreview")[0] as string;
    this.data.setImageURI(this.src).setZoomable(true).setScale(1,false).setMaximumScale(3);
  }

  build() {
    NavDestination() {
      PhotoView({ model: this.data })
    }.backgroundColor("#FFF0CD")
  }
}
