//
//  ViewController.m
//  AuthTstUtility
//
//  Created by BjornC on 10/1/14.
//  Copyright (c) 2014 Builtlight. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthNetworking.h"
#import "SuccessViewController.h"


@interface LoginViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic,strong) AuthNetworking *authNetworking;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.submitButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.submitButton.layer.borderWidth = 1.0f;
    self.submitButton.layer.cornerRadius = 4.0f;
    
    self.authNetworking = [[AuthNetworking alloc] init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"LoginSuccess"]) {
        SuccessViewController *successVC = (SuccessViewController *)segue.destinationViewController;
        successVC.token = self.authNetworking.authToken;
        [self clearTextFields];
    }
}

#pragma mark - Actions

- (IBAction)submitAction:(id)sender {
    
    [self.activityIndicator startAnimating];
    [self.authNetworking requestAuthTokenForUser:self.usernameField.text
                                      withPasswd:self.passwordField.text
                              andCompletionBlock:^{
                                  [self.activityIndicator stopAnimating];
                                  [self handleAuthResponse];
                              }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private

- (void)handleAuthResponse {
    
    if (self.authNetworking.authToken) {
        [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
    } else {
        [self showErrorAlert];
    }
}

- (void)clearTextFields {
    self.usernameField.text = nil;
    self.passwordField.text = nil;
}

- (void)showErrorAlert {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Your CoPatient username or password is incorrect"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self clearTextFields];
}

@end
