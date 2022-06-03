#import "MonnifyFlutterSdkPlusPlugin.h"
#if __has_include(<monnify_flutter_sdk_plus/monnify_flutter_sdk_plus-Swift.h>)
#import <monnify_flutter_sdk_plus/monnify_flutter_sdk_plus-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "monnify_flutter_sdk_plus-Swift.h"
#endif

@implementation MonnifyFlutterSdkPlusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMonnifyFlutterSdkPlusPlugin registerWithRegistrar:registrar];
}
@end
