import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:social_tool/Data/globalVals.dart';


Widget postAndSocialsView({double offset = 0.0,double size = 60,String imgUrl = Globals.imgExample,double borderWidth = 1.0,
                          Color borderColor = Colors.black,
                          List<String> socImgs = const [Globals.faceImg,Globals.instImg, Globals.twitImg,]})
{

  
  return Container(
            child: Stack(children: <Widget>[
              Align(alignment: Alignment.centerLeft,
              child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor ,width: borderWidth),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AdvancedNetworkImage(
                          imgUrl,
                          useDiskCache: true,
                          cacheRule: CacheRule(maxAge: const Duration(days: 10))
                        ),//NetworkImage(_url)
                    ),
                  ),
                  
                  alignment: Alignment.bottomRight,
                ),
              ),
              //generation of social Views images from list
              cirleImagesRow(contHeight: size,size: size/3,imgs: socImgs,borderColor: borderColor,borderWidth: 0.0,offset: offset)
            ]),
          );
}

//Must be puted in Container or other widget to manipulate position
Widget cirleImagesRow({double contHeight = 50,
                      double size = 23, List<String> imgs = const[],
                      Color borderColor = Colors.black,
                      double borderWidth = 1.0,offset = 0,int maxVisible = 4,})
{
  int indexOffset = 1;
  double standartOffset = 60.0;
  
  Widget plusEl = Container();

  if(imgs.length>maxVisible){
    indexOffset++;
    plusEl = Positioned(
      left:  size/2.5+offset + standartOffset - (size/1.77),
      bottom: 0,
      child: Icon(Icons.add,color: Colors.black, size: size+borderWidth*2,)
      );
  }

  List<Widget> mainList = imgs.asMap().map((i, String url){  
    if((i+1)>maxVisible)
      return MapEntry(i,Container());
    return MapEntry(i,Positioned(
      left: offset + standartOffset - (i+indexOffset)*(size/1.77),
      bottom: 0,
      child:  socialNetView(
        size: size,
        url: url,
        borderColor: borderColor,
        borderWidth: borderWidth
      ),)
    );}).values.toList();

  List<Widget> finalList = [plusEl,...mainList];

  
  return Container(
    height: contHeight,
    child: Stack(
            children: finalList
          ),
  );
}


//Acount image + social under
Widget accAndSocialView({double size = 60,Color borderColor = Colors.white,String imageUrl = Globals.standartImg, String socImageUrl, double borderWidth = 2.0})
{
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      border: Border.all(color: borderColor ,width: borderWidth),
      shape: BoxShape.circle,
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AdvancedNetworkImage(
            imageUrl,
            useDiskCache: true,
            cacheRule: CacheRule(maxAge: const Duration(days: 10))
          ),//NetworkImage(_url)
      ),
    ),
    
    alignment: Alignment.bottomRight,
    child:  socialNetView(size: size/2.60869565,url: socImageUrl, borderColor: borderColor, borderWidth: borderWidth),
  );
}

//just social network image
Widget socialNetView({double size = 23, double borderWidth = 2.0, Color borderColor = Globals.interfaceCol, String url = Globals.instImg}){
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderWidth),
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AdvancedNetworkImage(
                url,
                useDiskCache: true,
                cacheRule: CacheRule(maxAge: const Duration(days: 10))
              ),
            )
          ),
        );
}