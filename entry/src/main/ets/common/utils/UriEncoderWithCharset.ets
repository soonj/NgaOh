import { util } from '@kit.ArkTS';

export class UriEncoderWithCharset {
  static isAllowed(char: string, allow?: string): boolean {
    // Check if the character is an alphanumeric character (A-Z, a-z, 0-9)
    const code = char.charCodeAt(0);
    return (
      (code >= 65 && code <= 90) || // A-Z
        (code >= 97 && code <= 122) || // a-z
        (code >= 48 && code <= 57) || // 0-9
        ("_-!.~'()*".indexOf(char) !== -1) || // Unreserved URI characters
        (allow !== undefined && allow.indexOf(char) !== -1) // Allowed by custom set
    );
  }

  static toHex(byte: number): string {
    const hexDigits = "0123456789ABCDEF";
    return hexDigits.charAt((byte >> 4) & 0xf) + hexDigits.charAt(byte & 0xf);
  }

  static encode(s: string, allow: string | undefined, charset: string): string {
    if (!s) {
      return s;
    }

    let encoded: string[] = [];
    let current = 0;
    const oldLength = s.length;

    while (current < oldLength) {
      // Find the next character that needs encoding
      let nextToEncode = current;
      while (nextToEncode < oldLength && UriEncoderWithCharset.isAllowed(s[nextToEncode], allow)) {
        nextToEncode++;
      }

      // If no encoding is needed for the remaining part of the string
      if (nextToEncode === oldLength) {
        if (current === 0) {
          return s; // Nothing to encode
        }
        encoded.push(s.slice(current, oldLength));
        break;
      }

      // Append allowed characters
      if (nextToEncode > current) {
        encoded.push(s.slice(current, nextToEncode));
      }

      // Now find the next allowed character to switch to encoding
      current = nextToEncode;
      let nextAllowed = current + 1;
      while (nextAllowed < oldLength && !UriEncoderWithCharset.isAllowed(s[nextAllowed], allow)) {
        nextAllowed++;
      }

      // Extract the substring to encode
      const toEncode = s.slice(current, nextAllowed);

      // Convert the substring to bytes using TextEncoder and specified charset
      let encodedBytes: Uint8Array;
      try {
          let encoder =  new util.TextEncoder(charset.toLowerCase()); // Only supports UTF-8
          encodedBytes = encoder.encodeInto(toEncode);
        const bytesLength = encodedBytes.length;

        // Convert bytes to %HH form
        for (let i = 0; i < bytesLength; i++) {
          encoded.push('%' + UriEncoderWithCharset.toHex(encodedBytes[i]));
        }

      } catch (e) {
        console.error("Encoding error: " + e.message);
        return s; // In case of an encoding error, return the original string
      }

      current = nextAllowed;
    }

    return encoded.join('');
  }
}
