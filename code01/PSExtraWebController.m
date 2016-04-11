//
//  PSExtraWebController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/4/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSExtraWebController.h"
#import "PSCommonCode.h"
#import "MHProgressHUD.h"

@interface PSExtraWebController ()
@property (nonatomic, strong) IBOutlet UIImageView *bgWebView;
-(void)updateWebApperance;
-(void)addNoInternetView;
-(void)removeNoInternetView;
-(void)fadeOutBackgroundView;
-(void)fadeInBackgroundView;
@end

@implementation PSExtraWebController

@synthesize webView;
@synthesize urlWebStr;
@synthesize bgWebView = _bgWebView;
@synthesize webType;

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
    self.urlWebStr = nil;
    self.bgWebView = nil;
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    //http://stackoverflow.com/questions/7754851/autoresizing-masks-programmatically-vs-interfact-builder-xib-nib
//    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ;
    
    //left bar btn item
    UIImage *imageCapped = [UIImage imageNamed:@"action-icon-back-white.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = imageCapped.size.width;
    buttonFrame.size.height = imageCapped.size.height;
    [button setFrame:buttonFrame];
    [button setBackgroundImage:imageCapped forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToExtraController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[[UIBarButtonItem alloc] initWithCustomView:button ] autorelease];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
    if ((WebType)[self.webType intValue] == (WebType)WebFromServer)
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlWebStr]];
        [self.webView loadRequest:request];
    }
    
    if ((WebType)[self.webType intValue] == (WebType)WebFromFile)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.urlWebStr ofType:@"html"] isDirectory:NO]];
        [self.webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

-(void)goToExtraController
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
        [[self navigationItem] setTitle:@"Harakah"];
        
        [self addNoInternetView];
        if (self.bgWebView.alpha == 0.0) {
            [self fadeInBackgroundView];
        }
    }
}



@end
