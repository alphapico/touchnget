//
//  PSVideoController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/28/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSVideoController.h"

@interface PSVideoController ()

@end

@implementation PSVideoController

@synthesize youtubeController = _youtubeController;
@synthesize videoURLStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.youtubeController.delegate = nil;
    self.videoURLStr = nil;
    self.youtubeController = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //left bar btn item
    UIImage *imageCapped = [UIImage imageNamed:@"action-icon-back-white.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:imageCapped forState:UIControlStateNormal];
    [button setImage:imageCapped forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = imageCapped.size.width + 10; //setBackgroundImage will stretch, setImage OK
    buttonFrame.size.height = imageCapped.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(gotoPreviousController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[[UIBarButtonItem alloc] initWithCustomView:button ] autorelease];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
    LBYouTubeExtractor *extractor = [[LBYouTubeExtractor alloc] initWithURL:[NSURL URLWithString:self.videoURLStr] quality:LBYouTubeVideoQualityLarge];
    
    [extractor extractVideoURLWithCompletionBlock:^(NSURL *videoURL, NSError *error) {
        if(!error) {
            NSLog(@"Did extract video URL using completion block: %@", videoURL);
        } else {
            NSLog(@"Failed extracting video URL using block due to error:%@", error);
        }
    }];
    
    self.youtubeController = [[LBYouTubePlayerController alloc] initWithYouTubeURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=56RxNYymmpw"] quality:LBYouTubeVideoQualityLarge];
    self.youtubeController.delegate = self;
    self.youtubeController.view.frame = CGRectMake(10.0f, 20.0f, 300.0f, 200.0f);
    //self.controller.view.center = self.view.center;
    [self.view addSubview:self.youtubeController.view];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark LBYouTubePlayerViewControllerDelegate

-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    NSLog(@"Did extract video source:%@", videoURL);
}

-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller failedExtractingYouTubeURLWithError:(NSError *)error
{
    NSLog(@"Failed loading video due to error:%@", error);
}

-(void)gotoPreviousController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
