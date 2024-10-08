import { Type } from 'class-transformer';
import 'reflect-metadata'

export class TopicTitleInfo {
  private _title: string = "";

  public set title(value: string) {
    this._title = value;
  }

  public get title(): string {
    return this._title;
  }

  private _tid: number = 0;

  public set tid(value: number) {
    this._tid = value;
  }

  public get tid(): number {
    return this._tid;
  }

  private _author: string = "";

  public set author(value: string) {
    this._author = value;
  }

  public get author(): string {
    return this._author;
  }

  private _replyCount: number = 0;

  public set replyCount(value: number) {
    this._replyCount = value;
  }

  public get replyCount(): number {
    return this._replyCount;
  }

  private _lastReplyTime: string = "";

  public set lastReplyTime(value: string) {
    this._lastReplyTime = value;
  }

  public get lastReplyTime(): string {
    return this._lastReplyTime;
  }

  private _parentBoard: string = "";

  public set parentBoard(value: string) {
    this._parentBoard = value;
  }

  public get parentBoard(): string {
    return this._parentBoard;
  }

  private _isAnonymous: boolean = false;

  public set isAnonymous(value: boolean) {
    this._isAnonymous = value;
  }

  public get isAnonymous(): boolean {
    return this._isAnonymous;
  }

  private _isLocked: boolean = false;

  public set isLocked(value: boolean) {
    this._isLocked = value;
  }

  public get isLocked(): boolean {
    return this._isLocked;
  }

  private _isAssemble: boolean = false;

  public set isAssemble(value: boolean) {
    this._isAssemble = value;
  }

  public get isAssemble(): boolean {
    return this._isAssemble;
  }

  private _titleStyle: TextStyle = new TextStyle;

  public set titleStyle(value: TextStyle) {
    this._titleStyle = value;
  }

  public get titleStyle(): TextStyle {
    return this._titleStyle;
  }
}

export class TopicTitleWrapper {
  _topicTitleList: TopicTitleInfo[] = [];

  get data(): TopicTitleInfo[] {
    return this._topicTitleList;
  }

  pageIndex: number = 0;
  errorMsg?: string;

  add(wrapper?: TopicTitleWrapper, list?: TopicTitleInfo[], info?: TopicTitleInfo): void {
    if (wrapper) {
      this._topicTitleList.push(...wrapper.data);
      this.pageIndex = wrapper.pageIndex;
    }

    if (list) {
      this._topicTitleList.push(...list);
    }

    if (info) {
      this._topicTitleList.push(info);
    }
  }

  get isEmpty(): boolean {
    return this._topicTitleList.length === 0;
  }

  get length(): number {
    return this._topicTitleList.length;
  }
}