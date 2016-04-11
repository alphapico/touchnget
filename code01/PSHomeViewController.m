//
//  PSHomeViewController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 2/13/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSHomeViewController.h"


@interface PSHomeViewController ()

@end


@implementation PSHomeViewController

@synthesize bgView = _bgView;

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
    
    self.bgView.image = [UIImage imageNamed:@"HomeBackground.png"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.bgView.image = [UIImage imageNamed:@"HomeBackground.png"];
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.bgView.image = [UIImage imageNamed:@"HomeBackground-Rotate.png"];
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.bgView.image = [UIImage imageNamed:@"HomeBackground-Rotate.png"];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}





@end
