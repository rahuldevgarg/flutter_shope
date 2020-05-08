import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_shop/di/AuthMech.dart';
class ImageUploadMech {
  int var5;
  int var3;
  int var0;
  int var1;
  int var2;
  int var7;
  int var6;
  int var4;
  var time;
  var userId = curUser.uid;
  String imgUrl ;
  ImageUploadMech(
      {this.var5,
        this.var3,
        this.var0,
        this.var1,
        this.var2,
        this.var7,
        this.var6,
        this.var4,this.time,this.imgUrl});

  setImgUrl(String url){
    imgUrl = url;
  }

  ImageUploadMech.fromJsonNow(Map<String, dynamic> json) {
    var5 = json['var5'];
    var3 = json['var3'];
    var0 = json['var0'];
    var1 = json['var1'];
    var2 = json['var2'];
    var7 = json['var7'];
    var6 = json['var6'];
    var4 = json['var4'];
    time = new DateTime.now();
  }
  ImageUploadMech.fromJsonA(Map<String, dynamic> json) {
    var5 = json['var5'];
    var3 = json['var3'];
    var0 = json['var0'];
    var1 = json['var1'];
    var2 = json['var2'];
    var7 = json['var7'];
    var6 = json['var6'];
    var4 = json['var4'];
    time = json['time'];
    imgUrl = json['img_url'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['var5'] = this.var5;
    data['var3'] = this.var3;
    data['var0'] = this.var0;
    data['var1'] = this.var1;
    data['var2'] = this.var2;
    data['var7'] = this.var7;
    data['var6'] = this.var6;
    data['var4'] = this.var4;
    data['uid'] = this.userId;
    data['time'] = this.time;
    data['img_url'] = this.imgUrl;
    return data;
  }

  List<dynamic> percent() {
    double sum = 0;
    List<double> result = new List<double>();
    result.add(this.var0.toDouble());
    result.add(this.var1.toDouble());
    result.add(this.var2.toDouble());
    result.add(this.var3.toDouble());
    result.add(this.var4.toDouble());
    result.add(this.var5.toDouble());
    result.add(this.var6.toDouble());
    result.add(this.var7.toDouble());
    for (int i = 0; i < 8; i++) {
      sum += result[i];
    }
    if (sum != 0) {
      for (int i = 0; i < 8; i++) {
        result[i] = ((result[i] * 100) / sum);
      }
      //return result;
    }
      List<String> sList = new List<String>();

      if (result[0] != 0.0) {
        print("percentage compare success");
        sList.add(
            "Nodule : " + result[0].toStringAsPrecision(4) + " %");
      }
      if (result[1] != 0.0) {
        print("percentage compare success");
        sList.add(
            "Open ComDone : " +
                result[1].toStringAsPrecision(4) +
                " %");
      }
      if (result[2] != 0.0) {
        print("percentage compare success");
        sList.add(
            "Cyst : " + result[2].toStringAsPrecision(4) + " %");
      }
      if (result[3] != 0.0) {
        print("percentage compare success");
        sList.add(
            "Normal Skin : " +
                result[3].toStringAsPrecision(4) +
                " %");
      }
      if (result[7] != 0.0) {
        print("percentage compare success");
        sList.add(
            "Pustule : " + result[7].toStringAsPrecision(4) + " %");
      }
      if (result[5] != 0.0) {
        print("percentage compare success");
        sList.add(
            "Closed ComDone : " +
                result[5].toStringAsPrecision(4) +
                " %");
      }
      if (result[6] != 0.0) {
        print("percentage compare success");
        sList.add(
            "Papule : " + result[6].toStringAsPrecision(4) + " %");
      }
      if (result[4] != 0.0) {
        print("percentage compare success");
        sList.add(
            "Others : " + result[4].toStringAsPrecision(4) + " %");
      }






    List<dynamic> grade = new List<String>();
    grade.add("gradeType");
    grade.add("shortDesc");
    grade.add("longDesc");

    if(result[3]>80){
      //normalskin
      grade[0] = '0';
      grade[1] = "No Acne";
      grade[2] = "No evidence of visible acne or lession.";
    }else{
      if((result[0]+result[2]+result[7])>12){
        grade[0] = '4';
        grade[1] = "Grade 4 (severe nodulocystic acne)";
        grade[2] = "Numerous large, painful pustules and nodules; inflammation. This stage is very severe. The blemishes are large. They can occur not only on the face but neck, shoulders, back and sometimes arms. They are deep and firm to touch. There are cysts which look like a boil or a big blister. The size of a cyst may be about half a centimeter in diameter. They contain pus inside. There are also firm or hard bumps called nodules. They do not contain pus.";
        //severeAcne
      }else if((result[2]+result[7]+result[6])>13){
        //moderate severe
        grade[0] = '3';
        grade[1] = "Grade 3 (moderately severe; nodulocystic acne)";
        grade[2] = "Numerous papules and pustules; the occasional inflamed nodule; the back and the chest may also be affected. Inflammation is marked and there will be a lot of papules and pustules over the face. Since the lesions occur near to each other, it can spread and merge with each other and look like crops. This will lead to skin damage and even without squeezing, scarring can occur once healed. In severe acne, infection is deep within the skin. There will be more redness and mild swelling of the face.";
      }else if((result[7]+result[6]+result[1]+result[5])>14){
        //moderaate acne
        grade[0] = '2';
        grade[1] = "Grade 2 (moderate, or pustular acne)";
        grade[2] = "Multiple papules and pustules, mostly confined to the face. n moderate acne, there are more blemishes. Apart from the T zone area, lesions can occur anywhere in the face. The skin has several whiteheads which are also called closed comedones. They appear like raised white or yellowish dots. When squeezed white material will come out.";
      }else if((result[6]+result[1]+result[5])>15){
        //mildacne
        grade[0] = '1';
        grade[1] = "Grade 1 (mild)";
        grade[2] = "Mostly confined to whiteheads and blackheads, with a few papules and pustules. Grade 1 Acne is the mildest  of 4 acne types hence it also most commonly know as mild acne. This Acne consists of comedones (blackheads) mostly on the nose, and a few papules which are small, red breakouts typically found on the cheeks. These breakouts are minimal and tend to be occasional.";
      }
    }
    List<dynamic> task = new List<dynamic>(2);
    task[0]=grade;
    task[1]=sList;
    return task;


  }
  String returnTime(){
    return time.toIso8601String().substring(0,19).replaceAll('T', "  ");
  }

  String sImage(){
    double sum = 0;
    List<double> result = new List<double>();
    result.add(this.var0.toDouble());
    result.add(this.var1.toDouble());
    result.add(this.var2.toDouble());
    result.add(this.var3.toDouble());
    result.add(this.var4.toDouble());
    result.add(this.var5.toDouble());
    result.add(this.var6.toDouble());
    result.add(this.var7.toDouble());
    for (int i = 0; i < 8; i++) {
      sum += result[i];
    }
    if(sum!=0){
      for (int i = 0; i < 8; i++) {
        result[i] = ((result[i] * 100) / sum);
      }
      String tyme = time.toIso8601String().substring(0,19).replaceAll('T', "  ");
      String ans = "\n\t\t\t\t\t\tTime : $tyme\n\n\nNodule : "+result[0].toStringAsPrecision(4)+" %\nOpen ComeDone : "+result[1].toStringAsPrecision(4) +
          " %\nCyst : "+result[2].toStringAsPrecision(4)+" %\nNormal Skin : "+result[3].toStringAsPrecision(4)+" %\nPustule : "+result[7].toStringAsPrecision(4)+
          " %\nClosed ComeDone : "+result[5].toStringAsPrecision(4)+" %\nPapule : "+result[6].toStringAsPrecision(4)+" %\nOthers : "+result[4].toStringAsPrecision(4) + " %\n";
      return ans;
    }
    else {
      return "\n\n\n\n\n\n\t\t\t\tImage was invalid.";
    }
  }



}
Future<ImageUploadMech> analyzeImage(String url, String body)async {
  return http.post(url, body: body).timeout(const Duration(seconds: 90)).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      Fluttertoast.showToast(
          msg: "Error while Fetching data ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0
      );
      throw new Exception("Error while fetching data");
    }

    return ImageUploadMech.fromJsonNow(json.decode(response.body));
  });
}


