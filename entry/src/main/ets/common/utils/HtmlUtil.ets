import { EmoticonConstant } from '../constants/EmotionConstant';
import { util } from '@kit.ArkTS';

interface HtmlDecoder {
  decode(data: string): string;
}

class BasicHtmlDecoder implements HtmlDecoder {
  private static readonly REGEX_URL_WITH_HTTP = /\[url\]([^\[\]|]+)\[\/url\]/g;
  private static readonly REPLACE_URL_WITH_HTTP = "<a href='%s'>%s</a>";
  private static readonly BASIC_REGEX_MAP: Record<string, string> = {
    "[h](.+?)[/h]": "<b>%s</b>",
    "[b](.+?)[/b]": "<b>%s</b>",
    "[i](.+?)[/i]": "<i style='font-style:italic'>%s</i>",
    "[list](.+?)[/list]": "<li>%s</li>",
    "[del](.+?)[/del]": "<del>%s</del>",
    "[u](.+?)[/u]": "<u>%s</u>",
    "[item](.+?)[/item]": "<item>%s</item>",
    "[table](.*?)[/table]": "<div><table cellspacing='0px'><tbody>%s</tbody></table></div>",
    "[tr](.*?)[/tr]": "<tr>%s</tr>",
    "[l](.*?)[/l]": "<div style='float:left' >%s</div>",
    "[r](.*?)[/r]": "<div style='float:right' >%s</div>",
    "[flash=video](.*?)[/flash]": "<video src='http://img.ngacn.cc/attachments/%s' controls='controls'></video>",
    "[flash=audio](.*?)[/flash]": "<audio src='http://img.ngacn.cc/attachments/%s&filename=nga_audio.mp3' controls='controls'></audio>",
    "[code](.*?)[/code]": "<div class='quote' >%s</div>",
  };
  private static readonly BASIC_REPLACE_MAP: Record<string, string> = {
    "[align=right]": "<div style='text-align:right' >",
    "[align=left]": "<div style='text-align:left' >",
    "[align=center]": "<div style='text-align:right' >",
    "[/align]": "</div>",
    // "[quote]": "<p style='margin: 10px;border: 5px solid #000;'>",
    "[quote]": "<div>",
    "[/quote]": "</div>",
    // "[/quote]": "</p>",
    "&amp;": "&",
    "[/td]": "</td>",
    "<br/>": "<br>"
  };

  decode(data: string): string {
    let ngaHost = "http://bbs.nga.cn";

    data = data.replace(/\[b]Reply to \[pid=(.+?),(.+?),(.+?)]Reply\[\/pid](.+?)\[\/b]/g,
      (match, p1: string, p2: string, p3: string, p4: string) => `[quote]回复${p4}[/quote]`);

    data = data.replace(/\[pid=(.+?),(.+?),(.+?)]Reply\[\/pid]/g, "回复");

    data = data.replace(/Post by \[uid=(.*?)](.*?)\[\/uid]/g, (match, uid: string,
      username: string) => `<a href='${ngaHost}/nuke.php?func=ucp&uid=${uid}'>${username}</a>`);

    data = data.replace(/\[tid=\d+]Topic\[\/tid]/g, "回复");

    data = data.replace(/\[url=([^\[\]|]+)\]\s*(.+?)\s*\[\/url]/g,
      (match, url: string, text: string) => `<a href='${url}'>${text}</a>`);

    data = data.replace(/\[size=(\d+)%](.*?)\[\/size]/g, (match, size: number,
      content: string) => `<span style='font-size:${size}%;line-height:${size}%'>${content}</span>`);

    data = data.replace(/\[td[ ]*(\d+)]/g, "<td style='border-left:1px solid #aaa;border-bottom:1px solid #aaa'>");

    data = data.replace(/\[font=([^\[\]|]+)](.*?)\[\/font]/g,
      (match, font: string, content: string) => `<span style='font-family:${font}'>${content}</span>`);

    data = data.replace(/\[color=(.*?)](.*?)\[\/color]/g,
      (match, color: string, content: string) => `<span style='color:${color}'>${content}</span>`);

    data = data.replace(BasicHtmlDecoder.REGEX_URL_WITH_HTTP,
      (match, url: string) => util.format(BasicHtmlDecoder.REPLACE_URL_WITH_HTTP, url, url));


    Object.keys(BasicHtmlDecoder.BASIC_REPLACE_MAP).forEach((key) => {
      data = data.replace(new RegExp(encode(key), "g"), BasicHtmlDecoder.BASIC_REPLACE_MAP[key]);
    });

    Object.keys(BasicHtmlDecoder.BASIC_REGEX_MAP).forEach((key) => {
      data = data.replace(new RegExp(encode(key), "g"),
        (match, content: string) => util.format(BasicHtmlDecoder.BASIC_REGEX_MAP[key], content));
    });

    return data;
  }
}

class ImageHtmlDecoder implements HtmlDecoder {
  private static readonly REGEX_IMG_WITH_HTTP = /\[img]\s*(http[^\[\]|]+)\s*\[\/img]/g;
  private static readonly REPLACE_IMG_WITH_HTTP = "<a href='%s'><img src='%s'></a>";
  private static readonly REGEX_IMG_NO_HTTP = /\[img]\s*\.\/([^\[\]|]+)\s*\[\/img]/g;
  //todo: 图片加载占位图
  private static readonly REPLACE_IMG_NO_HTTP =
    "<a href='http://img.nga.178.com/attachments/%s'><img onClick='photoPreview' alt='$r('app.media.ic_offline_image')' src='http://img.nga.178.com/attachments/%s' /></a>";

  decode(data: string): string {
    data = data.replace(ImageHtmlDecoder.REGEX_IMG_WITH_HTTP,
      (match, url: string) => util.format(ImageHtmlDecoder.REPLACE_IMG_WITH_HTTP, url, url));
    data = data.replace(ImageHtmlDecoder.REGEX_IMG_NO_HTTP,
      (match, path: string) => util.format(ImageHtmlDecoder.REPLACE_IMG_NO_HTTP, path, path));
    return data;
  }
}

class EmoticonHtmlDecoder implements HtmlDecoder {
  private static readonly emoticonMap: Record<string, Record<string, string>> = {
    "pg": EmoticonConstant.UBB_CODE_PENGUIN_MAP,
    "ac": EmoticonConstant.UBB_CODE_ACNIANG_MAP,
    "a2": EmoticonConstant.UBB_CODE_ACNIANG_NEW_MAP,
    "pst": EmoticonConstant.UBB_CODE_PST_MAP,
    "dt": EmoticonConstant.UBB_CODE_DT_MAP,
  };

  decode(data: string): string {
    Object.keys(EmoticonHtmlDecoder.emoticonMap).forEach((key) => {
      data = this.decodeEmoticon(data, key, EmoticonHtmlDecoder.emoticonMap[key]);
    });
    return data;
  }

  private decodeEmoticon(data: string, emoticon: string, emoticonMap: Record<string, string>): string {
    const regex = new RegExp(`\\[s:${emoticon}:(.*?)]`, "g");
    data = data.replace(regex, (match, code: string) => {
      const image = emoticonMap[code];
      // return `<p><img style="width: 100;height: 100;" src='https://img4.nga.178.com/ngabbs/post/smile/${image}.png' /></p>`;
      return `<img height='50px' src='https://img4.nga.178.com/ngabbs/post/smile/${image}.png' />`;
    });
    return data;
  }
}

export class HtmlDecoderManager implements HtmlDecoder {
  private static htmlDecoders: HtmlDecoder[] = [
    new BasicHtmlDecoder(),
    new ImageHtmlDecoder(),
    new EmoticonHtmlDecoder()
  ];

  decode(data: string): string {
    data = new BasicHtmlDecoder().decode(data);
    HtmlDecoderManager.htmlDecoders.forEach(decoder => {
      data = decoder.decode(data);
    });
    return data;
  }

  decodeWithQuote(data: string): string[] {
    data = new BasicHtmlDecoder().decode(data);
    const result: string[] = [];
    HtmlDecoderManager.htmlDecoders.forEach(decoder => {
      data = decoder.decode(data);
    });
    const endTagMatches = data.matchAll(/<\/div>/g);
    let lastEndTagIndex = -1;
    for (const match of endTagMatches) {
      if (match.index) {
        lastEndTagIndex = match.index + match[0].length;
      }
    }
    if (lastEndTagIndex !== -1) {
      let beforData = data.slice(0, lastEndTagIndex);
      let afterData = data.slice(lastEndTagIndex).trim();
      result.push(afterData);
      result.push("<p>" + beforData + "</p>");
    } else {
      result.push("<p>" + data + "</p>");
    }
    return result;
  };
}

// Helper function to simulate sprintf in TypeScript
function sprintf(template: string, args: string[]): string {
  return template.replace(/%s/g, () => args.shift() as string);
}

function encode(keyword: string) {
  const reg = /[\[\$\^\]\\\{\}\\|\/]/gi
  // const reg = /[\[\(\$\^\.\]\*\\\?\+\{\}\\|\)]/gi
  return keyword.replace(reg, (key) => `\\${key}`)
}
