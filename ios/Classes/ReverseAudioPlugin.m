#import "ReverseAudioPlugin.h"
#import <reverse_audio/reverse_audio-Swift.h>

@implementation ReverseAudioPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftReverseAudioPlugin registerWithRegistrar:registrar];
}
@end
