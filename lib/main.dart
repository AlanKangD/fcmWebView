import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grove_flutter/screen/home_screen.dart';

import 'firebase_options.dart';

// 백그라운드 메시지 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('백그라운드 메시지 수신: ${message.messageId}');
}

void main() async {
  /// 플러터 프레임워크가 앱을 실행할 준비가 될 때까지 기다림
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 백그라운드 메시지 핸들러 설정
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FCM 토큰 권한 요청 (iOS)
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('사용자 권한 상태: ${settings.authorizationStatus}');

  // FCM 토큰 가져오기
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $fcmToken');

  // 토큰 갱신 리스너
  FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
    print('FCM 토큰 갱신: $token');
  });

  // 포그라운드 메시지 핸들링
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('포그라운드 메시지 수신: ${message.messageId}');
  });

  runApp(MyApp(fcmToken: fcmToken));
}

class MyApp extends StatelessWidget {
  final String? fcmToken;
  const MyApp({super.key, required this.fcmToken});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM luncher',
      home: homeScreen(fcmToken: fcmToken),
    );
  }
}
