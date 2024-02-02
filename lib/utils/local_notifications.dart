import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';


//push notifications - sent from a server
//local notifications - generated and managed directly within the app
class LocalNotifications{
  late final String channelId;
  late final String channelName;

  //instance of FlutterLocalNotificationsPlugin
  static final  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin
  = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  //on tap on any notification
  //payload - data that parses within notification
  static void onNotificationTap(NotificationResponse notificationResponse){
    onClickNotification.add(notificationResponse.payload!);
  }

  //init local notification service for android
  static Future init() async{
    //set up settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    //use plugin to initialize settings
    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  //show simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }
  ) async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'your channel 0',
        'your channel simple',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    //holds notification details based on concrete platform
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    //method show creates notification
    await _flutterLocalNotificationsPlugin.show(
        0, //unique identifier of a notification
        title, //title for the notification
        body, //the notification message
        notificationDetails, //where we pass in the notificationDetails object
        payload: payload //holds the data that is passed through the notification when the notification is tapped
    );
  }

  static Future showPeriodicNotification({
    required String title,
    required String body,
    required String payload,
  }) async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel 1', 'your channel periodic',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        1, title, body, RepeatInterval.everyMinute, notificationDetails);
  }

  static Future showScheduleNotification({
    required String title,
    required String body,
    required String payload,
    required DateTime datetime,
  }) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    AndroidNotificationDetails androidNotificationDetails =
    currentUser == null
    ? const AndroidNotificationDetails("unauthorizedId", "unauthorizedName")
    : AndroidNotificationDetails(currentUser.uid, currentUser.email ?? "");
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);


    //init timezone package
    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        title,
        body,
        tz.TZDateTime.from(datetime, tz.local),//when a notification should be displayed
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }


  //close a specific channel notification
  static Future cancel(int id) async{
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
  //close a specific channel notification
  static Future cancelAll() async{
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<List<ActiveNotification>> getActiveNotifications() async{
    return await _flutterLocalNotificationsPlugin.getActiveNotifications();
  }

  static Future<List<ActiveNotification>?> getActiveUserNotifications(String channelId) async{
    await _flutterLocalNotificationsPlugin.getActiveNotifications()
        .then((value){return value.where((element) => element.channelId == channelId).toList();})
        .onError((error, stackTrace) {
      return List.empty();
    });
  }



}