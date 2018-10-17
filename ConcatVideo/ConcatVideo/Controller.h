/*
 
 Written by Jared Bruni - http://github.com/lostjared
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
 
*/

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

