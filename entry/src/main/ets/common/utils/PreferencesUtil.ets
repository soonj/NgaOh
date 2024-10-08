import { preferences } from '@kit.ArkData'
import { CommonConstants } from '../constants/CommonConstant'

class PreferencesUtil{

  // 首选项实例
  private pref: preferences.Preferences | null = null

  /*
    * 初始化preferences实例
    * @context  应用上下文
   */
  async loadPreference(context: Context){
    try {
      this.pref = await preferences.getPreferences(context, CommonConstants.G_STORE)
      console.log(`preferences[${CommonConstants.G_STORE}]初始化成功`)
    } catch (err) {
      console.error(`preferences[${CommonConstants.G_STORE}]初始化失败`)
      console.error('err: ', JSON.stringify(err))
    }
  }

  /*
    * 销毁preferences实例 - 缓存、持久化文件一并销毁
    * @context  应用上下文
   */
  async delPreference(context: Context){
    try {
      await preferences.deletePreferences(context, CommonConstants.G_STORE)
      console.log(`preferences[${CommonConstants.G_STORE}]销毁成功`)
    } catch (err) {
      console.error(`preferences[${CommonConstants.G_STORE}]销毁失败`)
      console.error('err: ', JSON.stringify(err))
    }
  }

  /*
    * 从preferences实例中获取键对应的值
    * @key            健
    * @defaultValue   获取失败时，返回的值
   */
  async getPreferenceValue(key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType>{

    let value: preferences.ValueType = defaultValue

    // 获取对应的值之前，先判断preferences是否初始化完成
    if (!this.pref) {
      console.error(`preferences[${CommonConstants.G_STORE}]尚未初始化！`)
      return value
    }

    try {
      value = await this.pref.get(key, defaultValue)
      console.log(`读取preferences[${key} = ${value}]成功`)
    } catch (err) {
      console.error(`读取preferences[${key}]失败 `, JSON.stringify(err))
    }

    return value
  }

  /*
  * 从Preferences实例中写入数据
  * @key        健
  * @value      值
 */
  async putPreferenceValue(key: string, value: preferences.ValueType){

    // 写入数据之前，先判断preferences是否初始化完成
    if (!this.pref) {
      console.error(`preferences[${CommonConstants.G_STORE}]尚未初始化！`)
      return
    }

    try {
      await this.pref.put(key, value)
      // 持久化
      await this.pref.flush()
      console.log(`保存preferences[${key} = ${value}]成功`)
    } catch (err) {
      console.error(`保存preferences[${key} = ${value}]失败`, JSON.stringify(err))
    }

  }

}

const preferencesUtil = new PreferencesUtil()

export default preferencesUtil as PreferencesUtil