#include"CV.hpp"
#include "Controller.h"

NSInteger _NSRunAlertPanel(NSString *msg1, NSString *msg2, NSString *button1, NSString *button2, NSString *button3);
void setVideo(std::vector<std::string> &v);
void cleanVideo();
void concatFrame(cv::Mat &frame);

@implementation TableDelegate

@synthesize values;

- (void) createValues {
    values = [[NSMutableArray alloc] init];
}

- (id) tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    NSString *str =  [[aTableColumn headerCell] stringValue];
    if( [str isEqualToString:@"Index"] ) {
        if(rowIndex == 0) {
            return @"Source";
        }
        else {
            NSString *s = [NSString stringWithFormat:@"%d",  (int)rowIndex, nil];
            return s;
        }
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

@synthesize stopVideoLoop;

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

- (IBAction) concatVideos: (id) sender {
    
    if([table_delegate.values count] <= 1) {
        _NSRunAlertPanel(@"You need to add at least two video files", @"Add some files...", @"Ok", nil, nil);
        return;
    }
    
    if([[button_concat title] isEqualToString:@"Concat"]) {
        cleanVideo();
        NSButton *button_concat_ = button_concat;
        [self setStopVideoLoop:NO];
        NSSavePanel *panel = [NSSavePanel savePanel];
        [panel setCanCreateDirectories:YES];
        [panel setAllowedFileTypes: [NSArray arrayWithObject:@"mov"]];
        double fps = 24, aw = 1920, ah = 1080;
        NSInteger add_button_index = [popup_button indexOfSelectedItem];
        switch(add_button_index) {
            case 0:
                add_type = AddType::AT_ADD;
                break;
            case 1:
                add_type = AddType::AT_ADD_SCALE;
                break;
            case 2:
                add_type = AddType::AT_AND;
                break;
            case 3:
                add_type = AddType::AT_OR;
                break;
            case 4:
                add_type = AddType::AT_XOR;
                break;
        }
        if([panel runModal]) {
            [button_concat setTitle: @"Stop"];
            TableDelegate *table_delegate_ = table_delegate;
            NSTextField *output_label = concat_progress;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                cv::VideoWriter writer;
                NSString *filename = [[panel URL] path];
                writer.open([filename UTF8String],CV_FOURCC('m', 'p', '4', 'v'), fps, cv::Size(aw, ah), true);
                if(!writer.isOpened()) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        _NSRunAlertPanel(@"Could not create file", @"Incorrect Path/Acesss ?", @"Ok", nil, nil);
                        [button_concat_ setTitle:@"Concat"];
                    });
                    return;
                }
                NSString *fstr = [table_delegate_.values objectAtIndex:0];
                cv::VideoCapture main_file([fstr UTF8String]);
                
                if(!main_file.isOpened()) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        _NSRunAlertPanel(@"Could not open source file", @"Could not open main file", @"Ok", nil, nil);
                        [button_concat_ setTitle:@"Concat"];
                    });
                    return;
                }
                
                std::vector<std::string> file_names;
                for(unsigned int i = 1; i < [table_delegate_.values count]; ++i) {
                    NSString *s = [table_delegate_.values objectAtIndex:i];
                    file_names.push_back([s UTF8String]);
                }
                setVideo(file_names);
                for(unsigned int i = 0; i < video_files.size(); ++i) {
                    if(!video_files[i]->openVideo()) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            _NSRunAlertPanel(@"Could not open file", [NSString stringWithFormat:@"Could not open: %s", video_files[i]->name.c_str()], @"Ok", nil, nil);
                            [button_concat_ setTitle:@"Concat"];
                        });
                        return;
                    }
                }
                bool active = true;
                double frame_max = main_file.get(cv::CAP_PROP_FRAME_COUNT);
                unsigned long index = 0, max_frame = static_cast<unsigned int>(frame_max);
                while(active) {
                    if([self stopVideoLoop] == YES) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [output_label setStringValue: @"Stopped"];
                            [button_concat_ setTitle:@"Concat"];
                        });
                        return;
                    }
                    cv::Mat frame;
                    if(!main_file.read(frame)) {
                        active = false;
                        break;
                    }
                    concatFrame(frame);
                    writer.write(frame);
                    ++index;
                    
                    double val = index;
                    double size = frame_max;
                    double percent = 0;
                    if(size != 0) {
                        percent = (val/size)*100;
                    }
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [output_label setStringValue: [NSString stringWithFormat:@"Writing Frames... [%ld/%ld] - %d%%", index, max_frame, (int)percent]];
                    });
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [output_label setStringValue: [NSString stringWithFormat:@"Complete wrote to file %@", filename]];
                });
                
            });
        }
    } else {
        [self setStopVideoLoop:YES];
    }
}

@end

void setVideo(std::vector<std::string> &v) {
    for(unsigned int i = 0; i < v.size(); ++i) {
        AC_VideoCapture *cap = new AC_VideoCapture();
        cap->setVideo(v[i]);
        video_files.push_back(cap);
    }
}

void cleanVideo() {
    for(unsigned int i = 0; i < video_files.size(); ++i)
        delete video_files[i];
    
    if(!video_files.empty())
    	video_files.erase(video_files.begin(), video_files.end());
}

void concatFrame(cv::Mat &frame) {
    cv::Mat frame2;
    
    double fade_amount = 1.0;
    if(video_files.size()>0)
        fade_amount = 1.0/1+video_files.size();
    
    for(unsigned int q = 0; q < video_files.size(); ++q) {
        if(video_files[q]->capture.isOpened() && video_files[q]->capture.read(frame2) == true) {
            for(unsigned int z = 0; z < frame.rows; ++z) {
                for(unsigned int i = 0; i < frame.cols; ++i) {
                    cv::Vec3b &pixel = frame.at<cv::Vec3b>(z, i);
                    int cX = AC_GetFX(frame2.cols, i, frame.cols);
                    int cY = AC_GetFZ(frame2.rows, z, frame.rows);
                    cv::Vec3b second_pixel = frame2.at<cv::Vec3b>(cY, cX);
                    for(unsigned int j = 0; j < 3; ++j) {
                        switch(add_type) {
                            case AddType::AT_ADD:
                                pixel[j] += second_pixel[j];
                                break;
                            case AddType::AT_ADD_SCALE:
                                pixel[j] += static_cast<unsigned char>(second_pixel[j]*fade_amount);
                                break;
                            case AddType::AT_XOR:
                                pixel[j] = pixel[j]^second_pixel[j];
                                break;
                            case AddType::AT_AND:
                                pixel[j] = pixel[j]&second_pixel[j];
                                break;
                            case AddType::AT_OR:
                                pixel[j] = pixel[j]|second_pixel[j];
                                break;
                        }
                    }
                }
            }
        }
    }
    
}

NSInteger _NSRunAlertPanel(NSString *msg1, NSString *msg2, NSString *button1, NSString *button2, NSString *button3) {
    NSAlert *alert = [[NSAlert alloc] init];
    if(button1 != nil) [alert addButtonWithTitle:button1];
    if(button2 != nil) [alert addButtonWithTitle:button2];
    if(msg1 != nil) [alert setMessageText:msg1];
    if(msg2 != nil) [alert setInformativeText:msg2];
    NSInteger rt_val = [alert runModal];
    return rt_val;
}
