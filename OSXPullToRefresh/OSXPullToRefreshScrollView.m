//
//  OSXPullToRefreshScrollView.m
//  OSXPullToRefresh
//
//  Created by surrender on 14-1-10.
//  Copyright (c) 2014年 surrender. All rights reserved.
//

#import "OSXPullToRefreshScrollView.h"

#define HEADERVIEW_HEIGHT 30

@implementation OSXPullToRefreshScrollView
@synthesize isRefreshing = _isRefreshing;

- (void)awakeFromNib
{
    //receive the notification that NSView's bounds changes posted
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boundsDidChanged:) name:NSViewBoundsDidChangeNotification object:nil];
    //receive the notification that NSWindow size changes posted
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:nil];
}

- (void)boundsDidChanged:(NSNotification *)note
{
    if (_isRefreshing) return;
    
    if ([self isOverHeadView]) {
        [_textField setHidden:YES];
        [_indicator setHidden:NO];
    }else{
        [_textField setHidden:NO];
        [_indicator setHidden:YES];
    }
}

- (void)windowDidResize:(NSNotification *)note
{
    if (_isRefreshing) {
        [_headerView removeFromSuperview];
    }else{
        [self createHeaderView:NSMakePoint(0, 0-HEADERVIEW_HEIGHT)];
    }
}


- (void)createHeaderView:(NSPoint)originPoint
{
    if (_headerView) {
        [_headerView removeFromSuperview];
        _headerView = nil;
    }
    
    NSRect contentRect = [[self contentView] frame];
    _headerView = [[NSView alloc]initWithFrame:NSMakeRect(originPoint.x,originPoint.y,contentRect.size.width, HEADERVIEW_HEIGHT)];
    
    _textField = [[NSTextField alloc]initWithFrame:NSMakeRect((contentRect.size.width/2 - 30), 0, 60, 30)];
    [_textField setBordered:NO];
    [_textField setSelectable:NO];
    [_textField setStringValue:@"下拉刷新"];
    [_textField setBackgroundColor:[NSColor controlColor]];
    
    _indicator = [[NSProgressIndicator alloc]initWithFrame:NSMakeRect((contentRect.size.width/2 - 16), 0, 32, 32)];
    [_indicator setStyle:NSProgressIndicatorSpinningStyle];
    [_indicator setBezeled:NO];
    
    [_headerView addSubview:_textField];
    [_headerView addSubview:_indicator];
    
    _headerView.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewWidthSizable | NSViewMinYMargin |NSViewMaxYMargin |NSViewHeightSizable;
    [_headerView setAutoresizesSubviews:YES];
    
    [self.contentView addSubview:_headerView];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    //theEvent.deltaY can not ensure upward or downword if user set mouse scroll direction wired
    //if isRefreshing,so stop the scroll
    if (_isRefreshing) return;
    if (theEvent.phase == NSEventPhaseEnded) {
        if (!_isRefreshing && [self isOverHeadView]) {
            [self startLoading];
        }
    }
    //without next,the bounds changed notification can not post
    [super scrollWheel:theEvent];
}

- (BOOL)isOverHeadView
{
    NSClipView *clipView = [self contentView];
    CGFloat scrolledY = clipView.bounds.origin.y;
    CGFloat miniScrolledY = 0 - HEADERVIEW_HEIGHT;
    return scrolledY <= miniScrolledY;
    //  return abs(scrolledY) > HEADERVIEW_HEIGHT; // > or = is both ok
}

- (void)startLoading
{
    _isRefreshing = YES;
    // move downwards documentView  30 Pix
    [self.documentView setFrameOrigin:NSMakePoint(0,HEADERVIEW_HEIGHT)];
    //设置_headerView的初始位置到（0,0）;
    [self createHeaderView:NSMakePoint(0, 0)];
    [self.contentView addSubview:_headerView];
    
    [self.contentView scrollToPoint:NSMakePoint(0, 0)];
    
    [_textField setHidden:YES];
    [_indicator startAnimation:nil];
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:3];
}

- (void)stopLoading
{
    _isRefreshing = NO;
    [self createHeaderView:NSMakePoint(0, 0-HEADERVIEW_HEIGHT)];
    [[self.documentView animator]setFrameOrigin:NSMakePoint(0, 0)];
}
@end
