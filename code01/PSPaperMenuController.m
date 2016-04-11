//
//  PSPaperMenuController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/21/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSPaperMenuController.h"
#import "PSMenuCell.h"

@interface PSPaperMenuController ()

@end

@implementation PSPaperMenuController

-(id)initWithMenuWidth:(float)menuWidth numberOfFolds:(int)numberOfFolds
{
    self = [super initWithMenuWidth:menuWidth numberOfFolds:numberOfFolds];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setOnlyAllowEdgeDrag:NO];
    
    UIView *tableBGView = [[UIView alloc] initWithFrame:self.view.bounds];
    [tableBGView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [self.menuTableView setBackgroundView:tableBGView];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self performSelector:@selector(reloadMenu)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = self.viewControllers[indexPath.row];
    if ([viewController.title isEqualToString:@"TouchNGet"]) {
        return 62;
    }else{
        return 54;
    }
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.menuTableView)
    {
        UIViewController *viewController = self.viewControllers[indexPath.row];
        
        static NSString *identifier = @"menuIdentifier";
        PSMenuCell *cell = (PSMenuCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            if ([viewController.title isEqualToString:@"TouchNGet"]){
                NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSMenuHeaderCell" owner:nil options:nil];
                cell = (PSMenuCell *)[views objectAtIndex:0];
            }else{
                NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PSMenuCell" owner:nil options:nil];
                cell = (PSMenuCell *)[views objectAtIndex:0];
            }
        }
        
        
        [cell.titleMenu setText:viewController.title];
        
        if ([viewController.title isEqualToString:@"TouchNGet"]) {
            cell.titleMenu.text = @"";
        }else if ([viewController.title isEqualToString:@"Berita"]) {
            [cell.iconView setImage:[UIImage imageNamed:@"menuBerita.png"]];
        }else if ([viewController.title isEqualToString:@"Kenali PAS"]){
            [cell.iconView setImage:[UIImage imageNamed:@"menuKenaliPas.png"]];
        }else if ([viewController.title isEqualToString:@"Aktiviti"]){
            [cell.iconView setImage:[UIImage imageNamed:@"menuAktiviti.png"]];
        }else if ([viewController.title isEqualToString:@"Facebook"]){
            [cell.iconView setImage:[UIImage imageNamed:@"menuFacebook.png"]];
        }else if([viewController.title isEqualToString:@"Twitter"]){
            [cell.iconView setImage:[UIImage imageNamed:@"menuTwitter.png"]];
        }else if([viewController.title isEqualToString:@"Web TV"]){
            [cell.iconView setImage:[UIImage imageNamed:@"menuWebTV.png"]];
        }else if([viewController.title isEqualToString:@"Maklum Balas"]){
            [cell.iconView setImage:[UIImage imageNamed:@"menuMaklumBalas.png"]];
        }else if([viewController.title isEqualToString:@"Extra"]){
            [cell.iconView setImage:[UIImage imageNamed:@"menuNotifikasi.png"]];
        }else{
            [cell.iconView setImage:[UIImage imageNamed:@"menuKenaliPas.png"]];
        }
        
        
        if (indexPath.row == self.selectedIndex)
        {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    }
    else return nil;
}

@end
