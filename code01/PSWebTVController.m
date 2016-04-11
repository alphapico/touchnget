//
//  PSWebTVController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/16/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSWebTVController.h"
#import "VSPlayerViewController.h"
#import "PSWebTVWebViewController.h"
#import "PSWebTVCell.h"
#import "MHProgressHUD.h"
#import "PSAppDelegate.h"


NSString *const kChannelWMP = @"ChannelWMP";
NSString *const kChannelFlash = @"ChannelFlash";
NSString *const kChannelUstream = @"ChannelUstream";
NSString *const kChannelYoutube = @"ChannelYoutube";
NSString *const kChannelFacebook = @"ChannelFacebook";
NSString *const kNameChannel = @"NameChannel";
NSString *const kDescription = @"Description";
NSString *const kSelectedIndexPath = @"SelectedIndexPath";

@interface Channel : NSObject {
    NSString *_name;
    NSString *_urlAddress;
    NSString *_description;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *urlAddress;
@property (nonatomic, readonly) NSString *description;

@property (nonatomic, readonly) NSString *urlWMP;
@property (nonatomic, readonly) NSString *urlFlash;
@property (nonatomic, readonly) NSString *urlUstream;
@property (nonatomic, readonly) NSString *urlYoutube;
@property (nonatomic, readonly) NSString *urlFacebook;

+ (id)channelWithName:(NSString *)name addr:(NSString *)addr description:(NSString *)description;
- (id)initWithName:(NSString *)name addr:(NSString *)addr description:(NSString *)description;

@end

@implementation Channel

@synthesize name = _name;
@synthesize urlAddress = _urlAddress;
@synthesize description = _description;

@synthesize urlWMP = _urlWMP;
@synthesize urlFlash = _urlFlash;
@synthesize urlUstream = _urlUstream;
@synthesize urlYoutube = _urlYoutube;
@synthesize urlFacebook = _urlFacebook;

+ (id)channelWithAddress:(NSString *)addr
{
    return [[[self alloc] initWithAddress:addr] autorelease];
}

- (id)initWithAddress:(NSString *)addr
{
    self = [super init];
    if (self) {
        _urlAddress = [addr retain];
    }
    
    return self;
}

+ (id)channelWithName:(NSString *)name addr:(NSString *)addr description:(NSString *)description {
    return [[[self alloc] initWithName:name addr:addr description:description] autorelease];
}

- (id)initWithName:(NSString *)name addr:(NSString *)addr description:(NSString *)description {
    self = [super init];
    if (self) {
        _name = [name retain];
        _urlAddress = [addr retain];
        _description = [description retain];
    }
    return self;
}

- (void)dealloc {
    [_name release];
    [_urlAddress release];
    [_description release];
    [super dealloc];
}

@end

@interface PSWebTVController (){
}

@property (nonatomic, strong) UIButton *btnWMPChannel;
@property (nonatomic, strong) UIButton *btnFlashChannel;
@property (nonatomic, strong) UIButton *btnUstreamChannel;
@property (nonatomic, strong) UIButton *btnYoutubeChannel;
@property (nonatomic, strong) UIButton *btnFacebookChannel;

@end


@implementation PSWebTVController

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize webController = _webController;

@synthesize btnWMPChannel = _btnWMPChannel;
@synthesize btnFlashChannel = _btnFlashChannel;
@synthesize btnUstreamChannel = _btnUstreamChannel;
@synthesize btnYoutubeChannel = _btnYoutubeChannel;
@synthesize btnFacebookChannel = _btnFacebookChannel;

//@synthesize tableViewData = _tableViewData;
@synthesize selectedIndexPath = _selectedIndexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.dataSource = [[[NSMutableArray alloc] init] autorelease];
        
        NSDictionary *c1 = [NSDictionary dictionaryWithObjectsAndKeys:@"WebTV 1", kNameChannel, @"WebTV PAS Saluran Utama", kDescription, @"mms://210.187.143.19/webtv1" , kChannelWMP, @"https://m.facebook.com/pages/WebTV-PAS/221434224590749", kChannelFacebook, nil];
        [_dataSource addObject:c1];

        NSDictionary *c2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Terengganukini TV", kNameChannel, @"Live dari Terengganu", kDescription, @"mms://210.187.143.19/webtv2" , kChannelWMP, @"http://www.ustream.tv/embed/12795733?autoplay=True", kChannelUstream, @"https://m.youtube.com/user/terengganukini", kChannelYoutube, @"https://m.facebook.com/pages/Terengganu-Kini/238473629539168", kChannelFacebook, nil];
        [_dataSource addObject:c2];
        
        NSDictionary *c3 = [NSDictionary dictionaryWithObjectsAndKeys:@"KelantanTV", kNameChannel, @"Live dari Kelantan", kDescription, @"mms://210.187.143.19/ktv" , kChannelWMP, @"http://www.ustream.tv/embed/139634?autoplay=True", kChannelUstream, @"https://m.youtube.com/user/myKelantanTV", kChannelYoutube , @"https://m.facebook.com/pages/Kelantan-TV-News/136171306461158", kChannelFacebook, nil];
        [_dataSource addObject:c3];
        
        NSDictionary *c4 = [NSDictionary dictionaryWithObjectsAndKeys:@"Makmur TV", kNameChannel, @"Live dari Pahang", kDescription, @"mms://210.187.143.19/pahangtv" , kChannelWMP, @"http://www.ustream.tv/embed/11083843?autoplay=True", kChannelUstream, @"https://m.youtube.com/user/pahangkini", kChannelYoutube, @"https://m.facebook.com/tvmakmur", kChannelFacebook, nil];
        [_dataSource addObject:c4];
        
        NSDictionary *c5 = [NSDictionary dictionaryWithObjectsAndKeys:@"MPPAS TV", kNameChannel, @"Live Sidang Parlimen", kDescription, @"mms://210.187.143.19/mppas" , kChannelWMP, @"http://www.ustream.tv/embed/24049082?autoplay=True", kChannelUstream, @"https://m.youtube.com/user/mppas2008", kChannelYoutube, nil];
        [_dataSource addObject:c5];
        
        NSDictionary *c6 = [NSDictionary dictionaryWithObjectsAndKeys:@"Aman TV", kNameChannel, @"Live dari Kedah", kDescription, @"mms://210.187.143.19/amantv" , kChannelWMP, @"https://m.youtube.com/user/urusetiapeneranganke", kChannelYoutube, @"https://m.facebook.com/pages/Aman-TV/247636501961665", kChannelFacebook ,nil];
        [_dataSource addObject:c6];
        ;
        NSDictionary *c7 = [NSDictionary dictionaryWithObjectsAndKeys:@"Ehsan TV", kNameChannel, @"Live dari Selangor", kDescription, @"mms://210.187.143.19/ehsantv" , kChannelWMP, @"http://www.ustream.tv/embed/10887783?autoplay=True", kChannelUstream, @"https://m.youtube.com/user/ehsantv", kChannelYoutube, @"https://m.facebook.com/ehsantv", kChannelFacebook ,nil];
        [_dataSource addObject:c7];
        
        NSDictionary *c8 = [NSDictionary dictionaryWithObjectsAndKeys:@"Yop TV", kNameChannel, @"Live dari Perak", kDescription, @"mms://210.187.143.19/yoptv" , kChannelWMP, @"https://m.youtube.com/user/yoperaktv", kChannelYoutube, @"https://m.facebook.com/pasperak", kChannelFacebook ,nil];
        [_dataSource addObject:c8];
        
         NSDictionary *c9 = [NSDictionary dictionaryWithObjectsAndKeys:@"WebTV 3", kNameChannel, @"WebTV PAS Saluran Tambahan", kDescription, @"mms://210.187.143.19/webtv3" , kChannelWMP, @"https://m.facebook.com/pages/WebTV-PAS/221434224590749", kChannelFacebook ,nil];
        [_dataSource addObject:c9];
        
        NSDictionary *c9_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"DPP Malaysia", kNameChannel, @"Dewan Pemuda Pas Pusat", kDescription, @"https://m.youtube.com/user/DPPMalaysia" , kChannelYoutube, @"https://m.facebook.com/DPPMalaysia", kChannelFacebook ,nil];
        [_dataSource addObject:c9_1];
        
        NSDictionary *c9_2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Buletin Online", kNameChannel, @"Buletin Online", kDescription,@"http://www.ustream.tv/embed/27977340?autoplay=True" ,kChannelUstream, @"https://m.youtube.com/user/buletinonline" , kChannelYoutube, @"https://m.facebook.com/pages/Buletin-Online/226199907418379", kChannelFacebook ,nil];
        [_dataSource addObject:c9_2];
        
        NSDictionary *c9_3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Kinabalu TV", kNameChannel, @"Live dari Sabah", kDescription,@"http://www.ustream.tv/embed/7079342?autoplay=True" ,kChannelUstream, @"https://m.youtube.com/user/kinabalutv" , kChannelYoutube, @"https://m.facebook.com/kinabalutv.sabah", kChannelFacebook ,nil];
        [_dataSource addObject:c9_3];
        
        NSDictionary *c9_4 = [NSDictionary dictionaryWithObjectsAndKeys:@"TV Impian", kNameChannel, @"TV Alternatif Rakyat Malaysia", kDescription, @"https://m.youtube.com/user/ImpianTV" , kChannelYoutube, @"https://m.facebook.com/TvImpianHqOfficial", kChannelFacebook ,nil];
        [_dataSource addObject:c9_4];
        
        NSDictionary *c9_5 = [NSDictionary dictionaryWithObjectsAndKeys:@"Wau TV", kNameChannel, @"TV Wau", kDescription,@"http://www.ustream.tv/embed/25574162?autoplay=True" ,kChannelUstream, @"http://m.youtube.com/user/TVWau" , kChannelYoutube, @"https://m.facebook.com/TVWau", kChannelFacebook ,nil];
        [_dataSource addObject:c9_5];
        
        NSDictionary *c9_6 = [NSDictionary dictionaryWithObjectsAndKeys:@"RTV Kelantan", kNameChannel, @"RTV Kelantan", kDescription,@"http://www.ustream.tv/embed/27284657?autoplay=True" ,kChannelUstream, @"https://m.youtube.com/user/RTVKelantan" , kChannelYoutube, @"https://m.facebook.com/pages/RTV-Kelantan/237318232948776", kChannelFacebook ,nil];
        [_dataSource addObject:c9_6];
        
        NSDictionary *c9_7 = [NSDictionary dictionaryWithObjectsAndKeys:@"Ustaz Azhar Idrus", kNameChannel, @"Live Kuliah Ustaz Azhar Idrus", kDescription,@"http://www.ustream.tv/embed/25574162?autoplay=True" ,kChannelUstream, @"https://m.facebook.com/Ustaz.Azhar.Idrus.Original", kChannelFacebook ,nil];
        [_dataSource addObject:c9_7];
        
        NSDictionary *c9_8 = [NSDictionary dictionaryWithObjectsAndKeys:@"Ustaz Azhar Idrus", kNameChannel, @"Live Kuliah Ustaz Azhar Idrus", kDescription,@"http://www.ustream.tv/embed/25574162?autoplay=True" ,kChannelUstream, @"https://m.facebook.com/Ustaz.Azhar.Idrus.Original", kChannelFacebook ,nil];
        [_dataSource addObject:c9_8];
        
        NSDictionary *c10 = [NSDictionary dictionaryWithObjectsAndKeys:@"TV Shura", kNameChannel, @"TV Sekretariat Ulama Rantau Asia", kDescription, @"mms://210.187.143.19/shura" , kChannelWMP ,nil];
        [_dataSource addObject:c10];
        
        NSDictionary *c10_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"TV Selangor", kNameChannel, @"TV Selangorku.com", kDescription, @"rtmp://live2.selangorku.com/selangorlive2/channel1", kChannelFlash ,@"https://m.youtube.com/user/TVSelangor09" ,kChannelYoutube, @"https://m.facebook.com/MediaSelangorku", kChannelFacebook ,nil];
        [_dataSource addObject:c10_1];
        
        NSDictionary *c10_2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Malaysiakini TV", kNameChannel, @"TV Selangorku.com", kDescription, @"https://m.youtube.com/user/malaysiakini" ,kChannelYoutube,nil];
        [_dataSource addObject:c10_2];
        
        NSDictionary *c10_3 = [NSDictionary dictionaryWithObjectsAndKeys:@"TV Al-Hijrah", kNameChannel, @"TV Al-Hijrah JAKIM", kDescription, @"rtsp://110.74.142.92/live/alhijrah_mqs.3gp" , kChannelWMP ,nil];
        [_dataSource addObject:c10_3];
        
        NSDictionary *c11 = [NSDictionary dictionaryWithObjectsAndKeys:@"ShareIslam TV", kNameChannel, @"ShareIslam TV", kDescription, @"mms://stream.watchislam.com/shareislam" , kChannelWMP ,nil];
        [_dataSource addObject:c11];
        
        NSDictionary *c11_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"GuideUs TV", kNameChannel, @"GuideUs TV", kDescription, @"rtmp://streamer.istreamlive.net/1_216_130_41/live" , kChannelFlash ,nil];
        [_dataSource addObject:c11_1];
        
        NSDictionary *c11_2 = [NSDictionary dictionaryWithObjectsAndKeys:@"IslamChannel TV", kNameChannel, @"IslamChannel TV", kDescription, @"rtmp://wowza02.sharp-stream.com/islamtv/islamtv/" , kChannelFlash ,nil];
        [_dataSource addObject:c11_2];
        
        NSDictionary *c11_3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Peace TV", kNameChannel, @"Peace TV", kDescription, @"rtmp://peace.fms.visionip.tv/live/b2b-peace_asia-live-25f-4x3-sdh_1" , kChannelFlash ,nil];
        [_dataSource addObject:c11_3];
        
        NSDictionary *c12 = [NSDictionary dictionaryWithObjectsAndKeys:@"Makkah Live", kNameChannel, @"Live From Makkah", kDescription, @"rtsp://38.96.148.75/Quran?MSWMExt=.asf" , kChannelWMP, @"http://www.ustream.tv/embed/10584902?autoplay=True", kChannelUstream, @"rtmp://69.65.38.152/besmallah/cam4", kChannelFlash, @"http://www.youtube.com/embed/S2PriQcCG38?rel=0&amp;autoplay=1", kChannelYoutube ,nil];
        [_dataSource addObject:c12];
        
        NSDictionary *c13 = [NSDictionary dictionaryWithObjectsAndKeys:@"Madinah Live", kNameChannel, @"Live From Madinah", kDescription, @"rtsp://38.96.148.75/Sunnah?MSWMExt=.asf" , kChannelWMP, @"rtmp://69.65.38.152/besmallah/cam3", kChannelFlash, @"http://www.youtube.com/embed/KonSX32x5YU?rel=0&autoplay=1", kChannelYoutube ,nil];
        [_dataSource addObject:c13];
        
        NSDictionary *c13_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Al-Jazeera (Arabic)", kNameChannel, @"Al-Jazeera Arabic", kDescription, @"rtmp://aljazeeraflashlivefs.fplive.net/aljazeeraflashlive-live/aljazeera_arabic_1" , kChannelFlash ,nil];
        [_dataSource addObject:c13_1];
        
        NSDictionary *c13_2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Al-Jazeera (English)", kNameChannel, @"Al-Jazeera English", kDescription, @"http://aj.lsops.net/live/aljazeer_en_high.sdp/playlist.m3u8" , kChannelFlash , @"http://www.youtube.com/embed/e93MaEwrsfc?rel=0&amp;autoplay=1", kChannelYoutube ,nil];
        [_dataSource addObject:c13_2];
        
        NSDictionary *c13_3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Huda TV", kNameChannel, @"Huda TV", kDescription, @"rtmp://204.45.81.227:1935/hudatvlive/hudatv" , kChannelFlash ,nil];
        [_dataSource addObject:c13_3];
        
        NSDictionary *c13_4 = [NSDictionary dictionaryWithObjectsAndKeys:@"Al-Majd Quran TV", kNameChannel, @"Al-Majd Quran TV", kDescription, @"http://www.ustream.tv/embed/5433846?autoplay=True" , kChannelUstream ,nil];
        [_dataSource addObject:c13_4];
        
        NSDictionary *c14 = [NSDictionary dictionaryWithObjectsAndKeys:@"Ramadhan Channel", kNameChannel, @"Ramadhan Channel", kDescription, @"mms://stream.watchislam.com/ramadan?MWSMExt=.asf" , kChannelWMP, @"rtmp://stream.watchislam.com:1935/bridgetofaith/quran", kChannelFlash ,nil];
        [_dataSource addObject:c14];
        
        NSDictionary *c15 = [NSDictionary dictionaryWithObjectsAndKeys:@"Press TV", kNameChannel, @"Press TV", kDescription, @"mms://217.218.67.243/presstv" , kChannelWMP, @"rtmp://cp140005.live.edgefcs.net:80/live/PressTV_4@26409", kChannelFlash ,nil];
        [_dataSource addObject:c15];
        
        NSDictionary *c16 = [NSDictionary dictionaryWithObjectsAndKeys:@"Bernama TV", kNameChannel, @"Bernama TV", kDescription, @"rtsp://110.74.142.92/live/bernama_hqm.3gp" , kChannelWMP ,nil];
        [_dataSource addObject:c16];
        
        NSDictionary *c17 = [NSDictionary dictionaryWithObjectsAndKeys:@"Radio Ikim.fm", kNameChannel, @"Radio Ikim.fm", kDescription, @"mms://ucitv2.uthm.edu.my/radio2" , kChannelWMP ,nil];
        [_dataSource addObject:c17];
        
        NSDictionary *c18 = [NSDictionary dictionaryWithObjectsAndKeys:@"Sharjah TV", kNameChannel, @"Sharjah TV", kDescription, @"mms://streamer5.securenetsystems.net/SMCTV" , kChannelWMP ,nil];
        [_dataSource addObject:c18];
        
        NSDictionary *c19 = [NSDictionary dictionaryWithObjectsAndKeys:@"Iqraa TV", kNameChannel, @"Iqraa TV", kDescription, @"rtmp://fl1.viastreaming.net/iqraatv/livestream" , kChannelFlash ,nil];
        [_dataSource addObject:c19];
        
        NSDictionary *c20 = [NSDictionary dictionaryWithObjectsAndKeys:@"Al-Hiwar TV", kNameChannel, @"Al-Hiwar TV", kDescription, @"rtmp://209.236.66.43/livephgr/livestream" , kChannelFlash ,nil];
        [_dataSource addObject:c20];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVSPlayerStateChanged:) name:kVSPlayerStateChangedNotification object:nil];
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
    
    self.selectedIndexPath = nil;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [MHProgressHUD sharedView].hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    });
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInt:7] forKey:@"selectedIndex"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark View controller rotation methods & callbacks

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
- (BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}


#pragma mark - TableViewDelegate

//test
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.tableViewData count];
    return [self.dataSource count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSWebTVCell *cell;
    
    if ([[self.dataSource objectAtIndex:indexPath.row] objectForKey:kSelectedIndexPath]) {
        
        static NSString *DropDownCellIdentifier = @"DropDownCell";
        
        cell = (PSWebTVCell *)[tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
        if (cell == nil) {
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DropDownCellIdentifier];
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSWebTVCell" owner:nil options:nil];
            cell = (PSWebTVCell *)[views objectAtIndex:0];
        }
        
        NSLog(@"indexPath = %d ,selectedIndex = %d", indexPath.row, self.selectedIndexPath.row);
        
        NSString *channelWMP = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:kChannelWMP];
        NSString *channelFlash = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:kChannelFlash];
        NSString *channelUstream = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:kChannelUstream];
        NSString *channelYoutube = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:kChannelYoutube];
        NSString *channelFacebook = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:kChannelFacebook];
        
        NSUInteger indexBtn = 0;
        NSUInteger padding = 0;
        NSUInteger paddingBetween = 15;
        NSUInteger margin_left = 20;
        NSUInteger margin_top = 10;
        
        NSUInteger countWidth = 0;
        NSUInteger indexCount = 0;
        if (channelWMP) {
            UIImage *imgChannel = [UIImage imageNamed:@"wmpPlayer.png"];
            countWidth = countWidth + imgChannel.size.width;
            indexCount++;
        }
        if (channelFlash) {
            UIImage *imgChannel = [UIImage imageNamed:@"flashPlayer.png"];
            countWidth = countWidth + imgChannel.size.width;
            indexCount++;
        }
        if (channelUstream) {
            UIImage *imgChannel = [UIImage imageNamed:@"ustreamPlayer.png"];
            countWidth = countWidth + imgChannel.size.width;
            indexCount++;
        }
        if (channelYoutube) {
            UIImage *imgChannel = [UIImage imageNamed:@"youtubePlayer.png"];
            countWidth = countWidth + imgChannel.size.width;
            indexCount++;
        }
        if (channelFacebook) {
            UIImage *imgChannel = [UIImage imageNamed:@"facebookPlayer.png"];
            countWidth = countWidth + imgChannel.size.width;
            indexCount++;
        }
        
        if (indexCount == 0) {
            margin_left = (self.view.frame.size.width - countWidth)/2.0;
        }else{
            margin_left = (self.view.frame.size.width - (paddingBetween*(indexCount-1) + countWidth) )/2.0;
        }
        
        
        if ([self.btnWMPChannel superview]) {
            [self.btnWMPChannel removeFromSuperview];
        }
        
        if ([self.btnUstreamChannel superview]) {
            [self.btnUstreamChannel removeFromSuperview];
        }
        
        if ([self.btnFlashChannel superview]) {
            [self.btnFlashChannel removeFromSuperview];
        }
        
        if ([self.btnYoutubeChannel superview]) {
            [self.btnYoutubeChannel removeFromSuperview];
        }
        
        if ([self.btnFacebookChannel superview]) {
            [self.btnFacebookChannel removeFromSuperview];
        }
        
        
        if (channelWMP) {
            UIImage *imgChannel = [UIImage imageNamed:@"wmpPlayer.png"];
            self.btnWMPChannel = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnWMPChannel.frame = CGRectMake(margin_left + paddingBetween*indexBtn + padding, margin_top , imgChannel.size.width, imgChannel.size.height);
            [_btnWMPChannel setBackgroundImage:imgChannel forState:UIControlStateNormal];
            
            _btnWMPChannel.tag = indexPath.row;
            [_btnWMPChannel addTarget:self action:@selector(goToWMPController:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:_btnWMPChannel];
            
            padding = padding + _btnWMPChannel.frame.size.width;
            indexBtn++;
        }
        
        if (channelFlash) {
            UIImage *imgChannel = [UIImage imageNamed:@"flashPlayer.png"];
            self.btnFlashChannel = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnFlashChannel.frame = CGRectMake(margin_left + paddingBetween*indexBtn + padding, margin_top , imgChannel.size.width, imgChannel.size.height);
            [_btnFlashChannel setBackgroundImage:imgChannel forState:UIControlStateNormal];
            
            _btnFlashChannel.tag = indexPath.row;
            [_btnFlashChannel addTarget:self action:@selector(goToFlashController:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:_btnFlashChannel];
            
            padding = padding + _btnFlashChannel.frame.size.width;
            indexBtn++;
        }
        
        if (channelUstream) {
            UIImage *imgChannel = [UIImage imageNamed:@"ustreamPlayer.png"];
            self.btnUstreamChannel = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnUstreamChannel.frame = CGRectMake(margin_left + paddingBetween*indexBtn + padding, margin_top , imgChannel.size.width, imgChannel.size.height);
            [_btnUstreamChannel setBackgroundImage:imgChannel forState:UIControlStateNormal];
            
            _btnUstreamChannel.tag = indexPath.row;
            [_btnUstreamChannel addTarget:self action:@selector(goToUstreamController:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:_btnUstreamChannel];
            
            padding = padding + _btnUstreamChannel.frame.size.width;
            indexBtn++;
        }
        
        if (channelYoutube) {
            UIImage *imgChannel = [UIImage imageNamed:@"youtubePlayer.png"];
            self.btnYoutubeChannel = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnYoutubeChannel.frame = CGRectMake(margin_left + paddingBetween*indexBtn + padding, margin_top , imgChannel.size.width, imgChannel.size.height);
            [_btnYoutubeChannel setBackgroundImage:imgChannel forState:UIControlStateNormal];
            
            _btnYoutubeChannel.tag = indexPath.row;
            [_btnYoutubeChannel addTarget:self action:@selector(goToYoutubeController:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:_btnYoutubeChannel];
            
            padding = padding + _btnYoutubeChannel.frame.size.width;
            indexBtn++;
        }
        
        if (channelFacebook) {
            UIImage *imgChannel = [UIImage imageNamed:@"facebookPlayer.png"];
            self.btnFacebookChannel = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnFacebookChannel.frame = CGRectMake(margin_left + paddingBetween*indexBtn + padding, margin_top , imgChannel.size.width, imgChannel.size.height);
            [_btnFacebookChannel setBackgroundImage:imgChannel forState:UIControlStateNormal];
            
            _btnFacebookChannel.tag = indexPath.row;
            [_btnFacebookChannel addTarget:self action:@selector(goToFacebookController:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:_btnFacebookChannel];
            
            padding = padding + _btnFacebookChannel.frame.size.width;
            indexBtn++;
        }
        
        cell.title.text = @"";
        cell.titleDetails.text = @"";
        cell.bulletGreenView.image = nil;
        
    }
    else
    {
        
        static NSString *DataCellIdentifier = @"DataCell";
        
        cell = (PSWebTVCell *)[tableView dequeueReusableCellWithIdentifier:DataCellIdentifier];
        if (cell == nil) {
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DataCellIdentifier];
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSWebTVCell" owner:nil options:nil];
            cell = (PSWebTVCell *)[views objectAtIndex:0];
        }
        //cell.textLabel.text = [self.tableViewData objectAtIndex:indexPath.row];
        
        NSString *channelName = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:kNameChannel];
        NSString *channelDescription = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:kDescription];
        
        cell.title.text = channelName;
        cell.titleDetails.text = channelDescription;
        //cell.textLabel.text = channelName;
        //cell.detailTextLabel.text = channelDescription;
        //cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        //cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        
        
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;


//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subMenuIdentifier"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subMenuIdentifier"];
//    }
//
//#warning TODO
//
//
//    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *dropDownCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                            inSection:indexPath.section];
    
    if (!self.selectedIndexPath) {
        // Show Drop Down Cell
        //[self.tableViewData insertObject:@"Drop Down Cell" atIndex:dropDownCellIndexPath.row];
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[self.dataSource objectAtIndex:indexPath.row]];
        
        self.selectedIndexPath = indexPath;
        [dataDict setObject:self.selectedIndexPath forKey:kSelectedIndexPath];
        [self.dataSource insertObject:dataDict atIndex:dropDownCellIndexPath.row];
        
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:dropDownCellIndexPath]
                         withRowAnimation:UITableViewRowAnimationTop];
        
        
    } else {
        NSIndexPath *currentdropDownCellIndexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.row + 1
                                                                       inSection:self.selectedIndexPath.section];
        
        if (indexPath.row == self.selectedIndexPath.row) {
            // Hide Drop Down Cell
            //[self.tableViewData removeObjectAtIndex:currentdropDownCellIndexPath.row];
            [self.dataSource removeObjectAtIndex:currentdropDownCellIndexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentdropDownCellIndexPath]
                             withRowAnimation:UITableViewRowAnimationTop];
            
            self.selectedIndexPath = nil;
        } else if (indexPath.row == currentdropDownCellIndexPath.row) {
            // Dropdown Cell Selected - No Action
            return;
        } else {
            // Switch Dropdown Cell Location
            [tableView beginUpdates];
            // Hide Dropdown Cell
            //[self.tableViewData removeObjectAtIndex:currentdropDownCellIndexPath.row];
            [self.dataSource removeObjectAtIndex:currentdropDownCellIndexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentdropDownCellIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
     
            
            // Show Dropdown Cell
            NSInteger dropDownCellRow = indexPath.row + ((indexPath.row >= currentdropDownCellIndexPath.row) ? 0 : 1);
            dropDownCellIndexPath = [NSIndexPath indexPathForRow:dropDownCellRow
                                                       inSection:indexPath.section];
            
            
            //[self.tableViewData insertObject:@"Drop Down Cell" atIndex:dropDownCellIndexPath.row];
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[self.dataSource objectAtIndex:indexPath.row]];
            
            
            [dataDict setObject:self.selectedIndexPath forKey:kSelectedIndexPath];
            [self.dataSource insertObject:dataDict atIndex:dropDownCellIndexPath.row];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:dropDownCellIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            
            self.selectedIndexPath = [NSIndexPath indexPathForRow:dropDownCellIndexPath.row - 1
                                                        inSection:dropDownCellIndexPath.section];
            
            [tableView endUpdates];                            
        }        
    }
}

#pragma mark - Action

-(void)goToWMPController:(id)sender
{
    NSUInteger idxRow = ((UIControl *)sender).tag;
    NSString *channelWMP = [[self.dataSource objectAtIndex:idxRow] objectForKey:kChannelWMP];
    
    if (channelWMP) {
        
        NSString *channelName = [[self.dataSource objectAtIndex:idxRow] objectForKey:kNameChannel];
        
        VSPlayerViewController *playerVc = [[[VSPlayerViewController alloc] initWithURL:[NSURL URLWithString:channelWMP] barTitle:channelName] autorelease];
        playerVc.statusBarHidden = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            [self.navigationController presentViewController:playerVc animated:YES completion:NULL];
        } else {
            //running on iOS 5.x
            [self.navigationController presentModalViewController:playerVc animated:YES];
        }
#else
        [self.navigationController presentModalViewController:playerVc animated:YES];
#endif
    }
}

-(void)goToFlashController:(id)sender
{
    NSUInteger idxRow = ((UIControl *)sender).tag;
    NSString *channelFlash = [[self.dataSource objectAtIndex:idxRow] objectForKey:kChannelFlash];
    
    if (channelFlash) {
        
        NSString *channelName = [[self.dataSource objectAtIndex:idxRow] objectForKey:kNameChannel];
        
        VSPlayerViewController *playerVc = [[[VSPlayerViewController alloc] initWithURL:[NSURL URLWithString:channelFlash] barTitle:channelName] autorelease];
        playerVc.statusBarHidden = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            //running on iOS 6.0 or higher
            [self.navigationController presentViewController:playerVc animated:YES completion:NULL];
        } else {
            //running on iOS 5.x
            [self.navigationController presentModalViewController:playerVc animated:YES];
        }
#else
        [self.navigationController presentModalViewController:playerVc animated:YES];
#endif
    }
}

-(void)goToUstreamController:(id)sender
{
    NSUInteger idxRow = ((UIControl *)sender).tag;
    NSString *channelUstream = [[self.dataSource objectAtIndex:idxRow] objectForKey:kChannelUstream];
    
    if (channelUstream) {
        self.webController = [[[PSWebTVWebViewController alloc] initWithNibName:@"PSWebTVWebViewController" bundle:nil] autorelease];
        self.webController.urlNews = [NSURL URLWithString:channelUstream];
        [self.navigationController pushViewController:_webController animated:YES];
    }
    
}

-(void)goToYoutubeController:(id)sender
{
    NSUInteger idxRow = ((UIControl *)sender).tag;
    NSString *channelYoutube = [[self.dataSource objectAtIndex:idxRow] objectForKey:kChannelYoutube];
    
    if (channelYoutube) {
        self.webController = [[[PSWebTVWebViewController alloc] initWithNibName:@"PSWebTVWebViewController" bundle:nil] autorelease];
        self.webController.urlNews = [NSURL URLWithString:channelYoutube];
        [self.navigationController pushViewController:_webController animated:YES];
    }
    
}

-(void)goToFacebookController:(id)sender
{
    NSUInteger idxRow = ((UIControl *)sender).tag;
    NSString *channelFacebook = [[self.dataSource objectAtIndex:idxRow] objectForKey:kChannelFacebook];
    
    if (channelFacebook) {
        self.webController = [[[PSWebTVWebViewController alloc] initWithNibName:@"PSWebTVWebViewController" bundle:nil] autorelease];
        self.webController.urlNews = [NSURL URLWithString:channelFacebook];
        [self.navigationController pushViewController:_webController animated:YES];
    }
    
}

#pragma mark - Video Stream Player callback

- (void)onVSPlayerStateChanged:(NSNotification*)theNotification {
    
    NSDictionary *userInfo = [theNotification userInfo];
    VSDecoderState state = [[userInfo objectForKey:kVSPlayerStateChangedUserInfoStateKey] intValue];
    VSError errCode = [[userInfo objectForKey:kVSPlayerStateChangedUserInfoErrorCodeKey] intValue];
    
    if (state == kVSDecoderStateCheckingProtocols) {
        
    } else if (state == kVSDecoderStateConnecting) {
        
    } else if (state == kVSDecoderStateConnected) {
        
    } else if (state == kVSDecoderStateInitialLoading) {
        
    } else if (state == kVSDecoderStateReadyToPlay) {
        
    } else if (state == kVSDecoderStateBuffering) {
        
    } else if (state == kVSDecoderStatePlaying) {
    } else if (state == kVSDecoderStatePaused) {
    } else if (state == kVSDecoderStateStoppedByUser) {
        
    } else if (state == kVSDecoderStateConnectionFailed) {
    } else if (state == kVSDecoderStateStoppedWithError) {
        if (errCode == kVSErrorStreamReadError) {
            
        }
    } else if (state == kVSDecoderStateStreamsChecked) {
        if (errCode == kVSErrorNone) {
            
        } else if (errCode == kVSErrorStreamInfoNotFound ||
                   errCode == kVSErrorAudioStreamNotFound) {
        } else if (errCode == kVSErrorVideoCodecNotFound ||
                   errCode == kVSErrorVideoCodecNotOpened ||
                   errCode == kVSErrorVideoAllocateMemory ||
                   errCode == kVSErrorVideoStreamNotFound) {
        }
    }
}

-(void)showMenuOfPaperFold:(id)sender
{
    [((PSAppDelegate *)[UIApplication sharedApplication].delegate) showMenuNavigation];
}

@end
