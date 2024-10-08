/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Common constants for all features.
 */
export class CommonConstants {

  /**
   * User Center Link.
   */
  static readonly USER_CENTER_URL = 'https://id1.cloud.huawei.com/AMW/portal/userCenter/index.html?' +
  'service=http://developer.huawei.com/consumer/cn/#/accountCenter/userCenter';

  /**
   * About Links.
   */
  static readonly USER_ABOUT_URL = 'https://id1.cloud.huawei.com/AMW/portal/userCenter/index.html?' +
  'service=http://developer.huawei.com/consumer/cn/#/accountCenter/about';

  static HOST = "https://ngabbs.com"
  static LOGIN_WEB_PAGE_URL = CommonConstants.HOST + "/nuke.php?__lib=login&__act=account&login";
  static COOKIE_KEY_UID = "ngaPassportUid";
  static COOKIE_KEY_UNAME = "ngaPassportUrlencodedUname";
  static COOKIE_KEY_CID = "ngaPassportCid";

  /**
   * Font size of navigation text.
   */
  static readonly NAVIGATOR_SIZE = '20fp';

  /**
   * Font size of page title text.
   */
  static readonly TITLE_SIZE = '18fp';

  /**
   * Font size of button text.
   */
  static readonly BUTTON_SIZE = '14fp';

  /**
   * Margin of divider.
   */
  static readonly DIVIDER_MARGIN = 12;

  /**
   * Height of divider.
   */
  static readonly DIVIDER_HEIGHT = '2.2%';

  /**
   * Url of verify page.
   */
  static readonly PAGE_LOGIN = 'pages/Login';

  /**
   * Url of index page.
   */
  static readonly PAGE_HOME = 'pages/Home';
  static readonly PAGE_POST = 'pages/Post';
  static readonly PAGE_PRODUCT = 'pages/Product';
  static readonly PAGE_TOPIC_ITEM = 'pages/TopicItem';
  static readonly PAGE_TOPIC_TITLE = 'pages/TopicTitle';

  /**
   * Maximum of width.
   */
  static readonly FULL_WIDTH = '100%';

  /**
   * Maximum of height.
   */
  static readonly FULL_HEIGHT = '100%';

  /**
   * Width of back icon.
   */
  static readonly BACK_WIDTH = '6.7%';

  /**
   * Height of back icon.
   */
  static readonly BACK_HEIGHT = '3.1%';

  /**
   * Height of web component.
   */
  static readonly WEB_HEIGHT = '100%';

  /**
   * Width of web component.
   */
  static readonly WEB_WIDTH = '100%';

  /**
   * Height of page title text.
   */
  static readonly PAGE_TITLE_HEIGHT = '1%';

  /**
   * Width of page title text.
   */
  static readonly PAGE_TITLE_WIDTH = '50.6%';

  /**
   * Top margin of navigation.
   */
  static readonly NAVIGATOR_MARGIN_TOP = '1.7%';

  /**
   * Left margin of navigation.
   */
  static readonly NAVIGATOR_MARGIN_LEFT = '10%';

  /**
   * Deeper font weight than normal font.
   */
  static readonly FONT_WEIGHT_DEEPER = 500;

  /**
   * Top margin of app title.
   */
  static readonly APP_TITLE_MARGIN_TOP = '15vp';

  /**
   * Left margin of app title.
   */
  static readonly APP_TITLE_MARGIN_LEFT = '26vp';

  /**
   * Bottom margin of web.
   */
  static readonly WEB_MARGIN_BOTTOM = '90vp';

  /**
   * Length of truncated.
   */
  static readonly SUB_LENGTH: number = 300;

  /**
   * Text Zoom Ratio.
   */
  static readonly TEXT_ZOOM_RATIO: number = 60;

  static readonly ANONYMOUS_PART_1 = "甲乙丙丁戊己庚辛壬癸子丑寅卯辰巳午未申酉戌亥";
  static readonly ANONYMOUS_PART_2 =
    "王李张刘陈杨黄吴赵周徐孙马朱胡林郭何高罗郑梁谢宋唐许邓冯韩曹曾彭萧蔡潘田董袁于余叶蒋杜苏魏程吕丁沈任姚卢傅钟姜崔谭廖范汪陆金石戴贾韦夏邱方侯邹熊孟秦白江阎薛尹段雷黎史龙陶贺顾毛郝龚邵万钱严赖覃洪武莫孔汤向常温康施文牛樊葛邢安齐易乔伍庞颜倪庄聂章鲁岳翟殷詹申欧耿关兰焦俞左柳甘祝包宁尚符舒阮柯纪梅童凌毕单季裴霍涂成苗谷盛曲翁冉骆蓝路游辛靳管柴蒙鲍华喻祁蒲房滕屈饶解牟艾尤阳时穆农司卓古吉缪简车项连芦麦褚娄窦戚岑景党宫费卜冷晏席卫米柏宗瞿桂全佟应臧闵苟邬边卞姬师和仇栾隋商刁沙荣巫寇桑郎甄丛仲虞敖巩明佘池查麻苑迟邝 ";

  static readonly COOKIE_TITLE: string = 'saveCookie';
  static readonly G_STORE: string = 'SOONJ';
  static readonly G_EMPTY: string = '';

  static readonly TOKEN: string = 'TOKEN';

}

/**
 * Type of cookie Operation.
 */
export enum CookieOperation {
  GET_COOKIE = '读取cookie',
  SET_COOKIE = '设置cookie',
  DELETE_COOKIE = '删除cookie',
  VERIFY_COOKIE = '验证cookie'
}