//
//  AutoLoginController.m
//  interview_basic
//
//  Created by 김규완 on 13. 9. 27..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "AutoLoginController.h"

#import "Utils.h"
#import "LoginProperties.h"
#import "HttpManager.h"
#import "AlertUtils.h"
#import "ProgressIndicator.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"

@interface AutoLoginController () <HttpManagerDelegate>

@property (nonatomic, retain) ProgressIndicator *spinner;
@property (nonatomic, retain) LoginProperties *loginProperties;
@property (nonatomic, assign) BOOL isAutoLogin;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation AutoLoginController

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
    
    [self.activity startAnimating];
    
    self.loginProperties = [Utils loginProperties];
    _isAutoLogin = NO;
    
    if(self.loginProperties != nil) {
        if (self.loginProperties.autoLogin) {
            
            _isAutoLogin = YES;
            
            [self loginProcess];
            
        } else {
            
            [[AppDelegate sharedAppDelegate] switchLoginView];
        }
    } else {
        [[AppDelegate sharedAppDelegate] switchLoginView];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.spinner = nil;
    self.loginProperties = nil;
}

- (void)dealloc {
    [super dealloc];
}


- (void)loginProcess {
    NSString *password = [[[AppDelegate sharedAppDelegate] passwordWrapper] objectForKey:kSecAttrAccount];
    
    _spinner = [[ProgressIndicator alloc] initWithLabel:@"로그인중..."];
	[_spinner show];
    
    HttpManager *manager = [HttpManager sharedManager];
    manager.delegate = self;
    NSLog(@"userID=%@ password=%@", _loginProperties.userID, password);
    [manager login:_loginProperties.userID password:password];
}

- (void)loginResult:(id)JSON {
    NSLog(@"loginResult %@", [JSON valueForKeyPath:@"result"]);
    [_spinner dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *result = [JSON valueForKeyPath:@"result"];
    if ([result isEqualToString:@"success"]) {
        
        int userNo = [[NSString stringWithFormat:@"%@",[JSON valueForKeyPath:@"userNo"]] intValue];
        
        NSLog(@"cookies userID=%@", [Utils cookieValue:@"userID"]);
        
        //int userRole = [[NSString stringWithFormat:@"%@",[jsonData valueForKey:@"userRole"]] intValue];
        int userRole = (int)[JSON valueForKeyPath:@"userRole"];
        NSLog(@"userRole : %d", userRole);
        [[AppDelegate sharedAppDelegate] setIsAuthenticated:YES];
        [[AppDelegate sharedAppDelegate] setAuthGroup:userRole];
        [[AppDelegate sharedAppDelegate] setAuthUserID:self.loginProperties.userID];
        [[AppDelegate sharedAppDelegate] setAuthUserNo:userNo];
        
        [[AppDelegate sharedAppDelegate] switchMainView];
    } else {
        AlertWithMessage([JSON valueForKeyPath:@"message"]);
        [[AppDelegate sharedAppDelegate] switchLoginView];
    }
    
    
}


@end
