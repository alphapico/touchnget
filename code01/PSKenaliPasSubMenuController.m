//
//  PSKenaliPasSubMenuController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/29/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSKenaliPasSubMenuController.h"
#import "PSCommonCode.h"
#import "PSKenaliPasWebController.h"
#import "PSVideoController.h"
#import "PSKenaliPasCell.h"

@interface PSKenaliPasSubMenuController ()

@end

@implementation PSKenaliPasSubMenuController

@synthesize subTitle = _subTitle;
@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize kenaliPasWebController = _kenaliPasWebController;
@synthesize videoController = _videoController;

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
    
    //left bar btn item
    UIImage *imageCapped = [UIImage imageNamed:@"action-icon-back-white.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:imageCapped forState:UIControlStateNormal];
    [button setImage:imageCapped forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = imageCapped.size.width + 10; //setBackgroundImage will stretch, setImage OK
    buttonFrame.size.height = imageCapped.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(gotoKenaliPasController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[[UIBarButtonItem alloc] initWithCustomView:button ] autorelease];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
    [self fetchSubMenuData];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchSubMenuData
{
    if ([_subTitle isEqualToString:@"Pimpinan"]) {
        NSArray *titleArray = [NSArray arrayWithObjects:@"AJK Kerja PAS Pusat", @"Pesuruhjaya PAS Negeri", @"Dewan Ulamak PAS Pusat", @"Dewan Pemuda PAS Pusat", @"Dewan Muslimat PAS Pusat", @"Pengerusi Lajnah PAS Pusat", @"Lajnah Politik & Pilihanraya", nil];
        
        //NSArray *imageNameArray =
        
        for (int i = 0; i < [titleArray count]; i++)
        {
            PSSubMenuClass *subMenu = [[PSSubMenuClass alloc] initWithTitle:[titleArray objectAtIndex:i]];
            [self.dataSource addObject:subMenu];
            [subMenu release];
        }
        
    }
    else if ([_subTitle isEqualToString:@"Direktori Kawasan"])
    {
        NSArray *titleArray = [NSArray arrayWithObjects:@"Johor" ,@"Kedah", @"Kelantan", @"Melaka" , @"Negeri Sembilan", @"Pahang" , @"Pulau Pinang", @"Perak", @"Perlis",@"Selangor",@"Terengganu",@"Sabah",@"Sarawak",@"Wilayah Persekutuan", nil];
        
        //NSArray *imageNameArray =
        
        for (int i = 0; i < [titleArray count]; i++)
        {
            PSSubMenuClass *subMenu = [[PSSubMenuClass alloc] initWithTitle:[titleArray objectAtIndex:i]];
            [self.dataSource addObject:subMenu];
            [subMenu release];
        }
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
    PSKenaliPasCell *cell = (PSKenaliPasCell *)[tableView dequeueReusableCellWithIdentifier:@"subMenuIdentifier"];
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
    
    NSString *choosenURLStr = nil;
    
    if ([_subTitle isEqualToString:@"Pimpinan"])
    {
        if ([subMenu.title isEqualToString:@"AJK Kerja PAS Pusat"]) {
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=252:senarai-pimpinan-pas-pusat-sesi-2011-2013&catid=60:organisasi-ajk-pusat-pusat&Itemid=472";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Pesuruhjaya PAS Negeri"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=304&Itemid=494";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Dewan Ulamak PAS Pusat"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=228:ajk-dewan-ulama-pas-pusat-sesi-2011-2013&catid=67:organisasi-dewan-ulama-pas-pusat&Itemid=473";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Dewan Pemuda PAS Pusat"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=227:ajk-dewan-pemuda-pas-pusat-sesi-2011-2013&catid=64:organisasi-dewan-pemuda-pas-pusat&Itemid=474";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Dewan Muslimat PAS Pusat"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=279:ajk-dewan-muslimat-pas-pusat-sesi-2011-2013&catid=62:organisasi-dewan-muslimat-pas-pusat&Itemid=475";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Pengerusi Lajnah PAS Pusat"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=305&Itemid=496";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Lajnah Politik & Pilihanraya"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=306&Itemid=495";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }
    }
    else if ([_subTitle isEqualToString:@"Direktori Kawasan"])
    {
        if ([subMenu.title isEqualToString:@"Johor"]) {
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&View=article&id=374:direktori-pas-kawasan-kawasan-johor-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Kedah"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=367:direktori-pas-kawasan-kawasan-kedah-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Kelantan"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=377:direktori-pas-kawasan-kawasan-kelantan-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Melaka"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=373:direktori-pas-kawasan-kawasan-melaka-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Negeri Sembilan"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=372:direktori-pas-kawasan-kawasan-negeri-sembilan-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Pahang"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=375:direktori-pas-kawasan-kawasan-pahang-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Pulau Pinang"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=368:direktori-pas-kawasan-kawasan-pulau-pinang-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Perak"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=369:direktori-pas-kawasan-kawasan-perak-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Perlis"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&View=article&id=366:direktori-pas-kawasan-kawasan-perlis-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Selangor"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=370:direktori-pas-kawasan-kawasan-selangor-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Terengganu"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=376:direktori-pas-kawasan-kawasan-terengganu-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Sabah"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=378:direktori-pas-kawasan-kawasan-sabah-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Sarawak"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=379:direktori-pas-kawasan-kawasan-sarawak-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }else if ([subMenu.title isEqualToString:@"Wilayah Persekutuan"]){
            choosenURLStr = @"http://www.pas.org.my/index.php?option=com_content&view=article&id=371:direktori-pas-kawasan-kawasan-wilayah-persekutuan-sesi-2011-2013&catid=73:direktori-kawasan-sesi-2011-2013&Itemid=433";
            self.kenaliPasWebController.webType = [NSNumber numberWithInt:WebFromServer];
        }
    }
    
    self.kenaliPasWebController.title = subMenu.title;
    self.kenaliPasWebController.urlWebStr = choosenURLStr;
    [self.navigationController pushViewController:_kenaliPasWebController animated:YES];
    
}

-(void)gotoKenaliPasController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
