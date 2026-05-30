import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  //singleton, to create only one instance of notification
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  //initialize
  Future<void> initNotification() async{
    print("called");
    if(_isInitialized) return; //so that we dont reinitialize
    tz.initializeTimeZones();
    print("timezone done");
    
    //android settings
    const AndroidInitializationSettings initAndroidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    print("android initialized");
    //ios settings
    const DarwinInitializationSettings initIOSSettings= DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    print("ios too");
    //linux/desktop later

    //init settings, universal
    const InitializationSettings initSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIOSSettings,
    );
    print("Gloabal one done too");
    await notificationsPlugin.initialize(
      settings: initSettings,
    );
    print("notifications plugin initialized");
    await notificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>() ?.requestNotificationsPermission();
   print("final bit");
   _isInitialized = true;
   print("Set true");

  // print("STEP 1");

  // if (_isInitialized) return;

  // print("STEP 2");

  // const androidSettings =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // print("STEP 3");

  // const iosSettings = DarwinInitializationSettings();

  // print("STEP 4");

  // const initSettings = InitializationSettings(
  //   android: androidSettings,
  //   iOS: iosSettings,
  // );

  // print("STEP 5");

  // await notificationsPlugin.initialize(
  //   settings: initSettings,
  // );

  // print("STEP 6");

  // _isInitialized = true;
  }

  //this is the instant notification function
  Future<void> showNotifications({
    required int id,
    required String title,
    required String body,
  }) async{
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel_id',
        'Task Notifications',
        channelDescription: 'Task reminder notifications',
        importance: Importance.max,
        priority: Priority.high
      ),

      iOS: DarwinNotificationDetails(),
    );

    await notificationsPlugin.show(id: id,title: title,body: body,notificationDetails: notificationDetails);
  }

  //scheduled notifications
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async{
    if(scheduledDate.isBefore(DateTime.now())) return;  //if some mf puts a due date in the past, it should be ignored
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel_id', 
        'Task Notifications',
        channelDescription: 'Task reminder notifications',
        importance: Importance.max,
        priority: Priority.high
      ),

      iOS: DarwinNotificationDetails(),
    );
    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> requestPermissions() async{
    await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

    // final granted = await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //   ?.areNotificationsEnabled();
    // print("Notifications enabled: $granted");
  }

  //cancel notifications
  Future<void> cancelNotification(int id) async{
    await notificationsPlugin.cancel(id: id);
  }
  Future<void> cancelAllNotifications() async{
    await notificationsPlugin.cancelAll();
  }
}