#import "GetxfirePlugin.h"
#if __has_include(<getxfire/getxfire-Swift.h>)
#import <getxfire/getxfire-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "getxfire-Swift.h"
#endif

@implementation GetxfirePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGetxfirePlugin registerWithRegistrar:registrar];
}
@end
