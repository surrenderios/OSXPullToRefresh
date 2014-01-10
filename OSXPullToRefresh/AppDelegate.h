//
//  AppDelegate.h
//  OSXPullToRefresh
//
//  Created by surrender on 14-1-9.
//  Copyright (c) 2014年 surrender. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OSXPullToRefreshScrollView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end
