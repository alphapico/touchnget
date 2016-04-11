//
//  HSTimeIntervalFormatter.h
//  FoodTracer
//
//  Created by Muhamad Hisham Wahab on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSTimeIntervalFormatter : NSFormatter{
@private
    NSLocale *_locale;
    NSString *_pastDeicticExpression;
    NSString *_presentDeicticExpression;
    NSString *_futureDeicticExpression;
    NSString *_deicticExpressionFormat;
    NSString *_approximateQualifierFormat;
    NSTimeInterval _presentTimeIntervalMargin;
    BOOL _usesAbbreviatedCalendarUnits;
    BOOL _usesApproximateQualifier;
    BOOL _usesIdiomaticDeicticExpressions;
}

+ (NSLocale *) currentLocale;

- (NSString *)stringForTimeInterval:(NSTimeInterval)seconds;
- (NSString *)stringForTimeIntervalFromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate;

- (NSLocale *)locale;
- (void)setLocale:(NSLocale *)locale;

- (NSString *)pastDeicticExpression;
- (void)setPastDeicticExpression:(NSString *)pastDeicticExpression;

- (NSString *)presentDeicticExpression;
- (void)setPresentDeicticExpression:(NSString *)presentDeicticExpression;

- (NSString *)futureDeicticExpression;
- (void)setFutureDeicticExpression:(NSString *)futureDeicticExpression;

- (NSString *)deicticExpressionFormat;
- (void)setDeicticExpressionFormat:(NSString *)deicticExpressionFormat;

- (NSString *)approximateQualifierFormat;
- (void)setApproximateQualifierFormat:(NSString *)approximateQualifierFormat;

- (NSTimeInterval)presentTimeIntervalMargin;
- (void)setPresentTimeIntervalMargin:(NSTimeInterval)presentTimeIntervalMargin;

- (BOOL)usesAbbreviatedCalendarUnits;
- (void)setUsesAbbreviatedCalendarUnits:(BOOL)usesAbbreviatedCalendarUnits;

- (BOOL)usesApproximateQualifier;
- (void)setUsesApproximateQualifier:(BOOL)usesApproximateQualifier;

- (BOOL)usesIdiomaticDeicticExpressions;
- (void)setUsesIdiomaticDeicticExpressions:(BOOL)usesIdiomaticDeicticExpressions;


@end
