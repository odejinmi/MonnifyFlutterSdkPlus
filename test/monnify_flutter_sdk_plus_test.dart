import 'package:flutter_test/flutter_test.dart';
import 'package:monnify_flutter_sdk_plus/monnify_flutter_sdk_plus.dart';
import 'package:monnify_flutter_sdk_plus/monnify_flutter_sdk_plus_platform_interface.dart';
import 'package:monnify_flutter_sdk_plus/monnify_flutter_sdk_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMonnifyFlutterSdkPlusPlatform
    with MockPlatformInterfaceMixin
    implements MonnifyFlutterSdkPlusPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MonnifyFlutterSdkPlusPlatform initialPlatform =
      MonnifyFlutterSdkPlusPlatform.instance;

  test('$MethodChannelMonnifyFlutterSdkPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMonnifyFlutterSdkPlus>());
  });

  test('getPlatformVersion', () async {
    MonnifyFlutterSdkPlus monnifyFlutterSdkPlusPlugin = MonnifyFlutterSdkPlus();
    MockMonnifyFlutterSdkPlusPlatform fakePlatform =
        MockMonnifyFlutterSdkPlusPlatform();
    MonnifyFlutterSdkPlusPlatform.instance = fakePlatform;

    expect(await monnifyFlutterSdkPlusPlugin.getPlatformVersion(), '42');
  });
}
