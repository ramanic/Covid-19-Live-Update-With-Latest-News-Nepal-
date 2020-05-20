import 'package:covid19nepal/src/NewsModel.dart';
import 'package:covid19nepal/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:url_launcher/url_launcher.dart';
class NewsList extends StatelessWidget{
  final List<NewsModel> news;
  NewsList(this.news);
  Widget build(context){
    return Container(
        color: HexColor("#e8e8e8"),
        child:ListView.builder(
        shrinkWrap: true,
        itemCount: news.length,
        itemBuilder: (context,int index){
          return InkWell(
          onTap: (){
            launch(news[index].url);
          }, // handle your onTap here
          child:Container(
            color: Colors.white60,
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),


          
          child: Row(
            children: <Widget>[
              Container(
                height:80,
                width: 100,
                child: FadeInImage(image:NetworkImage(news[index].image),placeholder: AssetImage('assets/news.jpg')),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          news[index].title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          style: TextStyle(color:Colors.black54,fontWeight:FontWeight.w500,fontSize: 14),
                        ),
                        Text(
                          news[index].summary,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: TextStyle(color:Colors.black45 , fontSize: 13),
                        )
                      ]),
                ),
              )
            ],
          )));
    }));
  }
}