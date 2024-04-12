import 'package:flutter/material.dart';

class MenuContent
{
  String content;
  bool isTitle=false;
  IconData? icon;
  bool hasLink=false;
  String link='';
  bool isSelected=false;
  MenuContent(this.content,this.isTitle);
  MenuContent.withIcon(this.content,this.icon);
  MenuContent.withLink(this.content,this.icon,this.hasLink,this.link);
}

