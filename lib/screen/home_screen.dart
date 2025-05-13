import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// URI/URL을 생성하는데 도움을 주는 클래스
final uri = Uri.parse('http://14.49.189.152:8094/');

class homeScreen extends StatefulWidget {
  final String? fcmToken;
  const homeScreen({super.key, required this.fcmToken});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late final WebViewController _webViewController;

  // ❶ 컨트롤러 변수 생성
  final int _currentIndex = 0;

  // 각 탭에 표시할 화면 목록
  final List<Widget> _pages = [
    const Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    /*Center(child: Text('Search', style: TextStyle(fontSize: 24))),*/
    const Center(child: Text('GPT', style: TextStyle(fontSize: 24))),
  ];

  // 각 탭에 연결된 URL 목록
  final List<String> _urls = [
    'http://14.49.189.152:8094/',
    'https://chatgpt.com/',
  ];

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (widget.fcmToken != null) {
              _webViewController.runJavaScript(
                'receiveFcmToken("${widget.fcmToken}")',
              );
            }
          },
        ),
      )
      ..loadRequest(uri);
  }

  // final WebViewController _webViewController = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setNavigationDelegate(NavigationDelegate(onPageFinished: (String url) {
  //     if (widget.fcmToken != null) {
  //       _webViewController
  //           .runJavaScript('receiveFcmToken("${widget.fcmToken}")');
  //     }
  //   }))
  //   ..loadRequest(uri);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /*appBar: AppBar(title: Text('Grove'), centerTitle: true, actions: [IconButton(onPressed: () {
          controller: _webViewController.loadRequest(uri);
        }, icon: Icon(Icons.home))],),*/

        body: WebViewWidget(
          controller: _webViewController,
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: _currentIndex, // 현재 선택된 탭 인덱스
        //   onTap: (index) {
        //     setState(() {
        //       _currentIndex = index; // 탭 전환 시 상태 업데이트
        //       _webViewController.loadRequest(Uri.parse(_urls[index]));
        //       print(index);
        //       print(' FCM token ::  ${widget.fcmToken}');
        //       _webViewController.runJavaScript(
        //         'receiveFcmToken("${widget.fcmToken}")',
        //       );
        //       if (index == 0) {
        //       } else {}
        //     });
        //   },
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     /*BottomNavigationBarItem(
        //       icon: Icon(Icons.search),
        //       label: 'Search',
        //     ),*/
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings),
        //       label: 'setting',
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
