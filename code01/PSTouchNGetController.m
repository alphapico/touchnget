//
//  PSTouchNGetController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/29/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSTouchNGetController.h"
#import "PSAppDelegate.h"

@interface PSTouchNGetController ()

@end

@implementation PSTouchNGetController

@synthesize pasLabel = _pasLabel;
@synthesize starterBackgroundView = _starterBackgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *navMenuImg = [UIImage imageNamed:@"menuNavigation.png"];
    UIButton *buttonNavMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonNavMenu setImage:navMenuImg forState:UIControlStateNormal];
    [buttonNavMenu setImage:navMenuImg forState:UIControlStateHighlighted];
    CGRect buttonNavMenuFrame = [buttonNavMenu frame];
    buttonNavMenuFrame.size.width = navMenuImg.size.width + 20;
    buttonNavMenuFrame.size.height = navMenuImg.size.height;
    [buttonNavMenu setFrame:buttonNavMenuFrame];
    //[button setBackgroundImage:imageCapped forState:UIControlStateNormal];
    [buttonNavMenu addTarget:self action:@selector(showMenuOfPaperFold:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[[UIBarButtonItem alloc] initWithCustomView:buttonNavMenu ] autorelease];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
    UIImageView *imgTouchGetView = [[[UIImageView alloc] initWithFrame:CGRectMake(60,70,188,121)] autorelease];
    imgTouchGetView.contentMode = UIViewContentModeScaleToFill;
    imgTouchGetView.image = [UIImage imageNamed:@"uiPASTouchNGet.png"];
    [self.view addSubview:imgTouchGetView];
    
    UIImageView *imgKhatPasView = [[[UIImageView alloc] initWithFrame:CGRectMake(30,313,260,37)] autorelease];
    imgKhatPasView.contentMode = UIViewContentModeScaleToFill;
    imgKhatPasView.image = [UIImage imageNamed:@"uiKhatPAS.png"];
    [self.view addSubview:imgKhatPasView];
    
    if ([((PSAppDelegate *)[UIApplication sharedApplication].delegate) isFirstTimeUsingApp]) {
        
        self.starterBackgroundView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)] autorelease];
        [self.starterBackgroundView setImage:[UIImage imageNamed:@"BGIntroGuide.png"]];
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

        
        [self.starterBackgroundView addGestureRecognizer:tapRecognizer];
        
        [self.view addSubview:_starterBackgroundView];
        [self.view addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInt:0] forKey:@"selectedIndex"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

-(void)showMenuOfPaperFold:(id)sender
{
    [((PSAppDelegate *)[UIApplication sharedApplication].delegate) showMenuNavigation];
    
    if ([((PSAppDelegate *)[UIApplication sharedApplication].delegate) isFirstTimeUsingAppAndSet])
    {
        if ([self.starterBackgroundView superview] && (self.starterBackgroundView.alpha == 1.0)) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseOut animations:
             ^(void){
                 self.starterBackgroundView.alpha = 0.0f;
             } completion:^(BOOL finished){
                 
                 [self.starterBackgroundView removeFromSuperview];
                 
             }];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer
{    
    if ([((PSAppDelegate *)[UIApplication sharedApplication].delegate) isFirstTimeUsingAppAndSet])
    {
        if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            if ([self.starterBackgroundView superview] && (self.starterBackgroundView.alpha == 1.0)) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseOut animations:
                 ^(void){
                     self.starterBackgroundView.alpha = 0.0f;
                 } completion:^(BOOL finished){
                     
                     [self.starterBackgroundView removeFromSuperview];
                     
                 }];
            }
        }
    }
    
}

-(void)hideStarterBGView
{
    if ([((PSAppDelegate *)[UIApplication sharedApplication].delegate) isFirstTimeUsingAppAndSet])
    {
        if ([self.starterBackgroundView superview] && (self.starterBackgroundView.alpha == 1.0)) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseOut animations:
             ^(void){
                 self.starterBackgroundView.alpha = 0.0f;
             } completion:^(BOOL finished){
                 
                 [self.starterBackgroundView removeFromSuperview];
                 
             }];
        }
    }
    
    
}

@end
