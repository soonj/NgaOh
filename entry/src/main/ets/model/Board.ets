import { Type } from 'class-transformer';
import 'reflect-metadata'


export class Board {
  private _name: string;
  private _id: number;

  public set id(value: number) {
    this._id = value;
  }

  public get id(): number {
    return this._id;
  }

  public set name(value: string) {
    this._name = value;
  }

  public get name(): string {
    return this._name;
  }

  @Type(() => Contents)
  private _content: Contents[];

  public set content(value: Contents[]) {
    this._content = value;
  }

  public get content(): Contents[] {
    return this._content;
  }

  constructor(name: string, id: number, content: Contents[]) {
    this._name = name;
    this._content = content;
    this._id = id;
  }
}

export class Contents {
  private _fid: number;

  public set fid(value: number) {
    this._fid = value;
  }

  public get fid(): number {
    return this._fid;
  }

  private _name: string;

  public set name(value: string) {
    this._name = value;
  }

  public get name(): string {
    return this._name;
  }

  private _info: string;

  public set info(value: string) {
    this._info = value;
  }

  public get info(): string {
    return this._info;
  }

  private _nameS: string;

  public set nameS(value: string) {
    this._nameS = value;
  }

  public get nameS(): string {
    return this._nameS;
  }

  private _stid: number;

  public set stid(value: number) {
    this._stid = value;
  }

  public get stid(): number {
    return this._stid;
  }

  constructor(fid: number, name: string, info: string, nameS: string, stid: number) {
    this._fid = fid;
    this._name = name;
    this._info = info;
    this._nameS = nameS;
    this._stid = stid;
  }
}