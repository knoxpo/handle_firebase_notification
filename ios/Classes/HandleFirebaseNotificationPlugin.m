#import "HandleFirebaseNotificationPlugin.h"
#if __has_include(<handle_firebase_notification/handle_firebase_notification-Swift.h>)
#import <handle_firebase_notification/handle_firebase_notification-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "handle_firebase_notification-Swift.h"
#endif

@implementation HandleFirebaseNotificationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHandleFirebaseNotificationPlugin registerWithRegistrar:registrar];
}
@end
