//
//  PSVideoController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/28/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBYouTube.h"

@interface PSVideoController : UIViewController <LBYouTubePlayerControllerDelegate>{
    
}

@property (nonatomic, strong) LBYouTubePlayerController* youtubeController;
@property (nonatomic, copy) NSString *videoURLStr;

@end
