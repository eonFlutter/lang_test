import 'package:flutter/material.dart';
import 'lang_manager.dart';

void main() async {
  final langManager = LangManager();
  // 通过 await 关键字，我们确保 initialize 方法中的异步操作（加载语言文件）完成后再继续执行后续代码。
  await langManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      locale: LangManager().locale,
      supportedLocales: LangManager.supportedLocales,
      localizationsDelegates: LangManager.localizationsDelegates,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(lang('app_name')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 居中对齐
          children: <Widget>[
            Text(
              lang('welcome_message'),
              style: const TextStyle(fontSize: 20, color: Color(0xFF000000)),
            ),
            const SizedBox(height: 20), // 添加一点间距
            ElevatedButton(
              onPressed: () {
                // 按钮点击事件处理
                print('测试按钮被点击了');
              },
              child: const Text('测试按钮'),
            ),
          ],
        ),
      ),

    );
  }
}
