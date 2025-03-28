import 'package:flutter/material.dart';
import 'package:reactive_variables/reactive_variables.dart';
import 'package:test_work/domain/notifications_settings.dart';
import 'package:test_work/features/my_home_page/my_home_page.dart';

abstract base class MyHomePageBloc extends State<MyHomePage> {
  final AppNotificationSettings _notificationSettings =
      AppNotificationSettings();

  Rv<bool> rvIsLoading = Rv<bool>(false);
  bool get isLoading => rvIsLoading.value;
  set isLoading(bool v) => rvIsLoading.trigger(v);

  Rv<String> rvToken = Rv<String>('');
  String get token => rvToken.value;
  set token(String v) => rvToken.trigger(v);

  Rv<bool> rvPermissionGranted = Rv<bool>(false);
  bool get permissionGranted => rvPermissionGranted.value;
  set permissionGranted(bool v) => rvPermissionGranted.trigger(v);

  bool _notificationIsInit = false;

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  Future<void> _initNotification() async {
    await _notificationSettings.initLocalNotifications();
    await _notificationSettings.initNotifications();
    _notificationIsInit = true;
  }

  Future<void> fetchToken() async {
    isLoading = true;
    if (!_notificationIsInit) {
      _initNotification();
    }
    token = await _notificationSettings.updateToken();
    permissionGranted = _notificationSettings.permission;
    isLoading = false;
  }
}
