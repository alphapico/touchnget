//
//  VSGLView.h
//  VideoStream
//
//  Created by Tarum Nadus on 11/16/12.
//  Copyright (c) 2012 MobileTR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSDecodeManager;
@class VSVideoFrame;

@interface VSGLView : UIView

/* initialize openGL view with DecodeManager */
- (int)initGLWithDecodeManager:(VSDecodeManager *)decoder;

/* update the openGL screen with new frame */
- (void)updateScreenWithFrame:(VSVideoFrame *)vidFrame;

/* destroy openGL view */
- (void)shutdown;

@end
