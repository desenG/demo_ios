//
//  Alert.m
//
//  Created by DesenGuo on 2016-01-27.
//

#import <Foundation/Foundation.h>
#import "Alert.h"
@implementation Alert


+(void)showMessageAlertOnCurrentViewController:(UIViewController *) currentViewController
                                     withTitle: (NSString*) title
                                    andMessage: (NSString*) message
                             cancelButtonTitle:(NSString*) buttonText
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:buttonText
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:cancel];
    [currentViewController presentViewController:alert animated:YES completion:nil];
    
}
+(void)showDialogOnCurrentViewController:(UIViewController *) currentViewController
                               withTitle: (NSString*) title
                              andMessage: (NSString*) message
                       cancelButtonTitle:(NSString*) cancelbuttonText
                      executeButtonTitle:(NSString*) executebuttonText
                      executeButtonClick:(void (^)(void))executeBlock
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* execute = [UIAlertAction
                              actionWithTitle:executebuttonText
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                  executeBlock();
                              }];
    if(nil!=cancelbuttonText)
    {
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:cancelbuttonText
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:cancel];
    }
    [alert addAction:execute];
    [currentViewController presentViewController:alert animated:YES completion:nil];
}

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:okAction];
    return alertController;
}
@end