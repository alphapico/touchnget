//
//  PSTwitterController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/3/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSTwitterController.h"
#import "PSCommonCode.h"
#import "PSTwitterWebController.h"
#import "PSAppDelegate.h"
#import "PSBeritaCell.h"

@interface PSTwitterController ()

@end

@implementation PSTwitterController

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize webController = _webController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [[[NSMutableArray alloc] init] autorelease];
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
    
    [self fetchSubMenuData];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInt:5] forKey:@"selectedIndex"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchSubMenuData
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"Pas Pusat", /*@"Ulamak Pusat",*/ @"Pemuda Pusat", /*@"Muslimat Pusat",*/ @"Harakahdaily", @"Mursyidul Am",  @"Presiden PAS", @"Ketua Penerangan", nil];
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"tw_pas.png", /*@"tw_ulamak.png",*/ @"tw_pemuda.png", /*@"tw_muslimat.png",*/ @"tw_harakah.png", @"tw_mursyidul_am.png",  @"tw_presiden.png", @"tw_ketuapenerangan.png", nil];
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        PSSubMenuClass *subMenu = [[PSSubMenuClass alloc] initWithTitle:[titleArray objectAtIndex:i] andImageName:[imageNameArray objectAtIndex:i]];
        [self.dataSource addObject:subMenu];
        [subMenu release];
    }
}

#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSBeritaCell *cell = (PSBeritaCell *)[tableView dequeueReusableCellWithIdentifier:@"twCellIdentifier"];
    if (cell == nil) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSBeritaCell" owner:nil options:nil];
        cell = (PSBeritaCell *)[views objectAtIndex:0];
    }
    
    PSSubMenuClass *subMenu = [_dataSource objectAtIndex:indexPath.row];
    [cell.title setText:subMenu.title];
    [cell.imgView setImage:[UIImage imageNamed:subMenu.imageName]];
    
    UIView *lineViewCell = [[[UIView alloc] initWithFrame:CGRectMake(10, 62, 295, 1)] autorelease];
    lineViewCell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    [cell.contentView addSubview:lineViewCell];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.webController) {
        self.webController = [[[PSTwitterWebController alloc] init] autorelease];
    }
    
    PSSubMenuClass *subMenu = [_dataSource objectAtIndex:indexPath.row];
    
    NSString *choosenURLStr = nil;
    if ([subMenu.title isEqualToString:@"Pas Pusat"]) {
        choosenURLStr = @"https://mobile.twitter.com/PASPusat";
    }else if ([subMenu.title isEqualToString:@"Ulamak Pusat"]){
        choosenURLStr = @"https://m.facebook.com/pages/Dewan-Ulamak-PAS-Pusat/112140085517515";
    }else if ([subMenu.title isEqualToString:@"Pemuda Pusat"]){
        choosenURLStr = @"https://mobile.twitter.com/DPPMalaysia";
    }else if ([subMenu.title isEqualToString:@"Muslimat Pusat"]){
        choosenURLStr = @"https://m.facebook.com/pages/Dewan-Muslimat-PAS-Pusat-DMPP/179950305417081";
    }else if ([subMenu.title isEqualToString:@"Harakahdaily"]){
        choosenURLStr = @"https://mobile.twitter.com/hdaily09";
    }else if ([subMenu.title isEqualToString:@"Mursyidul Am"]){
        choosenURLStr = @"https://mobile.twitter.com/nikabdulaziz";
    }else if ([subMenu.title isEqualToString:@"Presiden PAS"]){
        choosenURLStr = @"https://mobile.twitter.com/abdulhadiawang";
    }else if ([subMenu.title isEqualToString:@"Ketua Penerangan"]){
        choosenURLStr = @"https://mobile.twitter.com/tuan_ibrahim";
    }else{
        choosenURLStr = @"https://mobile.twitter.com/PASPusat";
    }
    
    self.webController.urlNews = [NSURL URLWithString:choosenURLStr];
    self.webController.title = subMenu.title;
    [self.navigationController pushViewController:_webController animated:YES];
}

-(void)showMenuOfPaperFold:(id)sender
{
    [((PSAppDelegate *)[UIApplication sharedApplication].delegate) showMenuNavigation];
}

@end
