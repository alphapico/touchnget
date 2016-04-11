//
//  PSFacebookWebController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/3/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSFacebookWebController.h"
#import "PSCommonCode.h"
#import "MHProgressHUD.h"

@interface PSFacebookWebController ()
@property (nonatomic, strong) IBOutlet UIImageView *bgWebView;
-(void)updateWebApperance;
-(void)addNoInternetView;
-(void)removeNoInternetView;
-(void)fadeOutBackgroundView;
-(void)fadeInBackgroundView;

@end

@implementation PSFacebookWebController

@synthesize webView;
@synthesize urlNews;
@synthesize bgWebView = _bgWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isProgressHUDDismiss = NO;
    }
    return self;
}

-(void)dealloc
{
    self.webView = nil;
    self.urlNews = nil;
    self.bgWebView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    //left bar btn item
    UIImage *imageCapped = [UIImage imageNamed:@"action-icon-back-white.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:imageCapped forState:UIControlStateNormal];
    [button setImage:imageCapped forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = imageCapped.size.width + 10; //setBackgroundImage will stretch, setImage OK
    buttonFrame.size.height = imageCapped.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(goToFacebookController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[[UIBarButtonItem alloc] initWithCustomView:button ] autorelease];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isProgressHUDDismiss = NO;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.urlNews];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Action

-(void)goToFacebookController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateWebApperance
{
    // page title
    NSString *pageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(pageTitle) [[self navigationItem] setTitle:pageTitle];
}

#pragma mark - User Experience

-(void)addNoInternetView
{
    //clean previous view if any
    [self removeNoInternetView];
    
    UIImageView *noInternetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SadFace.png"]];
    noInternetView.frame = CGRectMake( (self.view.frame.size.width - noInternetView.frame.size.width)/2.0 , (self.view.frame.size.height - noInternetView.frame.size.height)/2.0 - 20.0, noInternetView.frame.size.width, noInternetView.frame.size.height);
    noInternetView.tag = kTagNoInternetView;
    [self.view addSubview:noInternetView];
    [noInternetView release];
}

-(void)removeNoInternetView
{
    //clean previous view if any
    UIImageView *prevNoInternetView = (UIImageView *)[self.view viewWithTag:kTagNoInternetView];
    if (prevNoInternetView != nil) {
        [prevNoInternetView removeFromSuperview];
    }
}

-(void)fadeOutBackgroundView
{
    [UIView animateWithDuration:1.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^(void){
        self.bgWebView.alpha = 0.0;
    } completion:^(BOOL finished){
        
        [self removeNoInternetView];
        
    }];
}

//we only use this if internet fail
-(void)fadeInBackgroundView
{
    [UIView animateWithDuration:1.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^(void){
        self.bgWebView.alpha = 1.0;
    } completion:NULL];
}

#pragma mark - WebView Delegate


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (!isProgressHUDDismiss) {
        [MHProgressHUD showWithStatus:@"Loading" maskType:MHProgressHUDMaskTypeClear];
    }
    
    [self updateWebApperance];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MHProgressHUD dismiss];
    isProgressHUDDismiss = YES;
    
    [self.webView setUserInteractionEnabled:YES];
    [self updateWebApperance];
    
    if (self.bgWebView.alpha == 1.0) {
        //remove also no internet view after finished animation
        [self fadeOutBackgroundView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MHProgressHUD dismiss];
    
    NSLog(@"webView Error: %@", [error localizedDescription]);
    
    //http://stackoverflow.com/questions/1024748/how-do-i-fix-nsurlerrordomain-error-999-in-iphone-3-0-os
    if ([error code] != NSURLErrorCancelled) {
        [self.webView setUserInteractionEnabled:NO];
        [[self navigationItem] setTitle:@"Facebook"];
        
        [self addNoInternetView];
        if (self.bgWebView.alpha == 0.0) {
            [self fadeInBackgroundView];
        }
    }
    
    
}

@end
