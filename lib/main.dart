import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel =
    AndroidNotificationChannel("id", "name", "description");

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage msg) async {
  await Firebase.initializeApp();
  print("background message: ${msg.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  await FirebaseMessaging.instance.subscribeToTopic("hello");

  runApp(MaterialApp(
    title: "FCM test app",
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    getDeviceToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      RemoteNotification? notification = msg.notification;
      AndroidNotification? androidNotification = msg.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    playSound: true, icon: '@mipmap/ic_launcher')));
      }
    });
    super.initState();
  }

  getDeviceToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    print(
        token); //fv3x5X6cQumXHQTF-rtoov:APA91bHor6IuKuypALlzutOhr1VzODQR5PsAsQf6O_BFSARomN0w-H4EggKousu53Rfn4X_wpXGQ4m2Z5JmAuSqyfRaRiySrzOgwKLNaR8eXfdsLp4qaH_zJ0F_Esylti2zzTVe_HOS9
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("firebase notification"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(child: Text("FCM")),
      ),
    );
  }
}
