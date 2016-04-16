//
//  Alert.h
//
//  Created by DesenGuo on 2016-01-27.
//

#ifndef Alert_h
#define Alert_h

@interface Alert : NSObject
+(void)showMessageAlertOnCurrentViewController:(UIViewController *) currentViewController
                                     withTitle: (NSString*) title
                                    andMessage: (NSString*) message
                             cancelButtonTitle:(NSString*) buttonText;
+(void)showDialogOnCurrentViewController:(UIViewController *) currentViewController
                               withTitle: (NSString*) title
                              andMessage: (NSString*) message
                       cancelButtonTitle:(NSString*) cancelbuttonText
                      executeButtonTitle:(NSString*) executebuttonText
                      executeButtonClick:(void (^)(void))executeBlock;
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message;
@end

#endif /* Alert_h */
