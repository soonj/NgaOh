import { CommonConstants } from '../constants/CommonConstant';
import { util } from '@kit.ArkTS';

export function convertAnonymousName (name: string) {
  let buffer: string[] = [];
  let i = 6;

  for (let j = 0; j < 6; j++) {
    let pos: number;

    if (j === 0 || j === 3) {
      pos = parseInt(name.substring(i + 1, i + 2), 16);
      buffer.push(Object(CommonConstants.ANONYMOUS_PART_1)[pos]);
    } else {
      pos = parseInt(name.substring(i, i + 2), 16);
      buffer.push(Object(CommonConstants.ANONYMOUS_PART_2)[pos]);
    }

    i += 2;
  }

  return buffer.join('');
}

export function toBinaryArray(bytes: Uint8Array): string {
  const byteLength = 8;
  let builder: string[] = [];

  for (let i = 0; i < byteLength * bytes.length; i++) {
    builder.push(
      (bytes[Math.floor(i / byteLength)] << (i % byteLength) & 0x80) === 0 ? '0' : '1'
    );
  }

  return builder.join('');
}


export function string2Uint8Array(value: string): Uint8Array| null {
  if (!value) return null;
  //
  let textEncoder = new util.TextEncoder();
  //获取点流并发出 UTF-8 字节流 TextEncoder 的所有实例仅支持 UTF-8 编码
  return textEncoder.encodeInto(value)
}

export function uint8Array2String(input: Uint8Array) {
  let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true })
  return textDecoder.decodeToString(input, { stream: false });
}
