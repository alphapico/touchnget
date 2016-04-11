//
//  DTCoreTextFontDescriptor.h
//  CoreTextExtensions
//
//  Created by Oliver Drobnik on 1/26/11.
//  Copyright 2011 Drobnik.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>


@interface DTCoreTextFontDescriptor : NSObject <NSCopying, NSCoding>
{
	NSString *fontFamily;
	NSString *fontName;
	
	CGFloat pointSize;
	
	// symbolic traits
	BOOL boldTrait;
	BOOL italicTrait;
	BOOL expandedTrait;
	BOOL condensedTrait;
	BOOL monospaceTrait;
	BOOL verticalTrait;
	BOOL UIoptimizedTrait;
	
	CTFontStylisticClass stylisticClass;
    
    BOOL smallCapsFeature;
}

// generated fonts are cached
+ (NSCache *)fontCache;

// sets the font face name to use for a specific font family
+ (void)setSmallCapsFontName:(NSString *)fontName forFontFamily:(NSString *)fontFamily bold:(BOOL)bold italic:(BOOL)italic;
+ (NSString *)smallCapsFontNameforFontFamily:(NSString *)fontFamily bold:(BOOL)bold italic:(BOOL)italic;

// overriding typefaces for families
+ (void)setOverrideFontName:(NSString *)fontName forFontFamily:(NSString *)fontFamily bold:(BOOL)bold italic:(BOOL)italic;
+ (NSString *)overrideFontNameforFontFamily:(NSString *)fontFamily bold:(BOOL)bold italic:(BOOL)italic;

+ (DTCoreTextFontDescriptor *)fontDescriptorWithFontAttributes:(NSDictionary *)attributes;
+ (DTCoreTextFontDescriptor *)fontDescriptorForCTFont:(CTFontRef)ctFont;

- (id)initWithFontAttributes:(NSDictionary *)attributes;
- (id)initWithCTFontDescriptor:(CTFontDescriptorRef)ctFontDescriptor;
- (id)initWithCTFont:(CTFontRef)ctFont;

- (void)setFontAttributes:(NSDictionary *)newAttributes;

- (CTFontSymbolicTraits)symbolicTraits;
- (NSDictionary *)fontAttributes;

- (CTFontRef)newMatchingFont;

- (BOOL)supportsNativeSmallCaps;

@property (nonatomic, copy) NSString *fontFamily;
@property (nonatomic, copy) NSString *fontName;

@property (nonatomic, assign) CGFloat pointSize;

@property (nonatomic) BOOL boldTrait;
@property (nonatomic) BOOL italicTrait;
@property (nonatomic) BOOL expandedTrait;
@property (nonatomic) BOOL condensedTrait;
@property (nonatomic) BOOL monospaceTrait;
@property (nonatomic) BOOL verticalTrait;
@property (nonatomic) BOOL UIoptimizedTrait;

@property (nonatomic, assign) CTFontSymbolicTraits symbolicTraits;

@property (nonatomic) CTFontStylisticClass stylisticClass;

@property (nonatomic) BOOL smallCapsFeature;


@end