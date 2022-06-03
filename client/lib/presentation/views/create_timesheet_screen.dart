import 'package:client/core/app_style.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:provider/provider.dart';

import 'package:client/data/repositories/odoo_repositories/odoo_connect.dart';

class NewTimeSheet extends StatefulWidget {
  const NewTimeSheet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewTimeSheet();
  }
}

class _NewTimeSheet extends State<NewTimeSheet> {
  final List _headers = [
    'Date',
    'General Coming',
    'Over Time',
    'Leave',
    'Task Content'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Time Sheet'),
        actions: [
          IconButton(
              onPressed: () async {
                // var client = OdooConnect().client;
                // await client.authenticate('odoo', 'admin', 'admin') ;
                // var res = await client.callKw({
                //   'model': 'account.analytic.line',
                //   'method': 'search_read',
                //   'args': [],
                //   'kwargs': {
                //     'context': {'bin_size': true},
                //     'domain': [['user_id','=',1]],
                //     'fields': [],
                //   },
                // });
                var res = await OdooConnect().callUser();
                print('\nUser info: \n' + res.toString());
                //print(sl<TimeSheetProvider>().timeSheet.toJson());
              },
              icon: const Icon(Icons.save_outlined))
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<TimeSheetProvider>(
        builder: (context, provider, child) {
          return ExpandableTable(
            headerHeight: 50,
            firstColumnWidth: 100,
            header: ExpandableTableHeader(
                firstCell: Container(
                    margin: const EdgeInsets.all(1),
                    child: Center(
                        child: Text(
                      _headers[0],
                      style: AppStyles.tableHeaderStyle,
                    ))),
                children: List.generate(
                    _headers.length - 1,
                    (index) => Container(
                        margin: const EdgeInsets.all(1),
                        child: Center(
                            child: Text(
                          _headers[index + 1],
                          style: AppStyles.tableHeaderStyle,
                        ))))),
            rows: List.generate(
                DateUtils.getDaysInMonth(provider.timeSheet.sheetsDate.year,
                    provider.timeSheet.sheetsDate.month), (rowIndex) {
              var row = provider.timeSheet.rows[rowIndex];
              var isWeekend = row.date.weekday > 5;
              var rowColor = isWeekend
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : null;
              return ExpandableTableRow(
                  height: 60,
                  firstCell: Container(
                    margin: const EdgeInsets.only(bottom: 1),
                    color: rowColor,
                    child: Center(
                      child: Text(DateFormat('EE, dd/MM').format(row.date)),
                    ),
                  ),
                  children: <Widget>[
                    //General Coming
                    Container(
                      margin: const EdgeInsets.only(bottom: 1),
                      color: (row.date.weekday > 5 || row.leave != null)
                          ? Theme.of(context).primaryColor.withOpacity(0.2)
                          : null,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(
                            text: row.generalComing <= 0
                                ? '0.0'
                                : row.generalComing.toString()),
                        onChanged: (String value) {
                          if (value == '') {
                            value = '0';
                          }
                          row.generalComing = double.parse(value);
                          print(row.generalComing);
                        },
                      ),
                    ),
                    //Overtime
                    Container(
                      margin: const EdgeInsets.only(bottom: 1),
                      color: rowColor,
                      child: TextField(
                        enabled: row.leave == null ? true : false,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(
                            text: provider.timeSheet.rows[rowIndex].overTime
                                .toString()),
                        onChanged: (String value) {
                          if (value == '') {
                            value = '0';
                          }
                          row.overTime = double.parse(value);
                        },
                      ),
                    ),
                    //Leave
                    Container(
                      margin: const EdgeInsets.only(bottom: 1),
                      color: rowColor,
                      child: FlatButton(
                        onPressed: () {
                          showDialog(
                                  context: context,
                                  builder: (_) => const LeaveDialog())
                              .then((value) {
                            if (value != null) {
                              provider.setLeave(
                                  rowIndex, value[0], double.parse(value[1]));
                              row.overTime = 0;
                              row.generalComing -= double.parse(value[1]);
                            }
                          });
                        },
                        child: Center(
                          child: Text(provider.timeSheet.rows[rowIndex].leave ==
                                  null
                              ? '-'
                              : '${row.leave!.reason}: ${row.leave!.timeoff}'),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 1),
                      color: rowColor,
                      child: TextField(
                        maxLines: null,
                        textAlign: TextAlign.center,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(
                            text: provider.timeSheet.rows[rowIndex].contents ??
                                ''),
                        onChanged: (String value) {
                          if (value == '') {
                            row.contents = null;
                          }
                          row.contents = value;
                        },
                      ),
                    ),
                  ]);
            }),
          );
        },
      ),
    );
  }
}

class LeaveDialog extends StatefulWidget {
  const LeaveDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeaveDialog();
  }
}

class _LeaveDialog extends State<LeaveDialog> {
  late String? dropdownValue = null;

  final _textcontroller = TextEditingController();
  List<String> leaveList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Leave'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              hint: const Text('-Select reason-'),
              disabledHint: null,
              elevation: 16,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>[
                'Annual leave',
                'Special holiday',
                'Sick leave',
                'Unpaid leave',
                'Compensation leave'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _textcontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Time off',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (dropdownValue != null) {
              leaveList.add(dropdownValue!);
              leaveList.add(_textcontroller.text);
              Navigator.pop(context, leaveList);
            } else {
              Navigator.pop(context, null);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
