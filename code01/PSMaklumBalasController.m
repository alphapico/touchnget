//
//  PSMaklumBalasController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/24/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSMaklumBalasController.h"
#import "MHProgressHUD.h"
#import "PSAppDelegate.h"

@interface PSMaklumBalasController ()

@end

@implementation PSMaklumBalasController


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

    
    UIImageView *imgSendEmailView = [[[UIImageView alloc] initWithFrame:CGRectMake(95,50,131,121)] autorelease];
    imgSendEmailView.contentMode = UIViewContentModeScaleToFill;
    imgSendEmailView.image = [UIImage imageNamed:@"BackgroundSendEmail.png"];
    [self.view addSubview:imgSendEmailView];
    
    
    UIImage *imageCapped = [[UIImage imageNamed:@"BtnSendEmail.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:15.5];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    //[[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = [@"Maklum Balas" sizeWithFont:[UIFont boldSystemFontOfSize:12.0]].width + 24.0;
    buttonFrame.size.height = imageCapped.size.height;
    [button setFrame:CGRectMake( ( self.view.frame.size.width - buttonFrame.size.width)/2.0, 335, buttonFrame.size.width, buttonFrame.size.height)];
    [button setBackgroundImage:imageCapped forState:UIControlStateNormal];
    [button setTitle:@"Maklum Balas" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToMFMailComposeController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    //[self.imgEmailView setImage:[UIImage imageNamed:@"BackgroundSendEmail.png"]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInt:6] forKey:@"selectedIndex"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

-(void)goToMFMailComposeController:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:@"touchnget@pas.org.my"]];
        //[controller setBccRecipients: putSth];
        //[controller setCcRecipients: putSth];
        [controller setSubject:@"[iOS app]"];
        [controller.navigationBar setBarStyle:UIBarStyleBlack];
        
        if (controller) [self presentModalViewController:controller animated:YES];
        [controller release];
    }else{
        [MHProgressHUD showErrorWithStatus:@"Your email not configure" duration:2.0f];
    }
}

-(void)showMenuOfPaperFold:(id)sender
{
    [((PSAppDelegate *)[UIApplication sharedApplication].delegate) showMenuNavigation];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"Email send");
    }else if (result == MFMailComposeResultFailed){
        NSLog(@"Email failed");
    }else if (result == MFMailComposeResultCancelled){
        NSLog(@"Email cancel");
    }
    
    if (error) {
        NSLog(@"Error Email: %@", error.localizedDescription);
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
