//
//  FBContact.m
//
//  Created by HInal Shah on 2015-08-24.
//

#import "FBContact.h"

#define FBCONTACT_NAME @"name"
#define FBCONTACT_EMAIL @"email"
#define FBCONTACT_ISSELECTED @"isSelected"
#define FBCONTACT_ID @"id"


@implementation FBContact
@synthesize name,email,isSelected,id;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    FBContact *item = [[FBContact alloc] init];
    item.name = [aDecoder decodeObjectOfClass:[NSString class] forKey:FBCONTACT_NAME];
    item.email = [aDecoder decodeObjectOfClass:[NSString class] forKey:FBCONTACT_EMAIL];
    item.isSelected = [aDecoder decodeObjectOfClass:[NSString class] forKey:FBCONTACT_ISSELECTED];
    item.id = [aDecoder decodeObjectOfClass:[NSString class] forKey:FBCONTACT_ID];
    
    return item;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:FBCONTACT_NAME];
    [aCoder encodeObject:self.email forKey:FBCONTACT_EMAIL];
    [aCoder encodeObject:self.isSelected forKey:FBCONTACT_ISSELECTED];
    [aCoder encodeObject:self.id forKey:FBCONTACT_ID];
}

@end
