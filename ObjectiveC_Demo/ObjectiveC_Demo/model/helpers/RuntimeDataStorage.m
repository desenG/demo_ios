//
//  RuntimeDataStorage.m


#import <Foundation/Foundation.h>
#import "RuntimeDataStorage.h"
static RuntimeDataStorage *_sharedInstance;

static NSMutableArray *contactsFromAddressBook;

@implementation RuntimeDataStorage
{

}

+(NSMutableArray *) contactsFromAddressBook
{
    return contactsFromAddressBook;
}

+(void) contactsFromAddressBook: (NSMutableArray *) value
{
    contactsFromAddressBook=[value copy];
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [RuntimeDataStorage new];
    });
    return _sharedInstance;
}
@end