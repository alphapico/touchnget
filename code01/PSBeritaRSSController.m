//
//  PSBeritaRSSController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/22/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSBeritaRSSController.h"
#import "PSWebClient.h"
#import "PSCommonCode.h"
#import "TFHpple.h"
#import "NSString+stripHtml.h"
#import "PSRSSCell.h"
#import "HSTimeIntervalFormatter.h"
#import "PSBeritaWebViewController.h"
#import "MHProgressHUD.h"
#import "NSString+Helper.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PSBeritaRSSController ()
@property (nonatomic, strong) IBOutlet UIImageView *bgWebView;
-(void)addNoInternetView;
-(void)removeNoInternetView;
-(void)fadeOutBackgroundView;
-(void)fadeInBackgroundView;
@end

@implementation PSBeritaRSSController

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize beritaWebController = _beritaWebController;
@synthesize bgWebView = _bgWebView;
@synthesize urlRSS;
@synthesize rssType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

-(void)dealloc
{
    self.beritaWebController = nil;
    
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
    [button addTarget:self action:@selector(goToBeritaController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[[UIBarButtonItem alloc] initWithCustomView:button ] autorelease];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
    [_tableView setContentInset:UIEdgeInsetsMake(15, 0, 0, 0)]; //offset top cell
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView reloadData];
    
    if ((RSSType)[self.rssType intValue] == (RSSType)RSSInclude)
    {
        [self requestRSSincludeType];
    }
    else
    {
        //RSSGeneral and RSSMalaysiakini
        [self requestRSSGeneralType];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestRSSincludeType
{
    [_dataSource removeAllObjects];
    
    NSURL *url = self.urlRSS;
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
                     //NSLog(@"%@", result);
                     //NSLog(@"%@", [childElement objectForKey:@"href"]);
                     //NSLog(@"%@", element);
                 }
             }
             
             [self.dataSource addObject:rssClass];
         }
         
         NSString *authorXpathQuery = @"//p[@class='rssincl-itemfeedtitle']";
         NSArray *authorNodes = [xmlParser searchWithXPathQuery:authorXpathQuery];
         int idx = 0;
         for (TFHppleElement *element in authorNodes) {
             
             if (idx <= [self.dataSource count] - 1) {
                 PSRSSClass *rssClass = (PSRSSClass *)[self.dataSource objectAtIndex:idx];
                 idx++;
                 
                 for (TFHppleElement *childElement in element.children)
                 {
                     if (![childElement.tagName isEqualToString:@"text"])
                     {
                         NSRange range = [[[childElement firstChild] content] rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
                         NSString *result = [[[[childElement firstChild] content] stringByReplacingCharactersInRange:range withString:@""] stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
                         
                         rssClass.author = result;
                         
                         //NSLog(@"%@", result);
                     }
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
                     
                     //NSLog(@"%@", result);
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
         else
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

-(void)requestRSSGeneralType
{
    NSURL *url = self.urlRSS;
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    
    [MHProgressHUD showWithStatus:@"Loading" maskType:MHProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperation *operationHttp =
    [[PSWebClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MHProgressHUD dismiss];
         NSLog(@"Response StatusCode: %d", [(NSHTTPURLResponse *)[operation response] statusCode]);
         
         //http://www.w3schools.com/xpath/xpath_syntax.asp
         //http://stackoverflow.com/questions/9746745/xpath-attributes-selection
         //http://stackoverflow.com/questions/6310773/nsstring-with-some-html-tags-how-can-i-search-for-img-tag-and-get-the-content
         
         //NSString *responseHTML = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
         
         TFHpple *xmlParser = [TFHpple hppleWithXMLData:responseObject];
         NSString *itemXpathQuery = @"//item";
         NSArray *itemsNodes = [xmlParser searchWithXPathQuery:itemXpathQuery];
         
         for (TFHppleElement *element in itemsNodes) {
             
             PSRSSClass *rssClass = [[PSRSSClass alloc] init];
             
             for (TFHppleElement *childElement in element.children) {
                 
                 if (![childElement.tagName isEqualToString:@"text"]) {
                     NSLog(@"%@", childElement.tagName);
                     
                     
                     if ([childElement.tagName isEqualToString:@"title"])
                     {
                         rssClass.title = [[childElement firstChild] content];
                     }
                     else if ([childElement.tagName isEqualToString:@"link"])
                     {
                         rssClass.link = [[childElement firstChild] content];
                     }
                     else if ([childElement.tagName isEqualToString:@"author"])
                     {
                         /*
                         NSString *rawAuthor = [[childElement firstChild] content];
                         NSString *author = [rawAuthor stringByReplacingOccurrencesOfString:@"(Harakahdaily)" withString:@""];
                         NSLog(@"<Author> : %@", author);
                         rssClass.author = author;
                         */
                         
                         NSString *author = nil;
                         
                         if ((RSSType)[self.rssType intValue] == (RSSType)RSSMalaysiakini){
                             author = [[childElement firstChild] content];
                         }else{
                             NSScanner *theScanner = [NSScanner scannerWithString:[[childElement firstChild] content]];
                             NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"("];
                             NSCharacterSet *charsetTwo = [NSCharacterSet characterSetWithCharactersInString:@")"];
                             [theScanner scanUpToCharactersFromSet:charset intoString:nil];
                             [theScanner scanCharactersFromSet:charset intoString:nil];
                             [theScanner scanUpToCharactersFromSet:charsetTwo intoString:&author];
                         }
                         
                         if (author == nil) {
                             author = @"Admin";
                         }
                         
                         rssClass.author = author;
                     }
                     else if ([childElement.tagName isEqualToString:@"pubDate"])
                     {
                         rssClass.pubDate = [[childElement firstChild] content];
                     }
                     else
                     {
                         //do nothing
                     }
                     
                     
                     if ([childElement.tagName isEqualToString:@"description"])
                     {
                         
                         if ((RSSType)[self.rssType intValue] == (RSSType)RSSGeneral){
                             //Scan image
                             NSString *url = nil;
                             NSScanner *theScanner = [NSScanner scannerWithString:[[childElement firstChild] content]];
                             [theScanner scanUpToString:@"<img" intoString:nil];
                             
                             if (![theScanner isAtEnd]) {
                                 [theScanner scanUpToString:@"src" intoString:nil];
                                 NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
                                 [theScanner scanUpToCharactersFromSet:charset intoString:nil];
                                 [theScanner scanCharactersFromSet:charset intoString:nil];
                                 [theScanner scanUpToCharactersFromSet:charset intoString:&url];
                                 // "url" now contains the URL of the img
                             }
                             
                             rssClass.imageURL = url;
                             NSLog(@"image URL: %@", url);
                             //End of Scan Image
                             
                             //Scan Content
                             //NSString *StrippedHTML = [[[childElement firstChild] content] stripHtml];
                             //NSLog(@"%@", StrippedHTML);
                             
                             //End of Scan Content
                         }
                         
                         if ((RSSType)[self.rssType intValue] == (RSSType)RSSMalaysiakini){
                             
                         }   
                     }
                     else
                     {
                         NSLog(@"%@", [[childElement firstChild] content]);
                     }
                     
                 }
                 
             }
             
             if (rssClass.link == nil) {
                 rssClass.link = @"http://webexamplenotexist.com";
             }
             
             if (rssClass.author == nil) {
                 rssClass.author = @"Admin";
             }
             
             [self.dataSource addObject:rssClass];
             [rssClass release];
         }
         
         if ([_dataSource count] > 0) {
             
             if (self.bgWebView.alpha == 1.0) {
                 //remove also no internet view after finished animation
                 [self fadeOutBackgroundView];
             }
             
             [_tableView reloadData];
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
    PSRSSCell *cell = (PSRSSCell *)[tableView dequeueReusableCellWithIdentifier:@"rssIdentifier"];
    if (cell == nil) {
        
        if ((RSSType)[self.rssType intValue] == (RSSType)RSSInclude)
        {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSRSSCell2" owner:nil options:nil];
            cell = (PSRSSCell *)[views objectAtIndex:0];
        }
        else if ((RSSType)[self.rssType intValue] == (RSSType)RSSMalaysiakini)
        {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSRSSCell2" owner:nil options:nil];
            cell = (PSRSSCell *)[views objectAtIndex:0];
        }
        else
        {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSRSSCell" owner:nil options:nil];
            cell = (PSRSSCell *)[views objectAtIndex:0];
        }
    }
    
    PSRSSClass *rssClass = (PSRSSClass *)[_dataSource objectAtIndex:indexPath.row];
    cell.title.lineBreakMode = UILineBreakModeWordWrap;
    cell.title.numberOfLines = 0;
    cell.title.text = rssClass.title;
    
    cell.publishedDate.lineBreakMode = UILineBreakModeWordWrap;
    cell.publishedDate.numberOfLines = 0;
    
    if ((RSSType)[self.rssType intValue] == (RSSType)RSSInclude)
    {
        cell.publishedDate.text = [NSString stringWithFormat:@"By %@ at %@", rssClass.author, rssClass.pubDate];
    }
    else
    {
        //RSSGeneral
        NSDateFormatter *formatDate = [[[NSDateFormatter alloc] init] autorelease];
        [formatDate setTimeStyle:NSDateFormatterFullStyle];
        [formatDate setLocale:[HSTimeIntervalFormatter currentLocale]];
        
        if ((RSSType)[self.rssType intValue] == (RSSType)RSSMalaysiakini){
            [formatDate setDateFormat:@"EEE, dd MMM yyyy hh:mm:ss ZZZ"];
        }else{
            [formatDate setDateFormat:@"EEE, dd MMM yyyy hh:mm:ss 'GMT'"];
        }
        
        NSDate *pubDate = [formatDate dateFromString:rssClass.pubDate];
        
        
        NSTimeInterval timeDifference = [pubDate timeIntervalSinceDate:[NSDate date]];
        //rssClass.pubDate
        HSTimeIntervalFormatter *timeFormatter = [[[HSTimeIntervalFormatter alloc] init] autorelease];
        [timeFormatter setLocale:[HSTimeIntervalFormatter currentLocale]];
        cell.publishedDate.text = [NSString stringWithFormat:@"By %@ at %@", rssClass.author, [timeFormatter stringForTimeInterval:timeDifference]];
        
        if ((RSSType)[self.rssType intValue] == (RSSType)RSSGeneral){
            [cell.imgView setImageWithURL:[NSURL URLWithString:rssClass.imageURL] placeholderImage:[UIImage imageNamed:@"placeholderBokeh.png"]];
        }
        
    }
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.beritaWebController = [[[PSBeritaWebViewController alloc] initWithNibName:@"PSBeritaWebViewController" bundle:nil] autorelease];
    PSRSSClass *rssClass = (PSRSSClass *)[_dataSource objectAtIndex:indexPath.row];
    self.beritaWebController.urlNews = [NSURL URLWithString:rssClass.link];
    [self.navigationController pushViewController:_beritaWebController animated:YES];
}

#pragma mark - Action

-(void)goToBeritaController
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
