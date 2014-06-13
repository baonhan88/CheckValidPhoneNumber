//
//  PNViewController.m
//  CheckValidPhoneNumber
//
//  Created by NhanB on 6/12/14.
//  Copyright (c) 2014 NhanB. All rights reserved.
//

#import "PNViewController.h"
#import "NBPhoneNumberUtil.h"

@interface PNViewController ()

@property (strong, nonatomic) IBOutlet CountryPicker *countryPicker;

@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UILabel *checkValidLabel;

@end

@implementation PNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _countryPicker.delegate = self;
    _phoneNumberTextField.delegate = self;
    
    // init phone number text field
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneNumberTextField becomeFirstResponder];
    [_phoneNumberTextField addTarget:self
                              action:@selector(textFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Methods

- (void)validatePhoneNumber:(NSString *)phoneNumber {
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    
    NSError *aError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:phoneNumber
                                 defaultRegion:_countryPicker.selectedCountryCode error:&aError];
    
    if (aError == nil) {
        if ([phoneUtil isValidNumber:myNumber]) {
            _checkValidLabel.text = @"Phone number correct";
            _checkValidLabel.textColor = [UIColor greenColor];
        } else {
            _checkValidLabel.text = @"Phone number incorrect, please choose another one";
            _checkValidLabel.textColor = [UIColor redColor];
        }
    } else {
        DLog(@"Error : %@", [aError localizedDescription]);
    }
}

#pragma mark - CountryPickerDelegate 

- (void)countryPicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code {
    DLog(@"didSelectCountryWithName [%@] code [%@]", name, code);
}

#pragma mark - Events

- (void)textFieldDidChange:(id)sender {
    UITextField *textField = (UITextField *)sender;
    
    [self validatePhoneNumber:textField.text];
}

@end
