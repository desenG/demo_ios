//
//  RegisterViewController.m
//  Mimcoups
//
//  Created by z0415 on 05/03/14.
//  Copyright (c) 2014 z0415. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    KeyboardHelper* keyboardHelper;
    MediaPicker* imagePicker;
    JGActionSheet *addPotoMenuSheet;
    __weak RegisterViewController* weakSelf;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    weakSelf=self;
	[scroller setContentSize:CGSizeMake(320, 670)];
	[self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
	
    languageArray = [[NSArray alloc] initWithObjects:@"English",@"Danish",@"Swedish",@"Norwegian", nil];
    
	languagePicker.showsSelectionIndicator = TRUE;
	languagePicker.dataSource = self;
	languagePicker.delegate = self;
	
	 [datepicker addTarget:self
								   action:@selector(selectdate:)
						 forControlEvents:UIControlEventValueChanged];
    keyboardHelper=[KeyboardHelper new];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
    
    scroller.delegate = self;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation");
    //    if (aRefreshInProgress) aRefreshInProgress = NO;
}

-(void)dismissKeyboard
{
    [[self view] endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [keyboardHelper addKeyboardShowAndHideObserverToViewController:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [keyboardHelper removeKeyboardShowAndHideObserver];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	 [textField setInputAccessoryView:toolbar];

	btnNext.enabled = YES;
	btnPrevious.enabled = YES;
	if ([txtName isEditing])
	{
		btnNext.enabled = YES;
		btnPrevious.enabled = NO;
	}
	else if ([txtdob isEditing])
	{
		datepicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = datepicker;
        if([txtdob.text isEqualToString:@""])
        {
            
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			
			[dateFormatter setDateFormat:@"MM/dd/YYYY "];
			
			NSDate *date = [datepicker date];
			
			NSString *formattedDateString = [dateFormatter stringFromDate:date];
			
			txtdob.text = formattedDateString;
            
        }

	}
	else if ([txtlanguage isEditing])
	{
		if([txtlanguage.text isEqualToString:@""])
        {
			txtlanguage.text = [languageArray objectAtIndex:0];
		}
		textField.inputView = languagePicker;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
    // Dispose of any resources that can be recreated.
}
#pragma mark - Button onClick
- (IBAction)btnBackOnclick:(id)sender
{
   [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)selectdate:(id)sender
{
    if([txtdob isEditing])
    {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"MM/dd/YYYY "];
        
        NSDate *date = [datepicker date];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        
        txtdob.text = formattedDateString;
    }
    
}

- (IBAction)btnAddPhotoOnclick:(id)sender
{
    [self dismissKeyboard];
    // iOS 8+
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Take Photo", @"Use Existing"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];
    
    NSArray *sections = @[section1, cancelSection];
    
    addPotoMenuSheet = [JGActionSheet actionSheetWithSections:sections];
    
    [addPotoMenuSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
        if(indexPath.section==1)
        {
            return;
        }
        switch(indexPath.row) {
                
                // Take Photo
            case 0:
            {
                imagePicker=[MediaPicker new];
                [imagePicker loadAssetFromViewController:weakSelf WithAssetType:(NSString*)kUTTypeImage andUIImagePickerControllerSourceType:UIImagePickerControllerSourceTypeCamera andGetDataCompletitionBlock:^(id obj, NSError *err) {
                    ProfileHelper * profileHelper = [ProfileHelper new];
                    UIImage* img=(UIImage*)obj;
                    if (img) {
                        NSData *pngImageData = UIImagePNGRepresentation(img);
                        
                        if(pngImageData) {
                            if([profileHelper saveProfileImageAsTempFile:pngImageData]) {
                                [(UIButton*)sender setImage:img forState:UIControlStateNormal];
                            }
                        }
                    }
                }];
            }
            break;
                
                // Select Photo
            case 1:
            {
                imagePicker=[MediaPicker new];
                [imagePicker loadAssetFromViewController:weakSelf WithAssetType:(NSString*)kUTTypeImage andUIImagePickerControllerSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum andGetDataCompletitionBlock:^(id obj, NSError *err) {
                    ProfileHelper * profileHelper = [ProfileHelper new];
                    UIImage* img=(UIImage*)obj;
                    if (img) {
                        NSData *pngImageData = UIImagePNGRepresentation(img);
                        
                        if(pngImageData) {
                            if([profileHelper saveProfileImageAsTempFile:pngImageData]) {
                                [(UIButton*)sender setImage:img forState:UIControlStateNormal];
                            }
                        }
                    }
                }];
            }
                break;
                
            default:
                break;
        }
    }];
    
    [addPotoMenuSheet showInView:self.view animated:YES];
}

- (IBAction)btnRegisterOnclick:(id)sender
{
}


#pragma mark - uipickerview methods
#pragma mark - UIPickerView Delegate and Data source methos
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return languageArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return languageArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [txtlanguage setText:languageArray[row]];
}

#pragma mark - toolbar method
- (IBAction)btnPreviousOnclick:(id)sender
{
	if (txtlanguage.isFirstResponder)
	{
		[txtPassword becomeFirstResponder];
	}
	else if (txtPassword.isFirstResponder)
	{
		[txtUsername becomeFirstResponder];
	}
	else if (txtUsername.isFirstResponder)
	{
		[txtEmail becomeFirstResponder];
	}
	else if (txtEmail.isFirstResponder)
	{
		[txtdob becomeFirstResponder];
	}
	else if (txtdob.isFirstResponder)
	{
		[txtName becomeFirstResponder];
	}
}

- (IBAction)btnNextOnClick:(id)sender
{
	if (txtName.isFirstResponder)
	{
		[txtdob becomeFirstResponder];
		
	}
	else if (txtdob.isFirstResponder)
	{
		[txtEmail becomeFirstResponder];
		
	}
	else if (txtEmail.isFirstResponder)
	{
		[txtUsername becomeFirstResponder];
		
	}
	else if (txtUsername.isFirstResponder)
	{
		[txtPassword becomeFirstResponder];
		
	}
	else if (txtPassword.isFirstResponder)
	{
		[txtlanguage becomeFirstResponder];
		
	}
}

- (IBAction)btnDoneOnclick:(id)sender
{
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
