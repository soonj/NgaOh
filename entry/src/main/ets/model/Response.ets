export default class ResponseResult {
  /**
   * Code returned by the network request: success, fail.
   */
  code: string | number;

  /**
   * Message returned by the network request.
   */
  msg: string | Resource;

  /**
   * Data returned by the network request.
   */
  result: string | Object | ArrayBuffer;

  error: Map<string, string>;

  constructor() {
    this.code = '';
    this.msg = '';
    this.result = '';
    this.error = new Map;
  }
}