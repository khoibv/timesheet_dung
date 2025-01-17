import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  const Employee({
    required this.position,
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.lastUpdate,
    required this.workPhone,
  });

  final int id;
  final String name;

  @JsonKey(name: 'work_email')
  final String email;

  @JsonKey(name: 'department_id')
  final String position;

  @JsonKey(name: 'image_small')
  final String avatar;

  @JsonKey(name: '__last_update')
  final String lastUpdate;

  @JsonKey(name: 'work_phone')
  final String workPhone;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  // factory Employee.fromJson(Map<String, dynamic> json) {
  //   try {
  //     return Employee(
  //         email: json['work_email'].toString(),
  //         avatar: json['image_small'].toString(),
  //         name: json['name'].toString(),
  //         id: json['id'],
  //         position: json['department_id'].toString(),
  //         last_update: json['__last_update'].toString(),
  //         work_phone: json['work_phone'].toString());
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  // factory Employee.fromRPC(res) {
  //   try {
  //     return Employee(
  //         email: res['work_email'].toString(),
  //         avatar: res['image_small'].toString(),
  //         name: res['name'].toString(),
  //         id: int.parse(res['id'].toString()),
  //         position: res['department_id'].toString(),
  //         last_update: res['__last_update'].toString(),
  //         work_phone: res['work_phone'].toString());
  //   } catch (e) {
  //     print(';;;;;;;;');
  //     print(e);
  //     rethrow;
  //   }
  // }

  @override
  String toString() =>
      '$runtimeType {id: $id, username: $name, email: $email, position: $position, avatar: $avatar}';
}
