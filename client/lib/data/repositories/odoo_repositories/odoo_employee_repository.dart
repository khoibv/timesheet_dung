import 'package:easy_localization/easy_localization.dart';
import 'package:hsc_timesheet/core/base/base_response.dart';
import 'package:hsc_timesheet/data/models/employee.dart';
import 'package:hsc_timesheet/data/repositories/index.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import 'odoo_connect.dart';

class OdooEmployeeRepository extends EmployeeRepository with OdooConnect {
  @override
  Future<BaseResponse<List<Employee>>> getEmployeeList() async {
    try {
      var res = await client.callKw({
        'model': 'hr.employee',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [],
          'fields': [
            'name',
            'image_small',
            'active',
            'id',
            'work_email',
            'job_id',
            'department_id',
            'work_phone',
            '__last_update',
            'user_id',
          ],
        },
      });
      final List<Employee> userList =
          await res.map<Employee>((item) => Employee.fromJson(item)).toList();

      return BaseResponse.success(userList);
    } on OdooException catch (e) {
      await handleError(e);
      return BaseResponse.fail([e.message]);
    } on Exception catch (e) {
      await handleError(e);
      return BaseResponse.fail([tr('message.server_error')]);
    }
  }
}
