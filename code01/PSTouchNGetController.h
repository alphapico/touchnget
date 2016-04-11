//
//  PSTouchNGetController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/29/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSTouchNGetController : UIViewController{

}

@property (nonatomic, strong) IBOutlet UILabel *pasLabel;
@property (strong, nonatomic) UIImageView *starterBackgroundView;

-(void)hideStarterBGView;

@end
