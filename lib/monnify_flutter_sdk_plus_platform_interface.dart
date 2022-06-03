import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'monnify_flutter_sdk_plus_method_channel.dart';

abstract class MonnifyFlutterSdkPlusPlatform extends PlatformInterface {
  /// Constructs a MonnifyFlutterSdkPlusPlatform.
  MonnifyFlutterSdkPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static MonnifyFlutterSdkPlusPlatform _instance = MethodChannelMonnifyFlutterSdkPlus();

  /// The default instance of [MonnifyFlutterSdkPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelMonnifyFlutterSdkPlus].
  static MonnifyFlutterSdkPlusPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MonnifyFlutterSdkPlusPlatform] when
  /// they register themselves.
  static set instance(MonnifyFlutterSdkPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
