import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel{
  String? id;
  String? area;
  String? type;
  String? subType;
  String? additionInfo;
  String? citizenName;
  String? convertToId;
  int? duration;
  List<String>? keyWords;
  List<String>? employees;
  List<String>? employeesId;
  List<String>? departments;
  bool? isDay;
  String? convertFrom;
  String? convertFromId;
  String? currentStage;
  int? selectedTypeIndex;
  int? selectedSubTypeIndex;
  String? convertTo;
  Timestamp? createAt;
  Timestamp? updateAt;

  bool? completed;

  TransactionModel({this.id,this.convertToId,this.convertFrom,this.convertFromId,
    this.currentStage,
    this.keyWords,this.completed,
    this.updateAt,
    this.duration,this.isDay,this.createAt,this.selectedSubTypeIndex,this.selectedTypeIndex,
    this.area, this.type,this.subType,this.additionInfo,
    this.citizenName,this.convertTo,this.employees,this.departments,this.employeesId});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    area = json['area'];
    type = json['type'];
    keyWords =json['keyWords']!=null? List.from(json['keyWords']):[];
    subType = json['subType'];
    employees =json['employees']!=null? List.from(json['employees']):[];
    departments =json['departments']!=null? List.from(json['departments']):[];
    employeesId =json['employeesId']!=null? List.from(json['employeesId']):[];
    isDay = json['isDay'];
    completed = json['completed']??false;
    additionInfo = json['additionInfo'];
    currentStage = json['currentStage'];
    citizenName = json['citizenName'];
    convertTo = json['convertTo'];
    convertToId = json['convertToId'];
    convertFrom = json['convertFrom'];
    selectedSubTypeIndex = json['selectedSubTypeIndex'];
    selectedTypeIndex = json['selectedTypeIndex'];
    convertFromId = json['convertFromId'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];

    duration = json['duration'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['area'] = area;
    data['type'] = type;
    data['subType'] = subType;
    data['additionInfo'] = additionInfo;
    data['currentStage'] = currentStage;
    data['selectedTypeIndex']=selectedTypeIndex;
    data['selectedSubTypeIndex']=selectedSubTypeIndex;
    data['keyWords'] = keyWords??[];
    data['employees'] = employees;
    data['departments'] = departments;
    data['employeesId'] = employeesId;
    data['citizenName'] = citizenName;
    data['convertFrom'] = convertFrom;
    data['convertFromId'] = convertFromId;
    data['convertTo'] = convertTo;
    data['convertToId'] = convertToId;
    data['createAt'] = createAt;
    data['updateAt'] = updateAt;
    data['duration'] = duration;
    data['isDay'] = isDay;
    data['completed'] = completed;
    return data;
  }
}