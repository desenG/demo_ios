//
//  NSString+RemoveLetters.m
//
//

#import "NSString+RemoveLetters.h"

@implementation NSString (RemoveLetters)
- (NSString *)removeLetters {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet symbolCharacterSet];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Build array of components using specified characters as separtors
    NSArray *arrayOfComponents = [self componentsSeparatedByCharactersInSet:characterSet];
    
    // Create string from the array components
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    return strOutput;
}
@end
