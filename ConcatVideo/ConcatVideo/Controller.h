#ifndef __CONTROLLER_HEADER_H_
#define __CONTROLLER_HEADER_H_

#import<Cocoa/Cocoa.h>

@interface TableDelegate : NSObject<NSTableViewDataSource, NSTableViewDelegate> {
    
}
@property (strong,readwrite) NSMutableArray *values;
@end

@interface Controller : NSObject {
    IBOutlet NSButton *button_add,*button_remove,*button_concat,*button_up, *button_down;
    IBOutlet NSTextField *concat_progress;
    IBOutlet NSTableView *table_view;
    IBOutlet NSPopUpButton *popup_button;
    TableDelegate *table_delegate;
}

@property (readwrite) BOOL stopVideoLoop;
@property (readwrite) BOOL videoProc;

- (IBAction) addVideos: (id) sender;
- (IBAction) removeVideo: (id) sender;
- (IBAction) concatVideos: (id) sender;
- (IBAction) moveUp: (id) sender;
- (IBAction) moveDown: (id) sender;
- (IBAction) quitApp: (id) sender;
@end

#endif

