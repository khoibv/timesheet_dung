// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      position: json['department_id'] as String,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['work_email'] as String,
      avatar: json['image_small'] as String,
      lastUpdate: json['__last_update'] as String,
      workPhone: json['work_phone'] as String,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'work_email': instance.email,
      'department_id': instance.position,
      'image_small': instance.avatar,
      '__last_update': instance.lastUpdate,
      'work_phone': instance.workPhone,
    };
