//
//  InterviewCategoryViewController.m
//  interview
//
//  Created by 김규완 on 13. 7. 10..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "InterviewCategoryViewController.h"
#import "InterviewListController.h"
#import "InterviewInfoViewController.h"

@interface InterviewCategoryViewController ()

@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *button4;
@property (nonatomic, retain) IBOutlet UIButton *button5;
@property (nonatomic, retain) IBOutlet UIButton *button6;
@property (nonatomic, retain) IBOutlet UIButton *button7;
@property (nonatomic, retain) IBOutlet UIButton *button8;

- (IBAction)buttonClick:(id)sender;

@end

@implementation InterviewCategoryViewController

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
    
    self.navigationItem.title = @"면접시작";
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithObjects:self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7, self.button8, nil];
    
    if (IS_iPhone_5) {
        for (int i = 0; i<buttonArray.count; i++) {
            UIButton *button = [buttonArray objectAtIndex:i];
            CGRect frame = button.frame;
            frame.origin.y = frame.origin.y + 40;
            button.frame = frame;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.button6 = nil;
    self.button7 = nil;
    self.button8 = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
    
    [_button1 release];
    [_button2 release];
    [_button3 release];
    [_button4 release];
    [_button5 release];
    [_button6 release];
    [_button7 release];
    [_button8 release];
    [super dealloc];
}

- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == 0) {//주요대기업
        InterviewListController *v = [[InterviewListController alloc] initWithNibName:@"InterviewListController" bundle:nil];
        v.categoryID = @"K";
        v.categoryName = @"주요대기업";
        [self.navigationController pushViewController:v animated:YES];
        [v release];
    } else if (button.tag == 1) {//공사,공공기관
        InterviewListController *v = [[InterviewListController alloc] initWithNibName:@"InterviewListController" bundle:nil];
        v.categoryID = @"P";
        v.categoryName = @"공사,공공기관";
        [self.navigationController pushViewController:v animated:YES];
        [v release];
    } else if (button.tag == 2) {//공무원
        InterviewInfoViewController *v = [[InterviewInfoViewController alloc] initWithNibName:@"InterviewInfoViewController" bundle:[NSBundle mainBundle]];
        v.categoryID = @"F";
        [self.navigationController pushViewController:v animated:YES];
        [v release];
    } else if (button.tag == 3) {//시사, 상식
        InterviewInfoViewController *v = [[InterviewInfoViewController alloc] initWithNibName:@"InterviewInfoViewController" bundle:[NSBundle mainBundle]];
        v.categoryID = @"G";
        [self.navigationController pushViewController:v animated:YES];
        [v release];
        
    } else if (button.tag == 4) {//학과별면접질문
        InterviewListController *v = [[InterviewListController alloc] initWithNibName:@"InterviewListController" bundle:nil];
        v.categoryID = @"U";
        v.categoryName = @"학과별면접질문";
        [self.navigationController pushViewController:v animated:YES];
        [v release];
    } else if (button.tag == 5) {//업종별
        InterviewListController *v = [[InterviewListController alloc] initWithNibName:@"InterviewListController" bundle:nil];
        v.categoryID = @"C";
        v.categoryName = @"업종별";
        [self.navigationController pushViewController:v animated:YES];
        [v release];
    } else if (button.tag == 6) {//질문유형별
        InterviewListController *v = [[InterviewListController alloc] initWithNibName:@"InterviewListController" bundle:nil];
        v.categoryID = @"B";
        v.categoryName = @"질문유형별";
        [self.navigationController pushViewController:v animated:YES];
        [v release];
    } else if (button.tag == 7) {//표준면접질문
        InterviewInfoViewController *v = [[InterviewInfoViewController alloc] initWithNibName:@"InterviewInfoViewController" bundle:[NSBundle mainBundle]];
        v.categoryID = @"A";
        [self.navigationController pushViewController:v animated:YES];
        [v release];
    }
}

@end
