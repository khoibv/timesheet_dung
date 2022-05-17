import 'package:client/core/di.dart';
import 'package:client/presentation/providers/tab_index.dart';
import 'package:client/presentation/views/tabs/dashboard_tab.dart';
import 'package:client/presentation/views/tabs/settings_tab.dart';
import 'package:client/presentation/views/tabs/viewsheets_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes.dart';
import 'app_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key) {
    _tabList = <Widget>[
      const DashBoardTab(key: ValueKey(0)),
      const ViewSheets(key: ValueKey(1)),
      const SettingsTab(key: ValueKey(2)),
    ];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final List<Widget> _tabList;
  final _tabTitleList = [
    tr('tabs.home.title'),
    tr('tabs.views.title'),
    tr('tabs.settings.title'),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TabIndex>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_tabTitleList[provider.currentIndex]),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(scaffoldKey: _scaffoldKey),
      body: _tabList[provider.currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () { Navigator.pushNamed(context, Routes.newTimeSheet);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
