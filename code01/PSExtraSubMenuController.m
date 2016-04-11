//
//  PSExtraSubMenuController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/4/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSExtraSubMenuController.h"
#import "PSCommonCode.h"
#import "PSExtraWebController.h"
#import "JSONKit.h"

@interface PSExtraSubMenuController ()

@end

@implementation PSExtraSubMenuController

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize subMenu = _subMenu;
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
    
    if ([_subMenu isEqualToString:@"Al-Ma'thurat"]) {
        [self fetchMathurat];
    }
    
    if ([_subMenu isEqualToString:@"Do'a  Harian"]) {
        [self fetchDoa];
    }
    
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMathurat
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"Surah Al-Fatihah", @"Surah Al-Baqarah (1-5)", @"Surah Al-Baqarah (255)", @"Surah Al-Baqarah (256-257)", @"Surah Al-Baqarah (284-285)", @"Surah Al-Baqarah (286)",  @"Surah Al-Ikhlas", @"Surah Al-Falaq", @"Surah Al-Nas", @"Do'a 01 Pagi", @"Do'a 02 Pagi", @"Do'a 03 Pagi", @"Do'a 04 Pagi", @"Do'a 05 Zikir Puji", @"Do'a 06 Reda Islam" , @"Do'a 07 Zikir Reda Seberat ' Arasy" , @"Do'a 08 Elak Bahaya" , @"Do'a 09 Elak Syirik" ,@"Do'a 10 Elak Jahat Makhluk", @"Do'a 11 Elak Sikap Buruk" , @"Do'a 12 Sihat Badan" , @"Do'a 13 Elak Faqir", @"Do'a 14 Elak Jahat Sendiri", @"Do'a 15 Istighfar Taubat" ,@"Do'a 16 Tasbih Taubat", @"Do'a 17 Sholawat Kalam", @"Do'a 18 Do'a Sahabat", @"Surah Al-'Imran (26-27)", @"Do'a 19 Syukur Panjang", @"Do'a 20 Do'a Rabitah", nil];
    //NSArray *imageNameArray =
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        PSSubMenuClass *subMenu = [[PSSubMenuClass alloc] initWithTitle:[titleArray objectAtIndex:i]];
        [self.dataSource addObject:subMenu];
        [subMenu release];
    }
}

-(void)fetchDoa
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"doa_alquran" ofType:@"json"];
    NSError *error = nil;
//    NSString *jsonStr = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:&error];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id jsonResult = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }else{        
        NSLog(@"%@", jsonResult);
        
//        NSArray *doas = [jsonize valueForKeyPath:@"doas"];
//        
//        NSEnumerator *enumerator = [doas objectEnumerator];
//        NSDictionary *item;
//        while (item = (NSDictionary *)[enumerator nextObject]) {
//            NSLog(@"title = %@", [item objectForKey:@"title"]);
//            NSLog(@"surah = %@", [item objectForKey:@"surah"]);
//        }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subMenuIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subMenuIdentifier"];
    }
    
    PSSubMenuClass *subMenu = [_dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:subMenu.title];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.webController = [[[PSExtraWebController alloc] init] autorelease];
    PSSubMenuClass *subMenu = [_dataSource objectAtIndex:indexPath.row];
    
    if ([_subMenu isEqualToString:@"Al-Ma'thurat"]) {
        if ([subMenu.title isEqualToString:@"Surah Al-Fatihah"]) {
            self.webController.urlWebStr = @"01-fatihah";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Surah Al-Baqarah (1-5)"]){
            self.webController.urlWebStr = @"02-baqarah-1-5-aliflammim";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Surah Al-Baqarah (255)"]){
            self.webController.urlWebStr = @"03-baqarah-255-kursi1";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Surah Al-Baqarah (256-257)"]){
            self.webController.urlWebStr = @"04-baqarah-256-257";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Surah Al-Baqarah (284-285)"]){
            self.webController.urlWebStr = @"05-baqarah-284-285";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Surah Al-Baqarah (286)"]){
            self.webController.urlWebStr = @"06-baqarah-286";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Surah Al-Ikhlas"]){
            self.webController.urlWebStr = @"07-ikhlas";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Surah Al-Falaq"]){
            self.webController.urlWebStr = @"08-falaq";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Surah Al-Nas"]){
            self.webController.urlWebStr = @"09-nas";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 01 Pagi"]){
            self.webController.urlWebStr = @"10-doa01-pagi";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 02 Pagi"]){
            self.webController.urlWebStr = @"11-doa02-pagi";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 03 Pagi"]){
            self.webController.urlWebStr = @"12-doa03-pagi";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 04 Pagi"]){
            self.webController.urlWebStr = @"13-doa04-pagi";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 05 Zikir Puji"]){
            self.webController.urlWebStr = @"14-doa05-zikir-puji";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 06 Reda Islam"]){
            self.webController.urlWebStr = @"15-doa06-reda-islam";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 07 Zikir Reda Seberat ' Arasy"]){
            self.webController.urlWebStr = @"16-doa07-zikir-reda-seberat-arasy";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 08 Elak Bahaya"]){
            self.webController.urlWebStr = @"17-doa08-elak-bahaya";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 09 Elak Syirik"]){
            self.webController.urlWebStr = @"18-doa09-elak-syirik";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 10 Elak Jahat Makhluk"]){
            self.webController.urlWebStr = @"19-doa10-elak-jahat-makhluk";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 11 Elak Sikap Buruk"]){
            self.webController.urlWebStr = @"20-doa11-elak-sikap-buruk";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 12 Sihat Badan"]){
            self.webController.urlWebStr = @"21-doa12-sihat-badan";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 13 Elak Faqir"]){
            self.webController.urlWebStr = @"22-doa13-elak-fakir";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 14 Elak Jahat Sendiri"]){
            self.webController.urlWebStr = @"23-doa14-elak-jahat-sendiri";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 15 Istighfar Taubat"]){
            self.webController.urlWebStr = @"24-doa15-istighfar-taubat";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 16 Tasbih Taubat"]){
            self.webController.urlWebStr = @"25-doa16-tasbih-taubat";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 17 Sholawat Kalam"]){
            self.webController.urlWebStr = @"26-doa17-salawat-kalam";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 18 Do'a Sahabat"]){
            self.webController.urlWebStr = @"27-doa18-doa-sahabat";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Surah Al-'Imran (26-27)"]){
            self.webController.urlWebStr = @"28-ali-imran-26-27";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 19 Syukur Panjang"]){
            self.webController.urlWebStr = @"29-doa19-syukur-panjang";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else if ([subMenu.title isEqualToString:@"Do'a 20 Do'a Rabitah"]){
            self.webController.urlWebStr = @"30-doa20-rabitah";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }else{
            self.webController.urlWebStr = @"30-doa20-rabitah";
            self.webController.webType = [NSNumber numberWithInt:(WebType)WebFromFile];
        }
    }
    
    
    
    
    self.webController.title = subMenu.title;
    [self.navigationController pushViewController:_webController animated:YES];
}


@end
