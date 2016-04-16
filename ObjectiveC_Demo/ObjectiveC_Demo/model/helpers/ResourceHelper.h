//
//  ResourceHelper.h
//

#import <AddressBook/AddressBook.h>
#import "RuntimeDataStorage.h"
#import "Contact.h"

#ifndef ResourceHelper_h
#define ResourceHelper_h


#endif /* ResourceHelper_h */
@interface ResourceHelper: NSObject
{
    
}
+(UIImage *)getUIImageByName:(NSString *)imageName;
+(UIColor *)getUIColorFromHex:(int) hexValue;
+(NSString*) getFNameByPhoneNumber:(NSString*)phoneNumber;
+(NSString*) getFNameByEmail:(NSString*)email;
+(NSString*) getFNameFromRuntimeAdressBook:(NSMutableArray*) addressBook
                             ByPhoneNumber:(NSString*)phoneNumber;
+(NSString*) getFNameFromRuntimeAdressBook:(NSMutableArray*) runtimeAddressBook
                                   ByEmail:(NSString*)email;
#pragma - addressbook resource
+(void)askPermissionForAddressBook;

+(void)updateRuntimeAddressBook;

+(NSMutableArray*)getContactsFromAddressbook:(ABAddressBookRef)m_addressbook;
@end