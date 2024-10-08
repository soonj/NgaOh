import { Type } from 'class-transformer';
import 'reflect-metadata'


export class BoardInfo {
  constructor(name: string = "", fid: number = 414, stid: number = 0, recommend: boolean = false, favor: boolean = false) {
    this._name = name;
    this._fid = fid;
    this._stid = stid;
    this._recommend = recommend;
    this._favor = favor;
  }
  private _name: string;
  private _fid: number;
  private _stid: number;

  public set stid(value: number) {
    this._stid = value;
  }

  public get stid(): number {
    return this._stid;
  }
  private _recommend: boolean;

  public set recommend(value: boolean) {
    this._recommend = value;
  }

  public get recommend(): boolean {
    return this._recommend;
  }

  private _favor: boolean;

  public set favor(value: boolean) {
    this._favor = value;
  }

  public get favor(): boolean {
    return this._favor;
  }

  public set fid(value: number) {
    this._fid = value;
  }

  public get fid(): number {
    return this._fid;
  }

  public set name(value: string) {
    this._name = value;
  }

  public get name(): string {
    return this._name;
  }

}

export class BoardCategory {
  constructor(boards: BoardInfo[], name: string) {
    this._boards = boards;
    this._name = name;
  }
  private _boards: BoardInfo[];

  public set boards(value: BoardInfo[]) {
    this._boards = value;
  }

  public get boards(): BoardInfo[] {
    return this._boards;
  }
  private _name: string;


  public set name(value: string) {
    this._name = value;
  }

  public get name(): string {
    return this._name;
  }
}