#include "Controller.h"
#include"CV.hpp"

@implementation TableDelegate

@synthesize values;

- (void) createValues {
    values = [[NSMutableArray alloc] init];
}

- (id) tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    NSString *str =  [[aTableColumn headerCell] stringValue];
    if( [str isEqualToString:@"Index"] ) {
        NSString *s = [NSString stringWithFormat:@"%d",  (int)rowIndex+1, nil];
        return s;
    }
    else if([str isEqualToString:@"Video File"]) {
        return [values objectAtIndex: rowIndex];
    }
    return @"";
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [values count];
}



@end

@implementation Controller

- (void) awakeFromNib {
    table_delegate = [[TableDelegate alloc] init];
    [table_delegate createValues];
    [table_view setDelegate: table_delegate];
    [table_view setDataSource: table_delegate];
    [table_view reloadData];
}

- (IBAction) addVideos: (id) sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:YES];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"mov", @"avi", @"mkv", @"m4v",nil]];
    if([panel runModal]) {
        for(int i = 0; i < [[panel URLs] count]; ++i) {
            NSString *s = [[[panel URLs] objectAtIndex:i] path];
            [table_delegate.values addObject:s];
        }
        [table_view reloadData];
    }
}
- (IBAction) removeVideo: (id) sender {
    NSInteger row = [table_view selectedRow];
    if(row >= 0) {
        [table_delegate.values removeObjectAtIndex:row];
        [table_view reloadData];
    }
}
- (IBAction) concatVideos: (id) sender {
    cv::VideoWriter writer;
}

- (IBAction) moveUp: (id) sender {
    NSInteger index = [table_view selectedRow];
    if(index > 0) {
        NSInteger pos = index-1;
        id obj = [table_delegate.values objectAtIndex:pos];
        id mv = [table_delegate.values objectAtIndex:index];
        [table_delegate.values setObject:obj atIndexedSubscript:index];
        [table_delegate.values setObject:mv atIndexedSubscript: pos];
        [table_view deselectAll:self];
        [table_view reloadData];
    }
}

- (IBAction) moveDown: (id) sender {
    NSInteger index = [table_view selectedRow];
    if(index < [table_delegate.values count]-1) {
        NSInteger pos = index+1;
        id obj = [table_delegate.values objectAtIndex:pos];
        id mv = [table_delegate.values objectAtIndex:index];
        [table_delegate.values setObject:obj atIndexedSubscript:index];
        [table_delegate.values setObject:mv atIndexedSubscript: pos];
        [table_view deselectAll:self];
        [table_view reloadData];
    }
}

@end
