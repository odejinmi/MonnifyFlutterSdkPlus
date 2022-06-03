import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'monnify_flutter_sdk_plus_platform_interface.dart';

/// An implementation of [MonnifyFlutterSdkPlusPlatform] that uses method channels.
class MethodChannelMonnifyFlutterSdkPlus extends MonnifyFlutterSdkPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('monnify_flutter_sdk_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
