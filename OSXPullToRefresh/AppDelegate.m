//
//  AppDelegate.m
//  OSXPullToRefresh
//
//  Created by surrender on 14-1-9.
//  Copyright (c) 2014年 surrender. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    // [_scrollView startLoading];
}


- (void)awakeFromNib
{
    [_textView setString:@"针对NSScrollView下拉刷新做了简单的实现，可以修改添加更加细致的效果，以及添加数据源和代理，谢谢支持!"];
}

@end
