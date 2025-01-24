import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_talk/core/utils/app_logger.dart';

class StorageManager {
  static const String _userBoxName = 'userData';
  static const String _cacheBoxName = 'cache';
  static const String _settingsBoxName = 'settings';
  static const String _typingRecordsBoxName = 'typingRecords'; // 타자 기록용
  static const String _textCollectionBoxName = 'textCollections';

  static late SharedPreferences _prefs;
  static late Box _userBox;
  static late Box _cacheBox;
  static late Box _settingsBox;
  static late Box _typingRecordsBox;
  static late Box _textCollectionBox;

  static bool _initialized = false;

  /// StorageManager 초기화
  /// 앱 시작시 반드시 호출되어야 합니다.
  static Future<void> init() async {
    if (_initialized) {
      AppLogger.warning('StorageManager가 이미 초기화되어 있습니다.');
      return;
    }

    try {
      _prefs = await SharedPreferences.getInstance();
      await Hive.initFlutter();

      // 각 목적별 Box 초기화
      _userBox = await Hive.openBox(_userBoxName);
      _cacheBox = await Hive.openBox(_cacheBoxName);
      _settingsBox = await Hive.openBox(_settingsBoxName);
      _typingRecordsBox = await Hive.openBox(_typingRecordsBoxName);
      _textCollectionBox = await Hive.openBox(_textCollectionBoxName);

      _initialized = true;
      AppLogger.info('StorageManager 초기화 완료');
    } catch (e) {
      AppLogger.error('StorageManager 초기화 실패: $e');
      rethrow;
    }
  }

  /// 초기화 여부 확인
  static void _checkInitialization() {
    if (!_initialized) {
      throw StateError('StorageManager가 초기화되지 않았습니다. init()을 먼저 호출하세요.');
    }
  }
  // 사용자 데이터 관련 메서드

  /// 사용자 데이터 저장
  static Future<void> saveUserData(String key, dynamic data) async {
    _checkInitialization();
    try {
      await _userBox.put(key, data);
      AppLogger.info('사용자 데이터 저장 완료: $key');
    } catch (e) {
      AppLogger.error('사용자 데이터 저장 실패: $e');
      rethrow;
    }
  }

  /// 사용자 데이터 조회
  static T? getUserData<T>(String key) {
    _checkInitialization();
    try {
      return _userBox.get(key) as T?;
    } catch (e) {
      AppLogger.error('사용자 데이터 조회 실패: $e');
      return null;
    }
  }

  /// 사용자 데이터 삭제
  static Future<void> removeUserData(String key) async {
    _checkInitialization();
    try {
      await _userBox.delete(key);
      AppLogger.info('사용자 데이터 삭제 완료: $key');
    } catch (e) {
      AppLogger.error('사용자 데이터 삭제 실패: $e');
      rethrow;
    }
  }

  // 캐시 데이터 관련 메서드

  /// 캐시 데이터 저장
  static Future<void> saveCacheData(String key, dynamic data) async {
    _checkInitialization();
    try {
      await _cacheBox.put(key, data);
    } catch (e) {
      AppLogger.error('캐시 데이터 저장 실패: $e');
      rethrow;
    }
  }

  /// 캐시 데이터 조회
  static T? getCacheData<T>(String key) {
    _checkInitialization();
    try {
      return _cacheBox.get(key) as T?;
    } catch (e) {
      AppLogger.error('캐시 데이터 조회 실패: $e');
      return null;
    }
  }

  /// 모든 캐시 데이터 삭제
  static Future<void> clearCache() async {
    _checkInitialization();
    try {
      await _cacheBox.clear();
      AppLogger.info('캐시 데이터 전체 삭제 완료');
    } catch (e) {
      AppLogger.error('캐시 데이터 삭제 실패: $e');
      rethrow;
    }
  }

  // 설정 데이터 관련 메서드

  /// 설정 데이터 저장
  static Future<void> saveSettings(String key, dynamic data) async {
    _checkInitialization();
    try {
      await _settingsBox.put(key, data);
      AppLogger.info('설정 데이터 저장 완료: $key');
    } catch (e) {
      AppLogger.error('설정 데이터 저장 실패: $e');
      rethrow;
    }
  }

  /// 설정 데이터 조회
  static T? getSettings<T>(String key) {
    _checkInitialization();
    try {
      return _settingsBox.get(key) as T?;
    } catch (e) {
      AppLogger.error('설정 데이터 조회 실패: $e');
      return null;
    }
  }

  /// 모든 저장소 종료
  static Future<void> dispose() async {
    _checkInitialization();
    try {
      await _userBox.close();
      await _cacheBox.close();
      await _settingsBox.close();
      await _textCollectionBox.close();
      _initialized = false;
      AppLogger.info('StorageManager 종료 완료');
    } catch (e) {
      AppLogger.error('StorageManager 종료 실패: $e');
      rethrow;
    }
  }
}
