//
//  MHProgressHUD.m
//  BondedWarehouse
//
//  Created by Muhamad Hisham Wahab on 12/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MHProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface MHProgressHUD ()

@property (nonatomic, readwrite) MHProgressHUDMaskType maskType;
@property (nonatomic, readwrite) BOOL showNetworkIndicator;
@property (nonatomic, retain) NSTimer *fadeOutTimer;

@property (nonatomic, readonly) UIWindow *overlayWindow;
@property (nonatomic, readonly) UILabel *stringLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIActivityIndicatorView *spinnerView;

@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;

- (void)showWithStatus:(NSString*)string maskType:(MHProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show;
- (void)setStatus:(NSString*)string;
- (void)registerNotifications;
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle;
- (void)positionHUD:(NSNotification*)notification;

- (void)dismiss;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds;

@end

@implementation MHProgressHUD

@synthesize overlayWindow, hudView, maskType, showNetworkIndicator, fadeOutTimer, stringLabel, imageView, spinnerView, visibleKeyboardHeight;

static MHProgressHUD *sharedView = nil;

- (void)dealloc {
	
	self.fadeOutTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [hudView release];
    [stringLabel release];
    [imageView release];
    [spinnerView release];
    
    [super dealloc];
}

+ (MHProgressHUD*)sharedView {
	
	if(sharedView == nil)
		sharedView = [[MHProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	return sharedView;
}


+ (void)setStatus:(NSString *)string {
	[[MHProgressHUD sharedView] setStatus:string];
}

#pragma mark - Show Methods

+ (void)show {
    [[MHProgressHUD sharedView] showWithStatus:nil maskType:MHProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithStatus:(NSString *)status {
    [[MHProgressHUD sharedView] showWithStatus:status maskType:MHProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithMaskType:(MHProgressHUDMaskType)maskType {
    [[MHProgressHUD sharedView] showWithStatus:nil maskType:maskType networkIndicator:NO];
}

+ (void)showWithStatus:(NSString*)status maskType:(MHProgressHUDMaskType)maskType {
    [[MHProgressHUD sharedView] showWithStatus:status maskType:maskType networkIndicator:NO];
}

+ (void)showWithStatus:(NSString *)status networkIndicator:(BOOL)show {
    [[MHProgressHUD sharedView] showWithStatus:status maskType:MHProgressHUDMaskTypeNone networkIndicator:show];
}

+ (void)showWithMaskType:(MHProgressHUDMaskType)maskType networkIndicator:(BOOL)show {
    [[MHProgressHUD sharedView] showWithStatus:nil maskType:maskType networkIndicator:show];
}

+ (void)showWithStatus:(NSString*)status maskType:(MHProgressHUDMaskType)maskType networkIndicator:(BOOL)show {
    [[MHProgressHUD sharedView] showWithStatus:status maskType:maskType networkIndicator:show];
}

+ (void)showSuccessWithStatus:(NSString *)string {
    [MHProgressHUD showSuccessWithStatus:string duration:1];
}

+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    [MHProgressHUD show];
    [MHProgressHUD dismissWithSuccess:string afterDelay:duration];
}

+ (void)showErrorWithStatus:(NSString *)string {
    [MHProgressHUD showErrorWithStatus:string duration:1];
}

+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    [MHProgressHUD show];
    [MHProgressHUD dismissWithError:string afterDelay:duration];
}

#pragma mark - Dismiss Methods

+ (void)dismiss {
	[[MHProgressHUD sharedView] dismiss];
}

+ (void)dismissWithSuccess:(NSString*)successString {
	[[MHProgressHUD sharedView] dismissWithStatus:successString error:NO];
}

+ (void)dismissWithSuccess:(NSString *)successString afterDelay:(NSTimeInterval)seconds {
    [[MHProgressHUD sharedView] dismissWithStatus:successString error:NO afterDelay:seconds];
}

+ (void)dismissWithError:(NSString*)errorString {
	[[MHProgressHUD sharedView] dismissWithStatus:errorString error:YES];
}

+ (void)dismissWithError:(NSString *)errorString afterDelay:(NSTimeInterval)seconds {
    [[MHProgressHUD sharedView] dismissWithStatus:errorString error:YES afterDelay:seconds];
}


#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
        [self.overlayWindow addSubview:self];
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.maskType) {
            
        case MHProgressHUDMaskTypeBlack: {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
            
        case MHProgressHUDMaskTypeGradient: {
            
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f}; 
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }
    }
}

- (void)setStatus:(NSString *)string {
	
    CGFloat hudWidth = 280;
    CGFloat hudHeight = 30;
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    
    if(string) {
        CGSize stringSize = [string sizeWithFont:self.stringLabel.font constrainedToSize:CGSizeMake(230, 20)];
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;
        hudHeight = stringHeight + hudHeight; //+80
        
        if(stringWidth > hudWidth)
            hudWidth = ceil(stringWidth/2)*2;
        
        if(hudHeight > 100) {
            labelRect = CGRectMake(20, 15, stringWidth + 30, stringHeight); //12, 66, hudWidth, stringHeight
            hudWidth+=24;
        } else {
            hudWidth+=24;  
            labelRect = CGRectMake(20, 15, stringWidth + 30, stringHeight);    //(0, 66 ,hudwidht,  stringHeight)
        }
    }
	
	self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
	
    if(string)
        self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2 + 120, 25.0); // + 0, 36
	else
       	self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, CGRectGetHeight(self.hudView.bounds)/2);
	
	self.stringLabel.hidden = NO;
	self.stringLabel.text = string;
	self.stringLabel.frame = labelRect;
	
	if(string)
		self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+0.5 + 120, 25.0); // + 0, 40.5
	else
		self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+0.5, ceil(self.hudView.bounds.size.height/2)+0.5);
}

- (void)setFadeOutTimer:(NSTimer *)newTimer {
    
    if(fadeOutTimer)
        [fadeOutTimer invalidate], [fadeOutTimer release], fadeOutTimer = nil;
    
    if(newTimer)
        fadeOutTimer = [newTimer retain];
}


- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification 
                                               object:nil];  
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}


- (void)positionHUD:(NSNotification*)notification {
    
    CGFloat keyboardHeight;
    double animationDuration;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(UIInterfaceOrientationIsPortrait(orientation))
                keyboardHeight = keyboardFrame.size.height;
            else
                keyboardHeight = keyboardFrame.size.width;
        } else
            keyboardHeight = 0;
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    if(keyboardHeight > 0)
        activeHeight += statusBarFrame.size.height*2;
    
    activeHeight -= keyboardHeight;
    CGFloat posY = floor(activeHeight*0.45) - 0; // - 0
    CGFloat posX = orientationFrame.size.width/2; 
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI; 
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    } 
    
    if(notification) {
        [UIView animateWithDuration:animationDuration 
                              delay:0 
                            options:UIViewAnimationOptionAllowUserInteraction 
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    } 
    
    else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
    
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.hudView.transform = CGAffineTransformMakeRotation(angle); 
    self.hudView.center = newCenter;
}

#pragma mark - Master show/dismiss methods

- (void)showWithStatus:(NSString*)string maskType:(MHProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show {
    
	self.fadeOutTimer = nil;
	
    if(self.showNetworkIndicator)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.showNetworkIndicator = show;
    
    if(self.showNetworkIndicator)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	self.imageView.hidden = YES;
    self.maskType = hudMaskType;
	
	[self setStatus:string];
	[self.spinnerView startAnimating];
    
    if(self.maskType != MHProgressHUDMaskTypeNone) {
        self.overlayWindow.userInteractionEnabled = YES;
    } else {
        self.overlayWindow.userInteractionEnabled = NO;
    }
    
    [self.overlayWindow makeKeyAndVisible];
    [self positionHUD:nil];
    
	if(self.alpha != 1) {
        [self registerNotifications];
		self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
		
		[UIView animateWithDuration:0.15
							  delay:0
							options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
						 animations:^{	
							 self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3, 1/1.3);
                             self.alpha = 1;
						 }
						 completion:NULL];
	}
    
    [self setNeedsDisplay];
}


- (void)dismissWithStatus:(NSString*)string error:(BOOL)error {
	[self dismissWithStatus:string error:error afterDelay:0.9];
}


- (void)dismissWithStatus:(NSString *)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds {
    
    if(self.alpha != 1)
        return;
    
    if(self.showNetworkIndicator) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.showNetworkIndicator = NO;
    }
	
	if(error)
		self.imageView.image = [UIImage imageNamed:@"SVProgressHUD.bundle/error.png"];
	else
		self.imageView.image = [UIImage imageNamed:@"SVProgressHUD.bundle/success.png"];
	
	self.imageView.hidden = NO;
	
	[self setStatus:string];
	
	[self.spinnerView stopAnimating];
    
	self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

- (void)dismiss {
	
    if(self.showNetworkIndicator) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.showNetworkIndicator = NO;
    }
    
	[UIView animateWithDuration:0.15
						  delay:0
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{	
						 sharedView.hudView.transform = CGAffineTransformScale(sharedView.hudView.transform, 0.8, 0.8);
						 sharedView.alpha = 0;
					 }
					 completion:^(BOOL finished){ 
                         if(sharedView.alpha == 0) {
                             [[NSNotificationCenter defaultCenter] removeObserver:sharedView];
                             [overlayWindow release], overlayWindow = nil;
                             [sharedView release], sharedView = nil;
                             
                             // find the frontmost window that is an actual UIWindow and make it keyVisible
                             [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                 if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                     [window makeKeyWindow];
                                     *stop = YES;
                                 }
                             }];
                             
                             // uncomment to make sure UIWindow is gone from app.windows
                             //NSLog(@"%@", [UIApplication sharedApplication].windows);
                             //NSLog(@"keyWindow = %@", [UIApplication sharedApplication].keyWindow);
                         }
                     }];
}

#pragma mark - Utilities

+ (BOOL)isVisible {
    return (sharedView.alpha == 1);
}


#pragma mark - Getters

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
    }
    return overlayWindow;
}

- (UIView *)hudView {
    if(!hudView) {
        hudView = [[UIView alloc] initWithFrame:CGRectZero];
        hudView.layer.cornerRadius = 10;
		hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8]; //comment htis if u want to change color
        hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:hudView];
    }
    return hudView;
}

- (UILabel *)stringLabel {
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = YES;
		stringLabel.textAlignment = UITextAlignmentLeft;//UITextAlignmentCenter;
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		stringLabel.font = [UIFont boldSystemFontOfSize:16];
		stringLabel.shadowColor = [UIColor blackColor];
		stringLabel.shadowOffset = CGSizeMake(0, -1);
        stringLabel.numberOfLines = 0;
		[self.hudView addSubview:stringLabel];
    }
    return stringLabel;
}

- (UIImageView *)imageView {
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
		[self.hudView addSubview:imageView];
    }
    return imageView;
}

- (UIActivityIndicatorView *)spinnerView {
    if (spinnerView == nil) {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		spinnerView.hidesWhenStopped = YES;
		spinnerView.bounds = CGRectMake(0, 0, 30, 30); //37,37
		[self.hudView addSubview:spinnerView];
    }
    return spinnerView;
}

- (CGFloat)visibleKeyboardHeight {
    
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    // Locate UIKeyboard.  
    UIView *foundKeyboard = nil;
    for (UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:0];
        }                                                                                
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
            foundKeyboard = possibleKeyboard;
            break;
        }
    }
    
    [autoreleasePool release];
    
    if(foundKeyboard && foundKeyboard.bounds.size.height > 100)
        return foundKeyboard.bounds.size.height;
    
    return 0;
}


@end
