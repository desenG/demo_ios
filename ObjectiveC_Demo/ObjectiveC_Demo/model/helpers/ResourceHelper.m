//
//  ResourceHelper.m
//
//  Created by DesenGuo on 2016-01-22.
//  Copyright © 2016 DIVE Communications Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceHelper.h"

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@implementation ResourceHelper
{
}
+(UIImage *)getUIImageByName:(NSString *)imageName
{
    UIImage * theImage;
    CGRect bounds;
    bounds = [UIScreen mainScreen].bounds;
    int height = (int)bounds.size.height ;
    @try {
        switch (height) {
            case 480:
            {
                theImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@_iphone4",imageName]];
                break;
            }
            case 568:
            {
                theImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@_iphone5",imageName]];
                break;
            }
            case 667:
            {
                theImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@_iphone6",imageName]];
                break;
            }
            case 736:
            {
                theImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@_iphone6plus",imageName]];
                break;
            }
            case 1024:
            {
                theImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@_ipad",imageName]];
                break;
            }
            case 2048:
            {
                theImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@_ipad2",imageName]];
                
                break;
            }
            default:
                theImage=[UIImage imageNamed:imageName];
                break;
        }
        
    }
    @catch (NSException * e) {
        theImage=[UIImage imageNamed:imageName];
    }
    

    return theImage;
}
+(UIColor *)getUIColorFromHex:(int) hexValue
{
    return UIColorFromRGB(hexValue);
}
+(UIColor *)getUIColorFromHex:(int) hexValue
                    withAlpha:(float) alpha
{
    return UIColorFromRGBWithAlpha(hexValue,alpha);
}

+ (NSMutableDictionary *)getContactFromAddressBook:(ABAddressBookRef)addressBook
                                           byEmail:(NSString*) p_email
{
    NSArray *allData = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger contactCount = [allData count];
    NSMutableDictionary *dictionary = nil;
    
    for (int i = 0; i < contactCount; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex((__bridge CFArrayRef)allData, i);
        // get all email associated with this person
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty) ;
        
        CFIndex emailCount = ABMultiValueGetCount(emails);
        
        if (emailCount <= 0) {
            continue;
        }
        
        for (int j = 0; j < emailCount; j++) {
            NSString *email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, j));
            if([email isEqualToString:p_email])
            {
                dictionary = [NSMutableDictionary dictionary];
                dictionary[@"email"] = email;
                break;
            }
        }
        if(dictionary)
        {
            NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
            
            if (firstName) {
                dictionary[@"firstName"] = firstName;
            }
            if (lastName) {
                dictionary[@"lastName"]  = lastName;
            }
            break;
        }
    }
    return dictionary;
}

+(NSString*)extractNumberFromString:(NSString*)originalString
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[originalString componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

+(BOOL)isNumeric:(NSString*)inputString
{
    if(!inputString || inputString.length==0)
    {
        return NO;
    }
    //check string only contains digit 0-9
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

+ (BOOL) isValidateEmail: (NSString *) candidate {
    if(!candidate || candidate.length==0)
    {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

#pragma - addressbook resource
+(void)askPermissionForAddressBook
{
    if([[AccountInfoCache new] getisAddressBookPermissionGranted])
    {
        return;
    }
    
    CFErrorRef  error;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,&error);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if(granted)
        {
            NSLog(@"User Grant permission to his address book.");
            [[AccountInfoCache new] saveisAddressBookPermissionGranted:granted];
            [ResourceHelper updateRuntimeAddressBook];
        }
    });
    
}

+(void)updateRuntimeAddressBook
{
    if(![[AccountInfoCache new] getisAddressBookPermissionGranted])
    {
        return;
    }
    CFErrorRef  error;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,&error);
    [RuntimeDataStorage contactsFromAddressBook: [ResourceHelper getContactsFromAddressbook:addressBook]];
}

+(NSMutableArray*)getContactsFromAddressbook:(ABAddressBookRef)m_addressbook
{
    NSLog(@"getContactsFromAddressbook");
    NSMutableArray *arrayContacts;
    @try{
        arrayContacts = [[NSMutableArray alloc] init];
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
        CFIndex nPeople = ABAddressBookGetPersonCount(m_addressbook);
        for (int i=0;i < nPeople;i++)
        {
            Contact *contact =[[Contact alloc] init];
            
            ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
            
            //fetch name
            CFStringRef firstName, lastName;
            firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
            NSString *fname =(__bridge NSString *)(firstName);
            if (fname.length == 0)
            {
                fname = @"";
            }
            NSString *Lname =(__bridge NSString *)(lastName);
            if (Lname.length == 0)
            {
                Lname = fname;
                fname = @"";
            }
            
            // If email is set Create a contact with email address
            NSString *strEmail;
            ABMultiValueRef email = ABRecordCopyValue(ref, kABPersonEmailProperty);
            CFStringRef tempEmailref;
            if (ABMultiValueGetCount(email) > 0)
            {
                tempEmailref = ABMultiValueCopyValueAtIndex(email, 0);
                strEmail = (__bridge  NSString *)tempEmailref;
                contact.firstname = fname;
                contact.lastname = Lname;
                contact.email = strEmail;
                contact.ischeckd = @"no";
                contact.smsNumber = @"";
                CFRelease(tempEmailref);
                [arrayContacts addObject:contact];
            }
            
            // If Phone number is set Create a contact with the phone number
            NSString *strPhone;
            ABMultiValueRef phone = ABRecordCopyValue(ref, kABPersonPhoneProperty);
            CFStringRef phoneNumberRef;
            if (ABMultiValueGetCount(phone) > 0)
            {
                phoneNumberRef = ABMultiValueCopyValueAtIndex(phone, 0);
                strPhone = (__bridge  NSString *)phoneNumberRef;
                contact.firstname = fname;
                contact.lastname = Lname;
                contact.email = @"";
                contact.smsNumber = [ResourceHelper extractNumberFromString:strPhone];
                contact.ischeckd=@"no";
                CFRelease(phoneNumberRef);
                [arrayContacts addObject:contact];
            }
        }
        
        CFRelease(m_addressbook);
        CFRelease(allPeople);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    return arrayContacts;
}

+ (NSMutableDictionary *)getContactFromAddressBook:(ABAddressBookRef)addressBook
                                     byPhoneNumber:(NSString*) phonenumber
{
    phonenumber=[ResourceHelper extractNumberFromString:phonenumber];
    NSArray *allData = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger contactCount = [allData count];
    NSMutableDictionary *dictionary = nil;
    
    for (int i = 0; i < contactCount; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex((__bridge CFArrayRef)allData, i);
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneNumberCount = ABMultiValueGetCount(phones);
        
        if (phoneNumberCount <= 0) {
            continue;
        }
        
        for (int j = 0; j < phoneNumberCount; j++) {
            NSString *phone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j));
            phone=[ResourceHelper extractNumberFromString:phone];
            if([phone isEqualToString:phonenumber] || [phone isEqualToString:[NSString stringWithFormat:@"1%@", phonenumber]])
            {
                dictionary = [NSMutableDictionary dictionary];
                dictionary[@"phone"] = phone;
                break;
            }
        }
        if(dictionary)
        {
            NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
            
            if (firstName) {
                dictionary[@"firstName"] = firstName;
            }
            if (lastName) {
                dictionary[@"lastName"]  = lastName;
            }
            break;
        }
    }
    return dictionary;
}
@end