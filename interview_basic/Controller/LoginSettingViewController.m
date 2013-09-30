//
//  LoginSettingViewController.m
//  interview_basic
//
//  Created by 김규완 on 13. 9. 30..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "LoginSettingViewController.h"

@interface LoginSettingViewController ()

@property (nonatomic, retain) IBOutlet UIButton *logoutButton;
@property (nonatomic, retain) IBOutlet UIButton *pwChangeButton;
@property (nonatomic, retain) IBOutlet UILabel *userIDLabel;
@property (nonatomic, retain) IBOutlet UITextField *cPasswdField;
@property (nonatomic, retain) IBOutlet UITextField *nPasswdField;
@property (nonatomic, retain) IBOutlet UITextField *nPasswdConfirmField;

- (IBAction)logout:(id)sender;
- (IBAction)changePassword:(id)sender;

@end

@implementation LoginSettingViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"로그인설정";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.logoutButton = nil;
    self.pwChangeButton = nil;
    self.userIDLabel = nil;
    self.cPasswdField = nil;
    self.nPasswdField = nil;
    self.nPasswdConfirmField = nil;
}

- (IBAction)logout:(id)sender {
    
}

- (IBAction)changePassword:(id)sender {
    
}

@end
