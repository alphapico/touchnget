//
//  PSAktivitiController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/29/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSAktivitiController.h"
#import "MHProgressHUD.h"
#import "PSWebClient.h"
#import "NSString+Helper.h"
#import "TFHpple.h"
#import "NSString+stripHtml.h"
#import "PSCommonCode.h"
#import "PSAktivitiCell.h"
#import "PSAktivitiWebController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PSAppDelegate.h"
//#import "UINavigationBar+dropshadow.h"

@interface PSAktivitiController ()

@property (nonatomic, strong) IBOutlet UIImageView *bgWebView;
-(void)addNoInternetView;
-(void)removeNoInternetView;
-(void)fadeOutBackgroundView;
-(void)fadeInBackgroundView;

@end

@implementation PSAktivitiController

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize bgWebView = _bgWebView;
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
    
    //[self.navigationController.navigationBar applyShadowStyle];
    
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
    
    
    UIImage *reloadImg = [UIImage imageNamed:@"reloadWhite.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:reloadImg forState:UIControlStateNormal];
    [button setImage:reloadImg forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = reloadImg.size.width + 8.0;
    buttonFrame.size.height = reloadImg.size.height + 6.0;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(reloadActivityPage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItemRight = [[[UIBarButtonItem alloc] initWithCustomView:button ] autorelease];
    [self.navigationItem setRightBarButtonItem:buttonItemRight];

    
    [_tableView setContentInset:UIEdgeInsetsMake(15, 0, 0, 0)]; //offset top cell
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView reloadData];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self requestRSSincludeType];
    });
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInt:3] forKey:@"selectedIndex"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestRSSincludeType
{
    [_dataSource removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:@"http://output11.rssinclude.com/output?type=direct&id=588670&hash=92a8cf0a515244dcda8b7da981abfeec"];
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    
    [MHProgressHUD showWithStatus:@"Loading" maskType:MHProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperation *operationHttp =
    [[PSWebClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MHProgressHUD dismiss];
         NSLog(@"Response StatusCode: %d", [(NSHTTPURLResponse *)[operation response] statusCode]);
         
         TFHpple *xmlParser = [TFHpple hppleWithHTMLData:responseObject];
         NSString *itemXpathQuery = @"//p[@class='rssincl-itemtitle']";
         NSArray *itemsNodes = [xmlParser searchWithXPathQuery:itemXpathQuery];
         
         for (TFHppleElement *element in itemsNodes) {
             
             PSRSSClass *rssClass = [[PSRSSClass alloc] init];
             
             for (TFHppleElement *childElement in element.children) {
                 
                 if (![childElement.tagName isEqualToString:@"text"]) {
                     
                     //http://stackoverflow.com/questions/3200521/cocoa-trim-all-leading-whitespace-from-nsstring
                     //And if you want to trim the trailing whitespaces only you can use @"\\s*$" instead.
                     NSRange range = [[[childElement firstChild] content] rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
                     NSString *result = [[[[childElement firstChild] content] stringByReplacingCharactersInRange:range withString:@""] stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
                     
                     rssClass.title = result;
                     rssClass.link = [childElement objectForKey:@"href"];
                     
                     //NSLog(@"%@", childElement.tagName);
                     //NSLog(@"Title: %@", result);
                     //NSLog(@"Link: %@", [childElement objectForKey:@"href"]);
                     //NSLog(@"%@", element);
                 }
             }
             
             [self.dataSource addObject:rssClass];
             [rssClass release];
         }
         
         NSString *authorXpathQuery = @"//div[@class='rssincl-itemdesc']"; //rssincl-itemfeedtitle
         NSArray *authorNodes = [xmlParser searchWithXPathQuery:authorXpathQuery];
         int idx = 0;
         for (TFHppleElement *element in authorNodes) {
             
             if (idx <= [self.dataSource count] - 1) {
                 PSRSSClass *rssClass = (PSRSSClass *)[self.dataSource objectAtIndex:idx];
                 idx++;
                 
                 if (![element.tagName isEqualToString:@"text"])
                 {
                     NSString *noNewLineResult = [[[[element firstChild] content] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                     
                     NSRange range = [noNewLineResult rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
                     NSString *result = [[noNewLineResult stringByReplacingCharactersInRange:range withString:@""] stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
                     
                     rssClass.author = result;
                     
                     //NSLog(@"Author: %@", result);
                 }
             
             }
             
         }
         
         
         NSString *dateXpathQuery = @"//p[@class='rssincl-itemdate']";
         NSArray *dateNodes = [xmlParser searchWithXPathQuery:dateXpathQuery];
         int idy = 0;
         for (TFHppleElement *element in dateNodes) {
             
             if (idy <= [self.dataSource count] - 1) {
                 PSRSSClass *rssClass = (PSRSSClass *)[self.dataSource objectAtIndex:idy];
                 idy++;
                 
                 if (![element.tagName isEqualToString:@"text"])
                 {
                     NSRange range = [[[element firstChild] content] rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
                     NSString *result = [[[[element firstChild] content] stringByReplacingCharactersInRange:range withString:@""] stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
                     
                     rssClass.pubDate = result;
                     
                     //NSLog(@"pubDate: %@", result);
                 }
             }
             
         }
         
         NSString *picXpathQuery = @"//div[@class='rssincl-itemimage']";
         NSArray *picNodes = [xmlParser searchWithXPathQuery:picXpathQuery];
         int idz = 0;
         for (TFHppleElement *element in picNodes) {
             
             if (idz <= [self.dataSource count] - 1) {
                 PSRSSClass *rssClass = (PSRSSClass *)[self.dataSource objectAtIndex:idz];
                 idz++;

                 for (TFHppleElement *childElement in element.children)
                 {
                     
                     for (TFHppleElement *grandChildElement in childElement.children)
                     {
                         if (![grandChildElement.tagName isEqualToString:@"text"])
                         {
                             NSLog(@"image URL: %@", [grandChildElement objectForKey:@"src"] );
                             rssClass.imageURL = [[grandChildElement objectForKey:@"src"]  stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
                         }
                         
                     }

                 }
             }
             
         }
         
         if ([_dataSource count] > 0)
         {
             
             if (self.bgWebView.alpha == 1.0) {
                 //remove also no internet view after finished animation
                 [self fadeOutBackgroundView];
             }
             
             [_tableView reloadData];
         }
         else //if no data
         {
             [self addNoInternetView];
             if (self.bgWebView.alpha == 0.0) {
                 [self fadeInBackgroundView];
             }
         }
         
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MHProgressHUD dismiss];
         
         [self addNoInternetView];
         if (self.bgWebView.alpha == 0.0) {
             [self fadeInBackgroundView];
         }
         
         NSLog(@"Response StatusCode: %d", [(NSHTTPURLResponse *)[operation response] statusCode]);
         NSLog(@"Operation Error: %@", error.localizedDescription);
     }];
    
    [[PSWebClient sharedClient] enqueueHTTPRequestOperation:operationHttp];
}

#pragma mark - TableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
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
    PSAktivitiCell *cell = (PSAktivitiCell *)[tableView dequeueReusableCellWithIdentifier:@"rssIdentifier"];
    if (cell == nil) {
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSAktivitiCell" owner:nil options:nil];
        cell = (PSAktivitiCell *)[views objectAtIndex:0];
        
    }
    
    PSRSSClass *rssClass = (PSRSSClass *)[_dataSource objectAtIndex:indexPath.row];
    cell.title.lineBreakMode = UILineBreakModeWordWrap;
    cell.title.numberOfLines = 0;
    cell.title.text = rssClass.title;
    
    cell.publishedDate.lineBreakMode = UILineBreakModeWordWrap;
    cell.publishedDate.numberOfLines = 0;
    
    cell.publishedDate.text = [NSString stringWithFormat:@"%@", rssClass.author];
    if ([rssClass.author length] == 0) {
        cell.publishedDate.text = @"Sumber:  Admin";
    }
    [cell.imgView setImageWithURL:[NSURL URLWithString:rssClass.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
        
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.webController = [[[PSAktivitiWebController alloc] initWithNibName:@"PSAktivitiWebController" bundle:nil] autorelease];
    PSRSSClass *rssClass = (PSRSSClass *)[_dataSource objectAtIndex:indexPath.row];
    self.webController.urlNews = rssClass.link;
    [self.navigationController pushViewController:_webController animated:YES];
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

#pragma mark - Action

-(void)showMenuOfPaperFold:(id)sender
{
    [((PSAppDelegate *)[UIApplication sharedApplication].delegate) showMenuNavigation];
}

-(void)reloadActivityPage:(id)sender
{
    [self requestRSSincludeType];
}

@end
