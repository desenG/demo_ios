//
//  NSString+URLEncoding.m
//  VideoAppPrototype
//
//  Created by Antonio Atamosa Jr. on 7/15/13.
//  Copyright (c) 2013 JayR. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                             (CFStringRef)self,
                                                             NULL,
                                                             (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                             CFStringConvertNSStringEncodingToEncoding(encoding)));
}

@end
