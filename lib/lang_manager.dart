import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    String jsonString =
    await rootBundle.loadString('assets/lang_files/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    // notifyListeners(); // 通知所有监听此类的Widget更新 ，
  }

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await load(const Locale('zh')); // 默认语言
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
