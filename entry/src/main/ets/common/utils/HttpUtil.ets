// HttpUtil.ets
import { http } from '@kit.NetworkKit';
import ResponseResult from '../../model/Response';
import { util } from '@kit.ArkTS';
import { string2Uint8Array } from './StringUtil';
import { HttpCode } from '../constants/CommonConstant';

// GET请求
export function httpRequestGet(url: string, params?: string | Object | ArrayBuffer,
  header?: Record<string, string>): Promise<ResponseResult> {
  return httpRequest(url, http.RequestMethod.GET, params, header);
}

// POST请求
export function httpRequestPost(url: string, postData: string | Object | ArrayBuffer,
  header?: Record<string, string>): Promise<ResponseResult> {
  return httpRequest(url, http.RequestMethod.POST, postData, header);
}

function httpRequest(url: string, method: http.RequestMethod, params?: string | Object | ArrayBuffer,
  header?: Record<string, string>): Promise<ResponseResult> {
  let httpRequest = http.createHttp();
  let responseResult = httpRequest.request(url, {
    method: method,
    readTimeout: 3000,
    header: header,
    connectTimeout: 3000,
    extraData: params,
    expectDataType: http.HttpDataType.ARRAY_BUFFER
  });

  let serverData = new ResponseResult();
  // 处理数据，并返回
  return responseResult.then((value: http.HttpResponse) => {
    if (value.responseCode == 200) {
      // 获取返回数据
      try {
        let decoder = util.TextDecoder.create("gbk", { ignoreBOM: true });
        let decodedStr = decoder.decodeWithStream(new Uint8Array(value.result as ArrayBuffer));
        let resultJson: ResponseResult = JSON.parse(decodedStr.replaceAll(/\t/g, " ").replaceAll(/\u0000/g, " "));

        if (resultJson.error && resultJson.error.size > 0) {
          serverData.code = resultJson.error[0];
          serverData.msg = resultJson.error[0];
        } else {
          serverData.code = HttpCode.SUCCESS;
          if (resultJson.result) {
            serverData.result = resultJson.result;
          } else {
            serverData.result = resultJson;
            serverData.msg = resultJson?.msg;
          }
        }
      } catch (error) {
        serverData.code = HttpCode.PARSE_ERROR;
        serverData.msg = `server_error:${error}`;
      }
    } else {
      serverData.code = value.responseCode;
      serverData.msg = `server_error:${value.responseCode}}`;
    }
    return serverData;
  }).catch(() => {
    serverData.code = HttpCode.TIMEOUT;
    serverData.msg = "server_error";
    return serverData;
  }).finally(() => {
    httpRequest.destroy();
  });
}