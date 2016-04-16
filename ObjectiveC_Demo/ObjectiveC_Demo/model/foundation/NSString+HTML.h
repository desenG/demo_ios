//
//  NSString+HTML.h
//  VideoAppPrototype
//
//  Created by Antonio Atamosa Jr. on 7/15/13.
//  Copyright (c) 2013 JayR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSString (HTMLExtensions)

+ (NSDictionary *)htmlEscapes;
+ (NSDictionary *)htmlUnescapes;

- (NSString *)htmlEscapedString;
- (NSString *)htmlUnescapedString;
- (NSString *)urlencode;
- (NSString *)stringByStrippingHTML;

@end

