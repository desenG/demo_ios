//
//  RuntimeDataStorage.h
//

#import <AddressBook/AddressBook.h>

#ifndef RuntimeDataStorage_h
#define RuntimeDataStorage_h


#endif /* RuntimeDataStorage_h */

@interface RuntimeDataStorage: NSObject


+ (instancetype)sharedInstance;

+(NSMutableArray *) contactsFromAddressBook;

+(void) contactsFromAddressBook: (NSMutableArray *) value;

@end