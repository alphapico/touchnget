//
//  VideoFrame.h
//  MMSTv
//
//  Created by Tarum Nadus on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSVideoFrame : NSObject {
    int width;
    int height;
    NSMutableData *data;
    double pts;                                  ///< presentation time stamp for thispicture
    double duration;                             ///< expected duration of the frame
    int64_t pos;                                 ///< byte position in file
    int skip;
}

//@property(nonatomic, assign) AVPicture picture;
@property(nonatomic, assign) int width;
@property(nonatomic, assign) int height;
@property(nonatomic, assign) double pts;

@property(nonatomic, assign) double duration;
@property(nonatomic, assign) int64_t pos;
@property(nonatomic, assign) int skip;

@property (nonatomic, assign) NSMutableData *data;

@end
