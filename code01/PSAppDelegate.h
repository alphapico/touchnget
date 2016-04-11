//
//  PSAppDelegate.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 2/12/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSPaperMenuController.h"

@class PSHomeViewController;
@class PSMenuViewController;
@class PSPaperMenuController;
@class PSBeritaController;
@class PSKenaliPasController;
@class PSAktivitiController;
@class PSFacebookController;
@class PSTwitterController;
@class PSExtraController;
@class PSWebTVController;
@class PSMaklumBalasController;
@class PSTouchNGetController;

@interface PSAppDelegate : UIResponder <UIApplicationDelegate, PaperFoldMenuControllerDelegate>{

}

@property (strong, nonatomic) PSTouchNGetController *touchGetController;
@property (strong, nonatomic) UINavigationController *navTouchGetController;
@property (strong, nonatomic) PSHomeViewController *homeController;
//@property (strong, nonatomic) PSMenuViewController *menuController;
@property (strong, nonatomic) PSPaperMenuController *menuController;
@property (strong, nonatomic) PSBeritaController *beritaController;
@property (strong, nonatomic) UINavigationController *navBeritaController;
@property (strong, nonatomic) PSKenaliPasController *kenaliPasController;
@property (strong, nonatomic) UINavigationController *navKenaliPasController;
@property (strong, nonatomic) PSAktivitiController *aktivitiController;
@property (strong, nonatomic) UINavigationController *navAktivitiController;
@property (strong, nonatomic) PSFacebookController *facebookController;
@property (strong, nonatomic) UINavigationController *navFacebookController;
@property (strong, nonatomic) PSTwitterController *twitterController;
@property (strong, nonatomic) UINavigationController *navTwitterController;
@property (strong, nonatomic) PSWebTVController *webTvController;
@property (strong, nonatomic) UINavigationController *navWebTvController;
@property (strong, nonatomic) PSMaklumBalasController *mailController;
@property (strong, nonatomic) UINavigationController *navMailController;
//@property (strong, nonatomic) PSExtraController *extraController;
//@property (strong, nonatomic) UINavigationController *navExtraController;

@property (strong, nonatomic) UIImageView *launchImageView;
@property (readwrite, nonatomic) BOOL isNavigationMenuShowed;
@property (strong, nonatomic) UIWindow *window;

-(void)showMenuNavigation;
-(BOOL)isFirstTimeUsingApp;
-(BOOL)isFirstTimeUsingAppAndSet;
-(void)hideGuidedApp;

@end
