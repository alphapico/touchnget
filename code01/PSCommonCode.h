//
//  PSCommonCode.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 2/19/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTagNoInternetView 301

typedef enum RSSType{
    RSSGeneral,
    RSSInclude,
    RSSMalaysiakini,
} RSSType;

typedef enum WebType{
    WebFromFile,
    WebFromServer,
}WebType;

@interface PSCommonCode : NSObject{

}

+(NSString *)requestDeviceID;


@end


@interface PSSubMenuClass : NSObject{
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;

-(id)initWithTitle:(NSString *)aTitle; //TEST
-(id)initWithTitle:(NSString *)aTitle andImageName:(NSString *)aImageName;

@end


@interface PSRSSClass : NSObject{

}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *pubDate;

@end

//Doa from JSON file
@interface PSDoas : NSObject{

}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *arabic;
@property (nonatomic, copy) NSString *spell;
@property (nonatomic, copy) NSString *indo;
@property (nonatomic, copy) NSString *surah;
@end
