//
//  PSWebClient.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 2/19/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSWebClient.h"
#import "AFHTTPRequestOperation.h"
#import "PSCommonCode.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"

extern NSString *const gWebBaseURL;

@implementation PSWebClient

+(PSWebClient *)sharedClient
{
    static PSWebClient * _sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:gWebBaseURL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    //http://en.wikipedia.org/wiki/List_of_HTTP_header_fields
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    
    [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [self setParameterEncoding:AFFormURLParameterEncoding];
    [self setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    return self;
}

-(void)demapClass:(id)classObj withDictionary:(NSMutableDictionary *)muteDictionary
{
    //[self classDumpWithClassObject:classObj];
    
    const char* className = class_getName([classObj class]);
    id YourClass = objc_getClass(className);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(YourClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        SEL propertySelector = NSSelectorFromString(propertyName);
        if ([classObj respondsToSelector:propertySelector]) {
            if ([muteDictionary objectForKey:propertyName]) {
                
                SEL aSetter = [classObj setterForPropertyNamed:propertyName];
                //const char* methodName = sel_getName(aSetter);
                //NSLog(@"%@ responds to %s", classObj, methodName);
                
                //[classObj setValue:[muteDictionary valueForKey:propertyName] forKey:propertyName]; //KVC
                [classObj performSelector:aSetter withObject:[muteDictionary objectForKey:propertyName]];
                
            }
        }
    }
}

-(NSMutableDictionary *)mapClass:(id)classObj
{
    NSMutableDictionary *muteDictionary = [[NSMutableDictionary alloc] init];
    
    const char* className = class_getName([classObj class]);
    id YourClass = objc_getClass(className);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(YourClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        SEL propertySelector = NSSelectorFromString(propertyName);
        if ([classObj respondsToSelector:propertySelector]) {
            [muteDictionary setValue:[classObj performSelector:propertySelector] forKey:propertyName];
        }
    }
    
    return [muteDictionary autorelease];
}

@end
