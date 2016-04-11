//
//  VSPlayerViewController.h
//  VideoStream
//
//  Created by Tarum Nadus on 11/16/12.
//  Copyright (c) 2012 MobileTR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSDecodeManager.h"

extern NSString* kVSPlayerStateChangedNotification;
extern NSString *kVSPlayerStateChangedUserInfoStateKey;
extern NSString *kVSPlayerStateChangedUserInfoErrorCodeKey;

@class VSGLView;
@interface VSPlayerViewController : UIViewController <VSDecoderDelegate> {
    NSString *_barTitle;
    BOOL _statusBarHidden;
    VSGLView *_renderView;
}

/* init Player View Controller with url & bar title */
- (id)initWithURL:(NSURL *)url barTitle:(NSString *)title;


@property (nonatomic, retain) NSString *barTitle;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, readonly) VSGLView *renderView;

@end
