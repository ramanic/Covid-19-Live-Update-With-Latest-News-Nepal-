class NewsModel{
  String url;
  String title;
  String summary;
  String image;
  String source;
  NewsModel(Map<String,dynamic>prasedJson){
    this.url=prasedJson['url'];
    this.source = prasedJson['source'];
    this.source+=" : ";
    this.title=this.source+prasedJson['title'];
    this.summary=prasedJson['summary'];
    this.image=prasedJson['image_url'];

  }
}