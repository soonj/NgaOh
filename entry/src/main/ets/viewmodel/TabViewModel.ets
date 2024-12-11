/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { BusinessError } from '@kit.BasicServicesKit';
import { Type, plainToClass, plainToInstance, ClassConstructor } from 'class-transformer'
import { Board } from '../model/Board';
import { util } from '@kit.ArkTS';

let context: Context = getContext(this);

export function initTabData(): Board[] {
  //读取json文件
  let rawStr = '';
  let rawFile = context.resourceManager.getRawFileContentSync("category.json")
  let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true })
  rawStr = textDecoder.decodeToString(rawFile, { stream: false })
  let BoardList: Array<Board> = jsonToArray(Board, rawStr)
  for (let index = 0; index < BoardList.length; index++) {
    let element = BoardList[index];
    element.id = index;
    BoardList[index] = element;
  }
  return BoardList;
}


function jsonToArray<T>(cls: ClassConstructor<T>, jsonStr: string): Array<T> {
  try {
    return plainToClass(cls, JSON.parse(jsonStr),
      { enableImplicitConversion: false, exposeDefaultValues: true }) as Array<T>
  } catch (err) {
    let error = err as BusinessError;
    return []
  }
}
