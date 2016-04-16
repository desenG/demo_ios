//
//  RegisterViewController.h
//  Mimcoups
//
//  Created by z0415 on 05/03/14.
//  Copyright (c) 2014 z0415. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardHelper.h"
#import "MediaPicker.h"
#import "JGActionSheet.h"
#import "AssetsEditor.h"
#import "ProfileHelper.h"

@interface RegisterViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scroller;
	
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtdob;
    
    IBOutlet UIButton *btnMale;
    IBOutlet UIButton *btnFemale;
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtUsername;
    IBOutlet UITextField *txtPassword;
    
    IBOutlet UITextField *txtlanguage;
    IBOutlet UIDatePicker *datepicker;
    IBOutlet UIPickerView *languagePicker;
    
    NSArray *languageArray;
    //Toolbar and its items
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *btnPrevious;
    IBOutlet UIBarButtonItem *btnNext;
    IBOutlet UIBarButtonItem *btnDone;
    
    
}




@end
