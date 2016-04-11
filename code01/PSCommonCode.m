//
//  PSCommonCode.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 2/19/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSCommonCode.h"
#import "OpenUDID.h"
#import <AdSupport/AdSupport.h>

NSString *const gWebBaseURL = @"http://bm.harakahdaily.net/";


@implementation PSCommonCode


+(NSString *)requestDeviceID
{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
//        NSLog(@"i'm iOS 6");
//        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//        
//        //http://stackoverflow.com/questions/11836225/ios6-udid-what-advantages-does-identifierforvendor-have-over-identifierforadve
//    }
//    
//    NSLog(@"i'm below than iOS 6");
    return [OpenUDID value];
}



@end




@implementation PSSubMenuClass

@synthesize imageName, title;

//TEST
-(id)initWithTitle:(NSString *)aTitle{
    self = [super init];
    if (self) {
        [self setTitle:aTitle];
    }
    return self;
}

-(id)initWithTitle:(NSString *)aTitle andImageName:(NSString *)aImageName
{
    self = [super init];
    if (self) {
        [self setTitle:aTitle];
        [self setImageName:aImageName];
    }
    
    return self;
}

-(void)dealloc
{
    self.title = nil;
    self.imageName = nil;
    
    [super dealloc];
}

@end


@implementation PSRSSClass

@synthesize title,author,imageURL,link,pubDate;

-(id)initWithTitle:(NSString *)aTitle
            Author:(NSString *)aAuthor
          ImageURL:(NSString *)aImageURL
              Link:(NSString *)aLink
           PubDate:(NSString *)aPubDate
{
    self = [super init];
    if (self) {
        [self setTitle:aTitle];
        [self setAuthor:aAuthor];
        [self setImageURL:aImageURL];
        [self setLink:aLink];
        [self setPubDate:aPubDate];
    }
    
    return self;
}

-(void)dealloc
{
    self.title = nil;
    self.author = nil;
    self.imageURL = nil;
    self.link = nil;
    self.pubDate = nil;
    
    [super dealloc];
}

@end

@implementation PSDoas

@synthesize arabic, indo, spell, surah, title;

-(void)dealloc
{
    self.arabic = nil;
    self.indo = nil;
    self.spell = nil;
    self.surah = nil;
    self.title = nil;
    
    [super dealloc];
}

@end