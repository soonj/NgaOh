import { TopicPostParam } from '../param/TopicPostParam';
import { LoadingComponent } from '../view/LoadingComponent';
import { promptAction } from '@kit.ArkUI';
import { TopicPostViewModel } from '../viewmodel/TopicPostViewModel';

@Builder
export function TopicPostBuilder() {
  TopicPost();
}

@Entry
@ComponentV2
struct TopicPost {
  @Local topicPostParam: TopicPostParam = new TopicPostParam;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.topicPostParam = this.pageStack.getParamByName("TopicPost")[0] as TopicPostParam;
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Toggle({ type: ToggleType.Switch, isOn: false })
            .width("10%")
            .onChange((isOn: boolean) => {
              if(isOn) {
                promptAction.showToast({'message': '开启匿名'})
                this.topicPostParam.anonymous = true;
              } else {
                promptAction.showToast({'message': '关闭匿名'})
                this.topicPostParam.anonymous = false;
              }
            })
          Text("匿名")
            .fontColor($r('sys.color.font_primary'))
            .fontSize(16)
            .width("10%")
          TextInput({ placeholder: '这里输入引喷的标题' })
            .onChange((value: string) => {
              this.topicPostParam.subject = value;
            })
            .width("80%")
        }

        TextArea({ placeholder: '这里输入引喷的内容' })
          .margin({ top: 20 })
          .height("50%")
          .onSubmit(() => EnterKeyType.NEW_LINE)
          .onChange((value: string) => {
            this.topicPostParam.postContent = value;
          })
      }
      .height('100%')
    }
    .backgroundColor($r("app.color.nga_background"))
    .title(this.topicPostParam.action)
    .menus([this.postMenu()])
  }

  postMenu(): NavigationMenuItem {
    return {
      'value': this.topicPostParam.action,
      'icon': 'resources/base/media/ic_public_ok.svg',
      'action': () => {
        let topicPostViewModel = new TopicPostViewModel;
        topicPostViewModel.post(this.topicPostParam).then((res: boolean) => {
          if (res) {
            promptAction.showToast({
              message: '发送成功,请手动刷新',
              duration: 2000
            });
            this.pageStack.pop()
          }
        })
      }
    }
  }
}