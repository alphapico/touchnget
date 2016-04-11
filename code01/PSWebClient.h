//
//  PSWebClient.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 2/19/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "AFHTTPClient.h"

@interface PSWebClient : AFHTTPClient{

}

+(PSWebClient *)sharedClient;

-(NSMutableDictionary *)mapClass:(id)classObj;
-(void)demapClass:(id)classObj withDictionary:(NSMutableDictionary *)muteDictionary;

@end
