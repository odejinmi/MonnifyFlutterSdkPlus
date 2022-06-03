import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monnify_flutter_sdk_plus/monnify_flutter_sdk_plus_method_channel.dart';

void main() {
  MethodChannelMonnifyFlutterSdkPlus platform =
      MethodChannelMonnifyFlutterSdkPlus();
  const MethodChannel channel = MethodChannel('monnify_flutter_sdk_plus');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
