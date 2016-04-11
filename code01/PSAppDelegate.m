//
//  PSAppDelegate.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 2/12/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSAppDelegate.h"
#import "PSTouchNGetController.h"
#import "PSBeritaController.h"
#import "PSKenaliPasController.h"
#import "PSAktivitiController.h"
#import "PSFacebookController.h"
#import "PSTwitterController.h"
#import "PSWebTVController.h"
#import "PSExtraController.h"
#import "PSMaklumBalasController.h"

#import "UIDevice+Resolutions.h"

//TETS
#import "PSHomeViewController.h"
#import "PSMenuViewController.h"

@implementation PSAppDelegate

@synthesize homeController = _homeController;

@synthesize menuController = _menuController;
@synthesize beritaController = _beritaController;
@synthesize navBeritaController = _navBeritaController;
@synthesize kenaliPasController = _kenaliPasController;
@synthesize navKenaliPasController = _navKenaliPasController;
@synthesize aktivitiController = _aktivitiController;
@synthesize navAktivitiController = _navAktivitiController;
@synthesize facebookController = _facebookController;
@synthesize navFacebookController = _navFacebookController;
@synthesize twitterController = _twitterController;
@synthesize navTwitterController = _navTwitterController;
@synthesize webTvController = _webTvController;
@synthesize navWebTvController = _navWebTvController;
@synthesize mailController = _mailController;
@synthesize navMailController = _navMailController;
@synthesize touchGetController = _touchGetController;
@synthesize navTouchGetController = _navTouchGetController;
//@synthesize extraController = _extraController;
//@synthesize navExtraController = _navExtraController;
@synthesize launchImageView = _launchImageView;
@synthesize isNavigationMenuShowed;

- (void)dealloc
{
    self.launchImageView = nil;
    
    self.homeController = nil;
    self.menuController = nil;
    self.kenaliPasController = nil;
    self.navKenaliPasController = nil;
    self.beritaController = nil;
    self.navBeritaController = nil;
    self.aktivitiController = nil;
    self.navAktivitiController = nil;
    self.facebookController = nil;
    self.navFacebookController = nil;
    self.twitterController = nil;
    self.navTwitterController = nil;
    self.webTvController = nil;
    self.navWebTvController = nil;
    self.mailController = nil;
    self.navMailController = nil;
    self.touchGetController = nil;
    self.navTouchGetController = nil;
    //self.extraController = nil;
    //self.navExtraController = nil;
    
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    //self.homeController = [[[PSHomeViewController alloc] initWithNibName:@"PSHomeViewController" bundle:nil] autorelease];
    //self.menuController = [[[PSMenuViewController alloc] initWithNibName:@"PSMenuViewController" bundle:nil] autorelease];
    
    self.menuController = [[[PSPaperMenuController alloc] initWithMenuWidth:250.0 numberOfFolds:3] autorelease];
    self.menuController.delegate = self;
    
//    if (![self isFirstTimeUsingApp]) {
//        self.menuController.selectedIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] unsignedIntValue];
//    }
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    self.touchGetController = [[[PSTouchNGetController alloc] init] autorelease];
    self.touchGetController.title = @"TouchNGet";
    self.navTouchGetController = [[[UINavigationController alloc] initWithRootViewController:_touchGetController] autorelease];
    [self.navTouchGetController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarGreen"] forBarMetrics:UIBarMetricsDefault];
    
    self.beritaController = [[[PSBeritaController alloc] init] autorelease];
    self.beritaController.title = @"Berita";
    self.navBeritaController = [[[UINavigationController alloc] initWithRootViewController:_beritaController] autorelease];
    [self.navBeritaController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarGreen"] forBarMetrics:UIBarMetricsDefault];
    
    self.kenaliPasController = [[[PSKenaliPasController alloc] init] autorelease];
    self.kenaliPasController.title = @"Kenali PAS";
    self.navKenaliPasController = [[[UINavigationController alloc] initWithRootViewController:_kenaliPasController] autorelease];
    [self.navKenaliPasController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarGreen"] forBarMetrics:UIBarMetricsDefault];
    
    self.aktivitiController = [[[PSAktivitiController alloc] init] autorelease];
    self.aktivitiController.title = @"Aktiviti";
    self.navAktivitiController = [[[UINavigationController alloc] initWithRootViewController:_aktivitiController] autorelease];
    [self.navAktivitiController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarGreen"] forBarMetrics:UIBarMetricsDefault];
    
    self.facebookController = [[[PSFacebookController alloc] init] autorelease];
    self.facebookController.title = @"Facebook";
    self.navFacebookController = [[[UINavigationController alloc] initWithRootViewController:_facebookController] autorelease];
    [self.navFacebookController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarGreen"] forBarMetrics:UIBarMetricsDefault];
    
    self.twitterController = [[[PSTwitterController alloc] init] autorelease];
    self.twitterController.title = @"Twitter";
    self.navTwitterController = [[[UINavigationController alloc] initWithRootViewController:_twitterController] autorelease];
    [self.navTwitterController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarGreen"] forBarMetrics:UIBarMetricsDefault];
    
    self.webTvController = [[[PSWebTVController alloc] init] autorelease];
    self.webTvController.title = @"Web TV";
    self.navWebTvController = [[[UINavigationController alloc] initWithRootViewController:_webTvController] autorelease];
    [self.navWebTvController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarGreen"] forBarMetrics:UIBarMetricsDefault];
    
    self.mailController = [[[PSMaklumBalasController alloc] init] autorelease];
    self.mailController.title = @"Maklum Balas";
    self.navMailController = [[[UINavigationController alloc] initWithRootViewController:_mailController] autorelease];
    [self.navMailController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarGreen"] forBarMetrics:UIBarMetricsDefault];
    
//    self.extraController = [[[PSExtraController alloc] init] autorelease];
//    self.extraController.title = @"Extra";
//    self.navExtraController = [[[UINavigationController alloc] initWithRootViewController:_extraController] autorelease];
//    [self.navExtraController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarGreen"] forBarMetrics:UIBarMetricsDefault];

    
    [viewControllers addObject:_navTouchGetController];
    [viewControllers addObject:_navBeritaController];
    [viewControllers addObject:_navKenaliPasController];
    [viewControllers addObject:_navAktivitiController];
    [viewControllers addObject:_navFacebookController];
    [viewControllers addObject:_navTwitterController];
    [viewControllers addObject:_navWebTvController];
    [viewControllers addObject:_navMailController];
    //[viewControllers addObject:_navExtraController];
    
    [self.menuController setViewControllers:viewControllers];
    
    self.window.rootViewController = _menuController;
    
    
    if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina35) {
        self.launchImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, 320, 480)] autorelease];
        [self.launchImageView setImage:[UIImage imageNamed:@"HomeBackground.png"]];
        self.launchImageView.contentMode = UIViewContentModeScaleToFill;
        [self.window.rootViewController.view addSubview:_launchImageView];
    }else{
        self.launchImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, 320, 568)] autorelease];
        [self.launchImageView setImage:[UIImage imageNamed:@"HomeBackground-568h.png"]];
        self.launchImageView.contentMode = UIViewContentModeScaleToFill;
        [self.window.rootViewController.view addSubview:_launchImageView];
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fadeLaunchImage];
    });
    
    [self.window makeKeyAndVisible];
    return YES;
}

//show/hide navigation menu
-(void)showMenuNavigation
{
    [self.menuController showNavigationMenu];
}

-(void)fadeLaunchImage
{
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationCurveEaseOut animations:
     ^(void){
         self.launchImageView.alpha = 0.0f;
     } completion:^(BOOL finished){
         if ([self.launchImageView superview]) {
             [self.launchImageView removeFromSuperview];
         }
     }];
}

-(BOOL)isFirstTimeUsingApp
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
        return YES;
    }else {
        return NO;
    }
}

-(BOOL)isFirstTimeUsingAppAndSet
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"FirstRunNoMore" forKey:@"FirstRun"];
        return YES;
    }else {
        return NO;
    }
}

-(void)hideGuidedApp
{
    [self.touchGetController hideStarterBGView];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
