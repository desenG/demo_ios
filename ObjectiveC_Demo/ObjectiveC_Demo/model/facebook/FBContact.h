//
//  FBContact.h
//
//  Created by HInal Shah on 2015-08-24.
//

#import <Foundation/Foundation.h>

@interface FBContact : NSObject<NSSecureCoding>
@property (nonatomic,strong) NSString *isSelected;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *name;
@end
