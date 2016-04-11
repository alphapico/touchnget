//
//  PSBeritaController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/21/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSBeritaController.h"
#import "PSBeritaRSSController.h"
#import "PSCommonCode.h"
#import "PSAppDelegate.h"
#import "PSBeritaCell.h"

@interface PSBeritaController ()


@end

@implementation PSBeritaController

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize beritaRSSController = _beritaRSSController;

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
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInt:1] forKey:@"selectedIndex"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchSubMenuData
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"Berita Harakah", @"Harakah News", @"PAS Pusat", @"Ulamak Pusat", @"Pemuda Pusat", @"Muslimat Pusat", @"Mursyidul Am", @"Presiden PAS", @"Ketua Penerangan", @"Rakan Pakatan", @"Negeri Pakatan", @"Media Alternatif", @"Akhbar Nasional", @"Dunia Islam", @"Antarabangsa", @"Malaysiakini", nil];
    
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"beritaharakah2.png", @"harakahnews.png", @"paspusat.png", @"dupp2.png", @"dppp.png", @"dmpp2.png", @"mursyidul_am.png", @"presiden.png", @"ketuapenerangan.png", @"rakanpr.png", @"negeripr.png", @"alternatif.png", @"akhbarnasional.png", @"duniaislam.png", @"antarabangsa.png", @"malaysiakini.png", nil];
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        //PSSubMenuClass *subMenu = [[PSSubMenuClass alloc] initWithTitle:[titleArray objectAtIndex:i]];
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
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subMenuIdentifier"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subMenuIdentifier"];
//    }
    
    PSBeritaCell *cell = (PSBeritaCell *)[tableView dequeueReusableCellWithIdentifier:@"beritaCellIdentifier"];
    if (cell == nil) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSBeritaCell" owner:nil options:nil];
        cell = (PSBeritaCell *)[views objectAtIndex:0];
    }
    
    PSSubMenuClass *subMenu = [_dataSource objectAtIndex:indexPath.row];
    [cell.title setText:subMenu.title];
    [cell.imgView setImage:[UIImage imageNamed:subMenu.imageName]];
    
//    if ([self.lineViewCell superview]) {
//        [self.lineViewCell removeFromSuperview];
//    }
    
    UIView *lineViewCell = [[[UIView alloc] initWithFrame:CGRectMake(10, 62, /*cell.contentView.bounds.size.width*/ 295, 1)] autorelease];
    lineViewCell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    //_lineViewCell.autoresizingMask = 0x3f;
    [cell.contentView addSubview:lineViewCell];
    
    //[cell.textLabel setText:subMenu.title];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.beritaRSSController = [[[PSBeritaRSSController alloc] initWithNibName:@"PSBeritaRSSController" bundle:nil] autorelease];
    PSSubMenuClass *subMenu = [_dataSource objectAtIndex:indexPath.row];
    
    NSString *choosenURLStr = nil;
    if ([subMenu.title isEqualToString:@"Berita Harakah"]) {
        choosenURLStr = @"http://bm.harakahdaily.net/index.php/component/ninjarsssyndicator/?feed_id=1&format=raw";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if ([subMenu.title isEqualToString:@"Harakah News"]){
        choosenURLStr = @"http://en.harakahdaily.net/index.php?option=com_ninjarsssyndicator&feed_id=1&format=raw";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if ([subMenu.title isEqualToString:@"PAS Pusat"]){
        choosenURLStr = @"http://www.pas.org.my/v2/index.php?format=feed&type=rss";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if ([subMenu.title isEqualToString:@"Ulamak Pusat"]){
        choosenURLStr = @"http://ulamak.pas.org.my/v2/index.php?format=feed&type=rss%22";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if ([subMenu.title isEqualToString:@"Pemuda Pusat"]){
        choosenURLStr = @"http://pemuda.pas.org.my/index.php?format=feed&type=rss%22";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if ([subMenu.title isEqualToString:@"Muslimat Pusat"]){
        choosenURLStr = @"http://muslimat.pas.org.my/v2/index.php?format=feed&type=rss%22";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if ([subMenu.title isEqualToString:@"Mursyidul Am"]){
        choosenURLStr = @"http://www.pas.org.my/v2/index.php/artikel/mursyidul-am/index.php?format=feed&type=rss%22";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if ([subMenu.title isEqualToString:@"Presiden PAS"]){
        choosenURLStr = @"http://presiden.pas.org.my/v2/index.php?format=feed&type=rss";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if ([subMenu.title isEqualToString:@"Ketua Penerangan"]){
        choosenURLStr = @"http://www.pas.org.my/v2/index.php/artikel/ketua-penerangan/?format=feed&type=rss";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if([subMenu.title isEqualToString:@"Ketua Penerangan"]){
        choosenURLStr = @"http://utama.pas.org.my/index.php/artikel/lain-lain-kenyataan/index.php?format=feed&type=rss";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }else if ([subMenu.title isEqualToString:@"Rakan Pakatan"]){
        choosenURLStr = @"http://output91.rssinclude.com/output?type=direct&id=586516&hash=63c53910f5346f3c49e3772fb17c632f";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSInclude];
    }else if([subMenu.title isEqualToString:@"Negeri Pakatan"]){
        choosenURLStr = @"http://output20.rssinclude.com/output?type=direct&id=587051&hash=a9e7662db8b130e6ed6a6d4b50ae1961";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSInclude];
    }else if ([subMenu.title isEqualToString:@"Media Alternatif"]){
        choosenURLStr = @"http://output60.rssinclude.com/output?type=direct&id=586476&hash=b59393e879a14da121e83ced75e534e0";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSInclude];
    }else if ([subMenu.title isEqualToString:@"Akhbar Nasional"]){
        choosenURLStr = @"http://output64.rssinclude.com/output?type=direct&id=586490&hash=0fc57a88fa1f0c3a419a1d96d6bc243a";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSInclude];
    }else if ([subMenu.title isEqualToString:@"Dunia Islam"]){
        choosenURLStr = @"http://output37.rssinclude.com/output?type=direct&id=587056&hash=ea39a62b18b1e7a236915ffca069250d";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSInclude];
    }else if ([subMenu.title isEqualToString:@"Antarabangsa"]){
        choosenURLStr = @"http://output78.rssinclude.com/output?type=direct&id=587060&hash=b172499b5fc0946dcba866b3f8327252";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSInclude];
    }else if([subMenu.title isEqualToString:@"Malaysiakini"]){
        choosenURLStr = @"http://www.malaysiakini.com/my/news.rss";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSMalaysiakini];
    }
    else{
        choosenURLStr = @"http://webexamplenotexist.com";
        self.beritaRSSController.rssType = [NSNumber numberWithInt:RSSGeneral];
    }
    
    self.beritaRSSController.urlRSS = [NSURL URLWithString:choosenURLStr];
    self.beritaRSSController.title = subMenu.title;
    [self.navigationController pushViewController:_beritaRSSController animated:YES];
}


-(void)showMenuOfPaperFold:(id)sender
{
    [((PSAppDelegate *)[UIApplication sharedApplication].delegate) showMenuNavigation];
}

@end
