//
//  NSDateFormatter+Convert.h
//
//


@interface NSDateFormatter (Convert)
+ (NSString *)dateStringFromString:(NSString *)sourceString
                      sourceFormat:(NSString *)sourceFormat
                 destinationFormat:(NSString *)destinationFormat;
@end
