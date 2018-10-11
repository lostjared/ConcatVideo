#ifndef __CONTROLLER_HEADER_H_
#define __CONTROLLER_HEADER_H_

#import<Cocoa/Cocoa.h>

enum class AddType {AT_ADD, AT_ADD_SCALE, AT_XOR, AT_AND, AT_OR, AT_ALPHA_BLEND, AT_XOR_BLEND};

@interface TableDelegate : NSObject<NSTableViewDataSource, NSTableViewDelegate> {
    
}
@property (strong,readwrite) NSMutableArray *values;
@end

@interface Controller : NSObject {
    IBOutlet NSButton *button_add,*button_remove,*button_concat,*button_up, *button_down, *button_video;
    IBOutlet NSTextField *concat_progress;
    IBOutlet NSTableView *table_view;
    IBOutlet NSPopUpButton *popup_button;
    TableDelegate *table_delegate;
}

@property (readwrite) BOOL stopVideoLoop;
@property (readwrite) BOOL videoProc;
@property (readwrite) BOOL showVideo;
@property (readwrite) AddType add_type;

- (IBAction) addVideos: (id) sender;
- (IBAction) removeVideo: (id) sender;
- (IBAction) concatVideos: (id) sender;
- (IBAction) moveUp: (id) sender;
- (IBAction) moveDown: (id) sender;
- (IBAction) quitApp: (id) sender;
- (IBAction) checkShowVideo: (id) sender;
- (IBAction) changeAddState: (id) sender;
@end

#endif

