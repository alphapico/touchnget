//
//  VSStreamInfoView.m
//  VideoStream
//
//  Created by Tarum Nadus on 08.02.2013.
//  Copyright (c) 2013 MobileTR. All rights reserved.
//

#import "VSStreamInfoView.h"
#import "VSDecodeManager.h"

#import <QuartzCore/QuartzCore.h>

@implementation VSStreamInfoView {
    
    UILabel *_labelTitleGeneral;
    UILabel *_labelConnection;
    UILabel *_labelConnectionValue;
    UILabel *_labelDownload;
    UILabel *_labelDownloadValue;
    UILabel *_labelBitrate;
    UILabel *_labelBitrateValue;

    UILabel *_labelTitleAudio;
    UITextView *_textViewAudio;

    UILabel *_labelTitleVideo;
    UITextView *_textViewVideo;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.6];

        CALayer *styleLayer = [[CALayer alloc] init];
        styleLayer.cornerRadius = 8.0;
        styleLayer.shadowColor= [[UIColor redColor] CGColor];
        styleLayer.shadowOffset = CGSizeMake(0, 0);
        styleLayer.shadowOpacity = 0.5;
        styleLayer.borderWidth = 1;
        styleLayer.borderColor = [[UIColor whiteColor] CGColor];
        styleLayer.frame = self.bounds;
        self.layer.cornerRadius = styleLayer.cornerRadius;
        [self.layer addSublayer:styleLayer];

        /* _labelTitleGeneral */
        _labelTitleGeneral = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 8.0, 240.0, 16.0)];
        _labelTitleGeneral.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _labelTitleGeneral.opaque = NO;
        _labelTitleGeneral.backgroundColor = [UIColor clearColor];
        _labelTitleGeneral.text = TR(@"General");
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            _labelTitleGeneral.textAlignment = NSTextAlignmentLeft;
        } else {
            //running on iOS 5.x
            _labelTitleGeneral.textAlignment = UITextAlignmentLeft;
        }
#else
        _labelTitleGeneral.textAlignment = UITextAlignmentLeft;
#endif
        _labelTitleGeneral.textColor = [UIColor whiteColor];
        _labelTitleGeneral.font = [UIFont boldSystemFontOfSize:15.0];
        [self addSubview:_labelTitleGeneral];

        /* _labelConnection */
        _labelConnection = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 29.0, 92.0, 16.0)];
        _labelConnection.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _labelConnection.numberOfLines = 1;
        _labelConnection.opaque = NO;
        _labelConnection.backgroundColor = [UIColor clearColor];
        _labelConnection.text = TR(@"Connection");
        _labelConnection.textColor = [UIColor whiteColor];
        _labelConnection.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_labelConnection];

        /* _labelConnectionValue */
        _labelConnectionValue = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 29.0, 140.0, 16.0)];
        _labelConnectionValue.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _labelConnectionValue.numberOfLines = 1;
        _labelConnectionValue.opaque = NO;
        _labelConnectionValue.backgroundColor = [UIColor clearColor];
        _labelConnectionValue.textColor = [UIColor colorWithWhite:1.000 alpha:1.000];
        _labelConnectionValue.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            _labelConnectionValue.lineBreakMode = NSLineBreakByTruncatingTail;
            _labelConnectionValue.minimumScaleFactor = 0.2;
        } else {
            //running on iOS 5.x
            _labelConnectionValue.lineBreakMode = UILineBreakModeTailTruncation;
            _labelConnectionValue.minimumFontSize = 11.0;
        }
#else
        _labelConnectionValue.lineBreakMode = UILineBreakModeTailTruncation;
        _labelConnectionValue.minimumFontSize = 11.0;
#endif

        _labelConnectionValue.font = [UIFont systemFontOfSize:13.0];
        _labelConnectionValue.text = TR(@"-");
        [self addSubview:_labelConnectionValue];

        /* _labelDownload */
        _labelDownload = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 50.0, 92.0, 16.0)];
        _labelDownload.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _labelDownload.numberOfLines = 1;
        _labelDownload.opaque = NO;
        _labelDownload.backgroundColor = [UIColor clearColor];
        _labelDownload.text = TR(@"Download");
        _labelDownload.textColor = [UIColor whiteColor];
        _labelDownload.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_labelDownload];

        /* _labelDownloadValue */
        _labelDownloadValue = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 50.0, 140.0, 16.0)];
        _labelDownloadValue.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _labelDownloadValue.numberOfLines = 1;
        _labelDownloadValue.opaque = NO;
        _labelDownloadValue.backgroundColor = [UIColor clearColor];
        _labelDownloadValue.textColor = [UIColor colorWithWhite:1.000 alpha:1.000];
        _labelDownloadValue.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            _labelDownloadValue.lineBreakMode = NSLineBreakByTruncatingTail;
            _labelDownloadValue.minimumScaleFactor = 0.2;
        } else {
            //running on iOS 5.x
            _labelDownloadValue.lineBreakMode = UILineBreakModeTailTruncation;
            _labelDownloadValue.minimumFontSize = 11.0;
        }
#else
        _labelDownloadValue.lineBreakMode = UILineBreakModeTailTruncation;
        _labelDownloadValue.minimumFontSize = 11.0;
#endif
        _labelDownloadValue.font = [UIFont systemFontOfSize:13.0];
        _labelDownloadValue.text = TR(@"-");
        [self addSubview:_labelDownloadValue];

        /* _labelBitrate */
        _labelBitrate = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 71.0, 92.0, 16.0)];
        _labelBitrate.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _labelBitrate.numberOfLines = 1;
        _labelBitrate.opaque = NO;
        _labelBitrate.backgroundColor = [UIColor clearColor];
        _labelBitrate.text = TR(@"Bitrate");
        _labelBitrate.textColor = [UIColor whiteColor];
        _labelBitrate.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_labelBitrate];

        /* _labelBitrateValue */
        _labelBitrateValue = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 71.0, 140.0, 16.0)];
        _labelBitrateValue.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _labelBitrateValue.numberOfLines = 1;
        _labelBitrateValue.opaque = NO;
        _labelBitrateValue.backgroundColor = [UIColor clearColor];
        _labelBitrateValue.textColor = [UIColor colorWithWhite:1.000 alpha:1.000];
        _labelBitrateValue.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            _labelBitrateValue.lineBreakMode = NSLineBreakByTruncatingTail;
            _labelBitrateValue.minimumScaleFactor = 0.2;
        } else {
            //running on iOS 5.x
            _labelBitrateValue.lineBreakMode = UILineBreakModeTailTruncation;
            _labelBitrateValue.minimumFontSize = 11.0;
        }
#else
        _labelBitrateValue.lineBreakMode = UILineBreakModeTailTruncation;
        _labelBitrateValue.minimumFontSize = 11.0;
#endif
        _labelBitrateValue.font = [UIFont systemFontOfSize:13.0];
        _labelBitrateValue.text = TR(@"-");
        [self addSubview:_labelBitrateValue];

        /* _labelTitleAudio */
        _labelTitleAudio = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 97.0, 240.0, 16.0)];
        _labelTitleAudio.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _labelTitleAudio.opaque = NO;
        _labelTitleAudio.backgroundColor = [UIColor clearColor];
        _labelTitleAudio.text = TR(@"Audio");
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            _labelTitleAudio.textAlignment = NSTextAlignmentLeft;
        } else {
            //running on iOS 5.x
            _labelTitleAudio.textAlignment = UITextAlignmentLeft;
        }
#else
        _labelTitleAudio.textAlignment = UITextAlignmentLeft;
#endif
        _labelTitleAudio.textColor = [UIColor whiteColor];
        _labelTitleAudio.font = [UIFont boldSystemFontOfSize:15.0];
        [self addSubview:_labelTitleAudio];

        /* _textViewAudio */
        _textViewAudio = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 115.0, 240.0, 44.0)];
        _textViewAudio.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _textViewAudio.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.000];
        _textViewAudio.editable = NO;
        _textViewAudio.opaque = NO;
        _textViewAudio.backgroundColor = [UIColor clearColor];
        _textViewAudio.pagingEnabled = YES;
        _textViewAudio.scrollEnabled = YES;
        _textViewAudio.showsHorizontalScrollIndicator = NO;
        _textViewAudio.showsVerticalScrollIndicator = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            _textViewAudio.textAlignment = NSTextAlignmentLeft;
        } else {
            //running on iOS 5.x
            _textViewAudio.textAlignment = UITextAlignmentLeft;
        }
#else
        _textViewAudio.textAlignment = UITextAlignmentLeft;
#endif
        _textViewAudio.textColor = [UIColor whiteColor];
        _textViewAudio.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_textViewAudio];

        /* _labelTitleVideo */
        _labelTitleVideo = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 161.0, 240.0, 16.0)];
        _labelTitleVideo.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _labelTitleVideo.opaque = NO;
        _labelTitleVideo.backgroundColor = [UIColor clearColor];
        _labelTitleVideo.text = TR(@"Video");
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            _labelTitleVideo.textAlignment = NSTextAlignmentLeft;
        } else {
            //running on iOS 5.x
            _labelTitleVideo.textAlignment = UITextAlignmentLeft;
        }
#else
        _labelTitleVideo.textAlignment = UITextAlignmentLeft;
#endif
        _labelTitleVideo.textColor = [UIColor whiteColor];
        _labelTitleVideo.font = [UIFont boldSystemFontOfSize:15.0];
        [self addSubview:_labelTitleVideo];

        /* _textViewVideo */
        _textViewVideo = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 179.0, 240.0, 44.0)];
        _textViewVideo.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _textViewVideo.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.000];
        _textViewVideo.editable = NO;
        _textViewVideo.opaque = NO;
        _textViewVideo.backgroundColor = [UIColor clearColor];
        _textViewVideo.pagingEnabled = YES;
        _textViewVideo.scrollEnabled = YES;
        _textViewVideo.showsHorizontalScrollIndicator = NO;
        _textViewVideo.showsVerticalScrollIndicator = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            _textViewVideo.textAlignment = NSTextAlignmentLeft;
        } else {
            //running on iOS 5.x
            _textViewVideo.textAlignment = UITextAlignmentLeft;
        }
#else
        _textViewVideo.textAlignment = UITextAlignmentLeft;
#endif
        _textViewVideo.textColor = [UIColor whiteColor];
        _textViewVideo.font = [UIFont systemFontOfSize:12.0];
        _textViewVideo.text = TR(@"...");
        [self addSubview:_textViewVideo];
    }
    return self;
}

- (void)updateSubviewsWithInfo:(NSDictionary *)info {
    NSString *strValConnection = [info objectForKey:STREAMINFO_KEY_CONNECTION];
    if (strValConnection) {
        _labelConnectionValue.text = strValConnection;
    }

    NSNumber *numValDownload = [info objectForKey:STREAMINFO_KEY_DOWNLOAD];
    if (numValDownload) {
        _labelDownloadValue.text = [NSString stringWithFormat:@"%lu KB",[numValDownload unsignedLongValue]/1024];
    }

    NSNumber *numValBitrate = [info objectForKey:STREAMINFO_KEY_BITRATE];
    if (numValBitrate) {
        _labelBitrateValue.text = [NSString stringWithFormat:@"%d kb/s",[numValBitrate intValue]/1000];
    }

    NSString *strValAudio = [info objectForKey:STREAMINFO_KEY_AUDIO];
    if (strValAudio) {
        _textViewAudio.text = strValAudio;
    }

    NSString *strValVideo = [info objectForKey:STREAMINFO_KEY_VIDEO];
    if (strValVideo) {
        _textViewVideo.text = strValVideo;
    }
}

#pragma mark - Memory deallocation

- (void)dealloc {
    [_labelTitleGeneral release];
    [_labelConnection release];
    [_labelConnectionValue release];
    [_labelDownload release];
    [_labelDownloadValue release];
    [_labelBitrate release];
    [_labelBitrateValue release];
    [_labelTitleAudio release];
    [_textViewAudio release];
    [_labelTitleVideo release];
    [_textViewVideo release];
    [super dealloc];
}

@end
