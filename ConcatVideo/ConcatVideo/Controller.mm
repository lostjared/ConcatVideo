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
    
}
- (IBAction) removeVideo: (id) sender {
    
}
- (IBAction) concatVideos: (id) sender {
    cv::VideoWriter writer;
}

- (IBAction) moveUp: (id) sender {
    
}

- (IBAction) moveDown: (id) sender {
    
}

@end
