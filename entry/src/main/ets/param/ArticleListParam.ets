export class ArticleListParam {
  constructor() {
    this.pid = 0;
    this.tid = 0;
    this.authorId = 0;
    this.page = 1;
    this.searchPost = 0;
    this.title = "";
    this.content = "";
    this.topicInfo = "";
    this.loadCache = false;
  }

  public pid: number = 0;

  public tid: number = 0;

  public authorId: number = 0;

  public page: number = 0;

  public searchPost: number = 0;

  public title: string = "";

  public content: string = "";

  public topicInfo: string = "";

  public loadCache: boolean = false;

}