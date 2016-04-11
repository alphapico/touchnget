//
//  MHProgressHUD.h
//  BondedWarehouse
//
//  Created by Muhamad Hisham Wahab on 12/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

enum {
    MHProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    MHProgressHUDMaskTypeClear, // don't allow
    MHProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    MHProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

typedef NSUInteger MHProgressHUDMaskType;

@interface MHProgressHUD : UIView

@property (nonatomic, readwrite) UIView *hudView; //readonly previously

+ (MHProgressHUD*)sharedView; //hisham added

+ (void)show;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(MHProgressHUDMaskType)maskType;
+ (void)showWithMaskType:(MHProgressHUDMaskType)maskType;

+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing

+ (void)dismiss; // simply dismiss the HUD with a fade+scale out animation
+ (void)dismissWithSuccess:(NSString*)successString; // also displays the success icon image
+ (void)dismissWithSuccess:(NSString*)successString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithError:(NSString*)errorString; // also displays the error icon image
+ (void)dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds;

+ (BOOL)isVisible;

// deprecated methods; it shouldn't be the HUD's responsability to show/hide the network activity indicator
+ (void)showWithStatus:(NSString*)status networkIndicator:(BOOL)show DEPRECATED_ATTRIBUTE;
+ (void)showWithStatus:(NSString*)status maskType:(MHProgressHUDMaskType)maskType networkIndicator:(BOOL)show DEPRECATED_ATTRIBUTE; 
+ (void)showWithMaskType:(MHProgressHUDMaskType)maskType networkIndicator:(BOOL)show DEPRECATED_ATTRIBUTE;

@end