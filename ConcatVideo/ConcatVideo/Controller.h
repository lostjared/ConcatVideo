#ifndef __CONTROLLER_HEADER_H_
#define __CONTROLLER_HEADER_H_

#import<Cocoa/Cocoa.h>

@interface Controller : NSObject {
    IBOutlet NSButton *button_add,*button_remove,*button_concat;
    IBOutlet NSTextField *conat_fps, *concat_w, *concat_h;
}
- (IBAction) addVideos: (id) sender;
- (IBAction) removeVideo: (id) sender;
- (IBAction) concatVideos: (id) sender;

@end

#endif

