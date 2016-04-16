//
//  NSString+Type.m
//
//  Created by DesenGuo on 2016-02-23.
//

#import <Foundation/Foundation.h>
#import "NSString+Type.h"
@implementation NSString (Type)
- (BOOL) isAlphaNumeric
{
    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound);
}

-(BOOL) isValidEmail
{
    @try{
        BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:self];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}

-(BOOL)isValidPhone
{
    NSString *phoneRegex = @"[235689][0-9]{6}([0-9]{3})?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [test evaluateWithObject:self];
}
@end