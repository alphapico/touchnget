//
//  PSKenaliPasController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/27/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSKenaliPasController.h"
#import "PSCommonCode.h"
#import "PSKenaliPasWebController.h"
#import "PSVideoController.h"
#import "PSKenaliPasSubMenuController.h"
#import "PSAppDelegate.h"
#import "PSKenaliPasCell.h"

@interface PSKenaliPasController ()

@end

@implementation PSKenaliPasController

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize kenaliPasWebController = _kenaliPasWebController;
@synthesize videoController = _videoController;
@synthesize subMenuController = _subMenuController;

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
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInt:2] forKey:@"selectedIndex"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchSubMenuData
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"Sejarah", @"Misi & Visi", @"Perlembagaan", @"Pimpinan", @"Keahlian", @"Lagu Rasmi", @"Hubungi Kami", @"Pejabat Negeri", @"Direktori Kawasan", nil];
    //NSArray *imageNameArray =
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        PSSubMenuClass *subMenu = [[PSSubMenuClass alloc] initWithTitle:[titleArray objectAtIndex:i]];
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
    
    PSKenaliPasCell *cell = (PSKenaliPasCell *)[tableView dequeueReusableCellWithIdentifier:@"kenaliPASCellIdentifier"];
    if (cell == nil) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSKenaliPasCell" owner:nil options:nil];
        cell = (PSKenaliPasCell *)[views objectAtIndex:0];
    }
    
    PSSubMenuClass *subMenu = [_dataSource objectAtIndex:indexPath.row];
    [cell.title setText:subMenu.title];
    
    UIView *lineViewCell = [[[UIView alloc] initWithFrame:CGRectMake(10, 62, 295, 1)] autorelease];
    lineViewCell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    [cell.contentView addSubview:lineViewCell];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.kenaliPasWebController = [[[PSKenaliPasWebController alloc] init] autorelease];
    PSSubMenuClass *subMenu = [_dataSource objectAtIndex:indexPath.row];
    
    BOOL isUseOtherController = NO;
    NSString *choosenURLStr = nil;
    if ([subMenu.title isEqualToString:@"Sejarah"]) {
        choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&View=article&id=1092&Itemid=679&device=xhtml";
        self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
    }else if ([subMenu.title isEqualToString:@"Misi & Visi"]){
        choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&View=article&id=1091&Itemid=680&device=xhtml";
        self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
    }else if ([subMenu.title isEqualToString:@"Perlembagaan"]){
        choosenURLStr = @"perlembagaan_pas";
        self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromFile];
    }else if ([subMenu.title isEqualToString:@"Pimpinan"]){
        isUseOtherController = YES;
        
        self.subMenuController = [[[PSKenaliPasSubMenuController alloc] init] autorelease];
        self.subMenuController.subTitle = subMenu.title;
        self.subMenuController.title = subMenu.title;
        [self.navigationController pushViewController:_subMenuController animated:YES];
        
    }else if ([subMenu.title isEqualToString:@"Keahlian"]){
        choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=183&Itemid=429";
        self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
    }else if ([subMenu.title isEqualToString:@"Lagu Rasmi"]){
        
        isUseOtherController = YES;
        
        self.videoController = [[[PSVideoController alloc] init] autorelease];
        self.videoController.videoURLStr = @"http://www.youtube.com/watch?v=56RxNYymmpw";
        self.videoController.title = subMenu.title;
        [self.navigationController pushViewController:_videoController animated:YES];
                
    }else if ([subMenu.title isEqualToString:@"Hubungi Kami"]){
        
        choosenURLStr = @"http://www.pas.org.my/index.php?option=com_contact&View=category&catid=12&Itemid=464";
        self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
    }else if ([subMenu.title isEqualToString:@"Pejabat Negeri"]){
        choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&View=article&id=182&Itemid=455";
        self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
    }else if ([subMenu.title isEqualToString:@"Direktori Kawasan"]){
        
        isUseOtherController = YES;
        
        self.subMenuController = [[[PSKenaliPasSubMenuController alloc] init] autorelease];
        self.subMenuController.subTitle = subMenu.title;
        self.subMenuController.title = subMenu.title;
        [self.navigationController pushViewController:_subMenuController animated:YES];
    }
    else{
        choosenURLStr = @"http://webexamplenotexist.com";
        self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
    }
    
    if (!isUseOtherController) {
        self.kenaliPasWebController.title = subMenu.title;
        self.kenaliPasWebController.urlWebStr = choosenURLStr;
        [self.navigationController pushViewController:_kenaliPasWebController animated:YES];
    }
    
}

#pragma mark - Action

-(void)showMenuOfPaperFold:(id)sender
{
    [((PSAppDelegate *)[UIApplication sharedApplication].delegate) showMenuNavigation];
}

@end
