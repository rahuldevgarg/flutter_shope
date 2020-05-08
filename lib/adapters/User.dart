class User {
  String uid;
  int age;
  String sex;
  String name;
  String email;
  String avtarUrl;
  String mobile;
  String address;

  User({this.uid, this.age, this.sex, this.name, this.email, this.avtarUrl,this.mobile,this.address});

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    age = json['age'];
    sex = json['sex'];
    name = json['name'];
    email = json['email'];
    avtarUrl = json['avtarUrl'];
    mobile = json['mobile'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['age'] = this.age;
    data['sex'] = this.sex;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avtarUrl'] = this.avtarUrl;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    return data;
  }
}