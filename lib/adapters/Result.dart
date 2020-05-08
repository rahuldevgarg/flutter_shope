import 'package:flutter_shop/di/AuthMech.dart';

class Result {
  List<dynamic> diagnosis;
  List<dynamic> supportingEvidences;
  List<dynamic> conflictingEvidences;
  String conditionName;
  var time = new DateTime.now();
  var userId = curUser.uid;
  Result(
      {this.diagnosis,
        this.supportingEvidences,
        this.conflictingEvidences,
        this.conditionName,this.time,this.userId});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['diagnosis'] != null) {
      diagnosis = new List<Diagnosis>();
      json['diagnosis'].forEach((v) {
        diagnosis.add(new Diagnosis.fromJson(v));
      });
    }
    supportingEvidences = json['Supporting Evidences'].cast<String>();
    conflictingEvidences = json['Conflicting Evidences'].cast<String>();
    conditionName = json['Condition name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.diagnosis != null) {
      data['diagnosis'] = this.diagnosis.map((v) => v.toJson()).toList();
    }
    data['Supporting Evidences'] = this.supportingEvidences;
    data['Conflicting Evidences'] = this.conflictingEvidences;
    data['Condition name'] = this.conditionName;
    data['time'] = this.time;  //appended extra due to firestore database
    data['uid'] = this.userId; //appended extra due to firestore database

    return data;
  }
  String sResult(){
    String tyme = time.toIso8601String().substring(0,19).replaceAll('T', "  ");
    StringBuffer confE = new StringBuffer();
    conflictingEvidences.forEach((E)=>confE.write('\n $E'));
    String confEd = confE.toString();
    StringBuffer supportE = new StringBuffer();
    supportingEvidences.forEach((E)=>supportE.write('\n $E'));
    String supportEd = supportE.toString();
    StringBuffer diagE = new StringBuffer();
    for(var E in diagnosis){
      String n = E["name"];
      double p = E["probability"];
      diagE.write(' Name : $n \n Probability : $p\n\n');
    }
    String diagEd = diagE.toString();
    String sResult = "Time : $tyme\n" + "Condition Name : $conditionName\n" + "Diagnosis : \n\n$diagEd" +
        "Supporting Evidences : \n$supportEd\n\n" + "Conflicting Evidences : $confEd\n" ;



    return sResult;
  }
}

class Diagnosis {
  String name;
  double probability;

  Diagnosis({this.name, this.probability});

  Diagnosis.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    probability = json['probability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['probability'] = this.probability;
    return data;
  }
}
