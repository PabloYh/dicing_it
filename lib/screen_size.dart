import 'package:flutter/cupertino.dart';

abstract class ScreenSize{

  static double getHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static double getWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }


  static double getFractionHeight(BuildContext context, double divider){
    return (MediaQuery.of(context).size.height / divider);
  }

  static double getFractionWidth(BuildContext context, double divider){
    return (MediaQuery.of(context).size.width / divider);
  }

}