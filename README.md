Flutter 国际化 Demo。

国际化解决方案，确保应用能够支持中文和英文两种语言，并且可以应对未来从服务器加载语言包的需求。

### 1. 添加 `intl` 和 `flutter_localizations` 依赖

在 `pubspec.yaml` 中添加相关依赖：

```yaml
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.18.0
  flutter_localizations:
    sdk: flutter
```

### 2. 定义本地语言文件

将本地语言文件放在 `assets/lang_files/` 目录下，假设支持中文 (`zh`) 和英文 (`en`)：

```
assets/
  lang_files/
    en.json
    zh.json
```

语言文件的结构如下：

```json
// en.json
{
  "app_name": "My App",
  "welcome_message": "Welcome",
  "login_button": "Login"
}

// zh.json
{
  "app_name": "我的应用",
  "welcome_message": "欢迎",
  "login_button": "登录"
}
```

### 3. 创建国际化管理类

创建一个 `LangManager` 类，文件名称`lang_manager.dart`，用于加载语言文件并提供文本翻译功能：

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class LangManager {
  static final LangManager _instance = LangManager._internal();
  
  // 新增语言需要维护
  static const supportedLocales = [
    Locale('en'), // 支持英文
    Locale('zh'), // 支持中文
  ];

  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  Locale? _locale;
  Map<String, String> _localizedStrings = {};

  factory LangManager() {
    return _instance;
  }

  LangManager._internal();

  Locale? get locale => _locale;

  Future<void> load(Locale locale) async {
    _locale = locale;
    
    // 服务器语言包，可以在这里添加相关逻辑
    
    String jsonString =
        await rootBundle.loadString('assets/lang_files/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static LangManager of(BuildContext context) {
    return _instance;
  }
}

// 获取翻译文本的便捷方法
String lang(String key) {
  return LangManager().translate(key);
}
```

### 4. 配置应用的国际化支持

在main()函数里面加载语言文件：

```dart
void main() async {
  final langManager = LangManager();
  // 通过 await 关键字，我们确保 initialize 方法中的异步操作（加载语言文件）完成后再继续执行后续代码。
  await langManager.initialize();
  
  runApp(MyApp());
}
```

在 `MaterialApp` 中设置 `supportedLocales` 和 `localizationsDelegates`：

```dart
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      locale: LangManager().locale,
      supportedLocales: LangManager.supportedLocales,
      localizationsDelegates: LangManager.localizationsDelegates,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang('app_name')),
      ),
      body: Center(
        child: Text(lang('welcome_message')),
      ),
    );
  }
}
```

### 5. 支持从服务器动态加载语言包

当需要从服务器获取语言包时，可以扩展 `LangManager` 的 `load` 方法，动态从网络加载 JSON 文件，并更新 `_localizedStrings`：

```dart
Future<void> loadFromServer(String url, Locale locale) async {
  // 从服务器获取 JSON 数据
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = json.decode(response.body);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    _locale = locale;
  }
}
```

### 6. 切换语言

后续开发！！！

### 7. 更新 `pubspec.yaml` 以包含资源路径

在 `pubspec.yaml` 中添加资源路径配置：

```yaml
flutter:
  assets:
    - assets/lang_files/
```

### 8. 完整的 `pubspec.yaml` 示例

```yaml
name: app_name
description: app description

dependencies:
  flutter:
    sdk: flutter
  intl: ^0.18.0
  flutter_localizations:
    sdk: flutter

flutter:
  assets:
    - assets/lang_files/
```

### 9. 运行应用

现在你的应用已经可以支持多语言，默认支持本地的中文和英文，并且可以扩展到未来从服务器加载语言包。如果遇到问题，如果遇到问题执行 `flutter clean` 然后重新运行应用。

20240820 上传