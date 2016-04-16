//
//  NSString+HTML.m
//  VideoAppPrototype
//
//  Created by Antonio Atamosa Jr. on 7/15/13.
//  Copyright (c) 2013 JayR. All rights reserved.
//

#import "NSString+HTML.h"


@implementation NSString (HTMLExtensions)

static NSDictionary *htmlEscapes = nil;
static NSDictionary *htmlUnescapes = nil;

+ (NSDictionary *)htmlEscapes
{
  if (!htmlEscapes)
  {
    htmlEscapes = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"&amp;", @"&",
                   @"&lt;", @"<",
                   @"&gt;", @">",
                   nil
                   ];
  }
  return htmlEscapes;
}

+ (NSDictionary *)htmlUnescapes
{
  if (!htmlUnescapes)
  {
    htmlUnescapes = [[NSDictionary alloc] initWithObjectsAndKeys:
                     @"&", @"&amp;",
                     @"<", @"&lt;",
                     @">", @"&gt;",
                     @" ", @"%20",
                     nil
                     ];
  }
  return htmlEscapes;
}

static NSString *replaceAll(NSString *s, NSDictionary *replacements)
{
  for (NSString *key in replacements)
  {
    NSString *replacement = [replacements objectForKey:key];
    s = [s stringByReplacingOccurrencesOfString:key withString:replacement];
  }
  return s;
}

- (NSString *)htmlEscapedString
{
  return replaceAll(self, [[self class] htmlEscapes]);
}

- (NSString *)htmlUnescapedString
{
  return replaceAll(self, [[self class] htmlUnescapes]);
}

- (NSString *)urlencode
{
  NSMutableString *output = [NSMutableString string];
  const unsigned char *source = (const unsigned char *)[self UTF8String];
  int sourceLen = strlen((const char *)source);
  for (int i = 0; i < sourceLen; ++i)
  {
    const unsigned char thisChar = source[i];
    if (thisChar == ' ')
    {
      [output appendString:@"+"];
    }
    else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
               (thisChar >= 'a' && thisChar <= 'z') ||
               (thisChar >= 'A' && thisChar <= 'Z') ||
               (thisChar >= '0' && thisChar <= '9'))
    {
      [output appendFormat:@"%c", thisChar];
    }
    else
    {
      [output appendFormat:@"%%%02X", thisChar];
    }
  }
  return output;
}

- (NSString *)stringByStrippingHTML
{
  NSRange r;
  NSString *s = [self copy];
  while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
  {
    s = [s stringByReplacingCharactersInRange:r withString:@""];
  }
  
  return s;
}

@end
