//
//  LoginViewController.m
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"
#import "LoginProperties.h"
#import "HttpManager.h"
#import "AlertUtils.h"
#import "ProgressIndicator.h"

@interface LoginViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UIView *loginBoxView;
@property (nonatomic, retain) IBOutlet UITextField *useridField;
@property (nonatomic, retain) IBOutlet UITextField *passwdField;
@property (nonatomic, retain) IBOutlet UIButton *autoLoginButton;
@property (nonatomic, retain) ProgressIndicator *spinner;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) LoginProperties *loginProperties;
@property (nonatomic, assign) BOOL isAutoLogin;
@property (nonatomic, retain) HttpManager *httpManager;

@end

@implementation LoginViewController

@synthesize loginBoxView, useridField, passwdField, autoLoginButton, loginButton, loginProperties, isAutoLogin;
@synthesize spinner;

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
    
    self.httpManager = [HttpManager sharedManager];
    self.httpManager.delegate = self;
    
    loginProperties = [Utils loginProperties];
    isAutoLogin = NO;
    
    useridField.frame =  CGRectMake(useridField.frame.origin.x, useridField.frame.origin.y, useridField.frame.size.width, 40);
    passwdField.frame =  CGRectMake(passwdField.frame.origin.x, passwdField.frame.origin.y, passwdField.frame.size.width, 40);
    
    //[self.useridField setReturnKeyType:UIReturnKeyDone];
	[self.useridField setDelegate:self];//<UITextFieldDelegate> 구현객체에서 사용
	//[self.passwdField setReturnKeyType:UIReturnKeyDone];
	[self.passwdField setDelegate:self];
    
    //로그인정보가 있으면
    if(loginProperties != nil) {
        //UserID 저장되어 있으면 셋팅
        if(![Utils isNullString:loginProperties.userID]){
           self.useridField.text = loginProperties.userID;
        }
        //자동로그인설정이면
        if (loginProperties.autoLogin) {
            NSLog(@"autologin yes");
            isAutoLogin = YES;
            [self.autoLoginButton setImage:[UIImage imageNamed:@"checkbox_on"] forState:UIControlStateNormal];
            //비밀번호 저장되어 있는지 확인
            //id passwordWrapper = [[AppDelegate sharedAppDelegate] passwordWrapper];
            //if ([passwordWrapper isKindOfClass:[NSDictionary class]]) {
            //    NSLog(@"isKindOfClass NSDictionary");
            
                if([[[AppDelegate sharedAppDelegate] passwordWrapper] objectForKey:kSecAttrAccount] != [NSNull null]){
                    NSLog(@"keychain not null");
                    NSString *password = [[[AppDelegate sharedAppDelegate] passwordWrapper] objectForKey:kSecAttrAccount];
                    //아이디 비밀번호 정상인지 확인
                    if([Utils isNullString:loginProperties.userID] || [Utils isNullString:password]) {
                        NSLog(@"userID or password nil");
                    } else {
                        //로그인 처리
                        [self.httpManager login:loginProperties.userID password:password];
                    }
                }
            //}
            
            //self.passwdField.text = password;
        }
    } else {
        loginProperties = [[LoginProperties alloc] init];
    }
    
    
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.loginButton = nil;
    self.loginBoxView = nil;
    self.useridField = nil;
    self.passwdField = nil;
    self.autoLoginButton = nil;
}

- (void)dealloc {
    [loginButton release];
    [loginBoxView release];
    [useridField release];
    [passwdField release];
    [autoLoginButton release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return NO;
}


- (NSUInteger)supportedInterfaceOrientations
{
    //return self.fullScreenVideoIsPlaying ?
    //UIInterfaceOrientationMaskAllButUpsideDown :
    //return UIInterfaceOrientationMaskPortrait;
    //return UIInterfaceOrientationMaskAllButUpsideDown;
    return 0;
}

- (IBAction)login:(id)sender {
    
    spinner = [[ProgressIndicator alloc] initWithLabel:@"로그인중..."];
	[spinner show];
    
    [useridField resignFirstResponder];
    [passwdField resignFirstResponder];
	
    if ([Utils isNullString:useridField.text]) {
        [spinner dismissWithClickedButtonIndex:0 animated:YES];
        AlertWithMessage(@"아이디를 입력해 주세요");
        return;
    }
    
    if ([Utils isNullString:passwdField.text]) {
        [spinner dismissWithClickedButtonIndex:0 animated:YES];
        AlertWithMessage(@"비밀번호를 입력해 주세요");
        return;
    }
    
    
    [self.httpManager login:useridField.text password:passwdField.text];
}

- (IBAction)toggleAutoLogin:(id)sender {
    
    if (isAutoLogin){
        isAutoLogin = NO;
        [self.autoLoginButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    } else {
        isAutoLogin = YES;
        [self.autoLoginButton setImage:[UIImage imageNamed:@"checkbox_on"] forState:UIControlStateNormal];
    }
}

- (void)loginResult:(id)JSON {
    NSLog(@"loginResult %@", [JSON valueForKeyPath:@"result"]);
    [spinner dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *result = [JSON valueForKeyPath:@"result"];
    if ([result isEqualToString:@"success"]) {
        
        int userNo = [[NSString stringWithFormat:@"%@",[JSON valueForKeyPath:@"userNo"]] intValue];
        //이제 로그인 완료 후 설정데이타 저장
		LoginProperties *loginProp = [[LoginProperties alloc] init];
		
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:useridField.text forKey:@"userID"];
        //[defaults setValue:passwdField.text forKey:@"password"];
        //keychain에 저장
        [[[AppDelegate sharedAppDelegate] passwordWrapper] setObject:passwdField.text forKey:kSecAttrAccount];
        
		[loginProp setUserID:useridField.text];
		//[loginProp setPassword:passwdField.text];
		
		if (isAutoLogin) {
			[loginProp setAutoLogin:@"YES"];
		} else {
			[loginProp setAutoLogin:@"NO"];
		}
		
        //로그인 설정 저장
		[Utils saveLoginProperties:loginProp];
        
        NSLog(@"cookies userID=%@", [Utils cookieValue:@"userID"]);
        
        //int userRole = [[NSString stringWithFormat:@"%@",[jsonData valueForKey:@"userRole"]] intValue];
        int userRole = (int)[JSON valueForKeyPath:@"userRole"];
        NSLog(@"userRole : %d", userRole);
        [[AppDelegate sharedAppDelegate] setIsAuthenticated:YES];
        [[AppDelegate sharedAppDelegate] setAuthGroup:userRole];
        [[AppDelegate sharedAppDelegate] setAuthUserID:useridField.text];
        [[AppDelegate sharedAppDelegate] setAuthUserNo:userNo];
        
        [[AppDelegate sharedAppDelegate] switchMainView];
    } else {
        AlertWithMessage([JSON valueForKeyPath:@"message"]);
    }
    

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([useridField isFirstResponder] && [touch view] != useridField) {
        [useridField resignFirstResponder];
    }
    
    if ([passwdField isFirstResponder] && [touch view] != passwdField) {
        [passwdField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField isEqual:useridField]) {
		[passwdField becomeFirstResponder];
	} else {
		[textField resignFirstResponder];
		[self login:nil];
	}
	return YES;
}

/*
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:passwdField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}
*/

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

#define kOFFSET_FOR_KEYBOARD 80.0
-(void)setViewMovedUp:(BOOL)movedUp
{
    float offset = 80.0;
    
    if (IS_iPhone_5) {
        offset = 40.0;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= offset;
        rect.size.height += offset;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += offset;
        rect.size.height -= offset;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
