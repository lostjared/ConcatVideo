#ifndef __CONTROLLER_HEADER_H_
#define __CONTROLLER_HEADER_H_

#import<Cocoa/Cocoa.h>


@interface TableDelegate : NSObject<NSTableViewDataSource, NSTableViewDelegate> {
    
}
@property (strong,readwrite) NSMutableArray *values;
@end

@interface Controller : NSObject {
    IBOutlet NSButton *button_add,*button_remove,*button_concat,*button_up, *button_down;
    IBOutlet NSTextField *conat_fps, *concat_w, *concat_h;
    IBOutlet NSTableView *table_view;
    TableDelegate *table_delegate;
}
- (IBAction) addVideos: (id) sender;
- (IBAction) removeVideo: (id) sender;
- (IBAction) concatVideos: (id) sender;
- (IBAction) moveUp: (id) sender;
- (IBAction) moveDown: (id) sender;
@end

#endif

