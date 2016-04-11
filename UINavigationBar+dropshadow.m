//
//  UINavigationBar+dropshadow.m
//  CelcomPush
//
//  Created by Muhamad Hisham Wahab on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+dropshadow.h"

@implementation UINavigationBar (dropshadow)

//http://ioscodesnippet.tumblr.com/post/10437516225/adding-drop-shadow-on-uinavigationbar

-(void)applyShadowStyle
{
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOpacity = 0.3f;
    
    //Default clipsToBounds is YES, will clip off the shadow, so we disable it
    self.clipsToBounds = NO;
}



@end
