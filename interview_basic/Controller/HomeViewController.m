//
//  HomeViewController.m
//  interview
//
//  Created by 김규완 on 13. 2. 25..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "HomeViewController.h"
#import "InterviewStartViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "ScrapViewController.h"
#import "WebViewController.h"
#import "CommunityViewController.h"
#import "Constant.h"
#import "SurveyViewController.h"
#import "InterviewCategoryViewController.h"
#import "JobKoreaCategoryViewController.h"
#import "InterviewRecord2ViewController.h"
#import "JobCategoryViewController.h"
#import "JobRssViewController.h"

#define kPageCount 1

@interface HomeViewController () <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *mainButton1;
@property (nonatomic, retain) IBOutlet UIButton *mainButton2;
@property (nonatomic, retain) IBOutlet UIButton *mainButton3;
@property (nonatomic, retain) IBOutlet UIButton *mainButton4;
@property (nonatomic, retain) IBOutlet UIButton *mainButton5;
@property (nonatomic, retain) IBOutlet UIButton *mainButton6;
@property (nonatomic, retain) IBOutlet UIButton *mainButton7;
@property (nonatomic, retain) IBOutlet UIButton *mainButton8;
@property (nonatomic, retain) IBOutlet UIButton *mainButton9;
@property (nonatomic, retain) IBOutlet UIButton *mainButton10;
@property (nonatomic, retain) IBOutlet UIButton *mainButton11;
@property (nonatomic, retain) IBOutlet UIButton *mainButton12;

@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *page1;
@property (nonatomic, retain) IBOutlet UIView *page2;
@property (nonatomic, retain) IBOutlet UIView *page3;
@property (nonatomic, retain) IBOutlet UIView *page4;
@property (nonatomic, retain) IBOutlet UIView *page5;
@property (nonatomic, retain) IBOutlet UIView *page6;

- (IBAction)buttonClick:(id)sender;
- (IBAction)changePage:(id)sender;

@end

@implementation HomeViewController

@synthesize managedObjectContext;

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
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    //self.view.backgroundColor = [UIColor blueColor];
    self.managedObjectContext = [[AppDelegate sharedAppDelegate] managedObjectContext];
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = kPageCount;
    int height=460;
    if (IS_iPhone_5) {
        height = 548;
        CGRect page1Frame = self.page1.frame;
        CGRect page2Frame = self.page2.frame;
        CGRect page3Frame = self.page3.frame;
        CGRect page4Frame = self.page4.frame;
        CGRect page5Frame = self.page5.frame;
        CGRect page6Frame = self.page6.frame;
        page1Frame.size.height = height;
        page2Frame.size.height = height;
        page3Frame.size.height = height;
        page4Frame.size.height = height;
        page5Frame.size.height = height;
        page6Frame.size.height = height;
        self.page1.frame = page1Frame;
        self.page2.frame = page2Frame;
        self.page3.frame = page3Frame;
        self.page4.frame = page4Frame;
        self.page5.frame = page5Frame;
        self.page6.frame = page6Frame;
    } else {
        CGRect frame = self.pageControl.frame;
        frame.origin.y = 385;
        self.pageControl.frame = frame;
    }
    self.scrollView.contentSize = CGSizeMake(320*kPageCount, height-50);
    
    //직종별
    for (int i=13; i<23; i++) {
        UIButton *button = (UIButton *)[self.page2 viewWithTag:i];
        
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        if(i==14){
            [button setTitle:@"마케팅\n무역・유통" forState:UIControlStateNormal];
        }
        if(i==16){
            [button setTitle:@"영업\n고객상담" forState:UIControlStateNormal];
        }
        if(i==17){
            [button setTitle:@"제조・통신\n화학・건설" forState:UIControlStateNormal];
        }
        if(i==19){
            [button setTitle:@"연구개발\n설계" forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //기업별
    for (int i=25; i<34; i++) {
        UIButton *button = (UIButton *)[self.page3 viewWithTag:i];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //지역별
    for (int i=37; i<48; i++) {
        UIButton *button = (UIButton *)[self.page4 viewWithTag:i];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //공공기관
    for (int i=49; i<56; i++) {
        UIButton *button = (UIButton *)[self.page5 viewWithTag:i];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //교내
    for (int i=62; i<68; i++) {
        UIButton *button = (UIButton *)[self.page6 viewWithTag:i];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==66) {
            [button setTitle:@"아르바이트\n정보" forState:UIControlStateNormal];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    self.mainButton1 = nil;
    self.mainButton2 = nil;
    self.mainButton3 = nil;
    self.mainButton4 = nil;
    self.mainButton5 = nil;
    self.mainButton6 = nil;
    self.mainButton7 = nil;
    self.mainButton8 = nil;
    self.mainButton9 = nil;
    self.mainButton10 = nil;
    self.mainButton11 = nil;
    self.mainButton12 = nil;
    self.managedObjectContext = nil;
    self.page1 = nil;
    self.page2 = nil;
    self.page3 = nil;
    self.page4 = nil;
    self.page5 = nil;
    self.page6 = nil;
}

- (void)dealloc {
    [_mainButton1 release];
    [_mainButton2 release];
    [_mainButton3 release];
    [_mainButton4 release];
    [_mainButton5 release];
    [_mainButton6 release];
    [_mainButton7 release];
    [_mainButton8 release];
    [_mainButton9 release];
    [_mainButton10 release];
    [_mainButton11 release];
    [_mainButton12 release];
    [_page1 release];
    [_page2 release];
    [_page3 release];
    [_page4 release];
    [_page5 release];
    [_page6 release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method
- (IBAction)changePage:(id)sender {
    NSLog(@"changePage");
    int page = self.pageControl.currentPage;
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width *page;
    frame.origin.y = 0;
    
    [self.scrollView scrollRectToVisible:frame animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat pageWidth=self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    self.pageControl.currentPage = page;
}


- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSLog(@"sender tag = %d", button.tag);
    
    if(button.tag == 1){//interview start
        //InterviewStartViewController *start = [[InterviewStartViewController alloc] initWithNibName:@"InterviewStartViewController" bundle:nil];
        [[[AppDelegate sharedAppDelegate] mainViewController] switchTabView:1];
    } else if(button.tag == 2){//스크랩
        ScrapViewController *scrap = [[ScrapViewController alloc] initWithNibName:@"ScrapViewController" bundle:nil];
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:scrap];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [scrap release];
        [navi release];
    } else if(button.tag == 3) {//영상보기
        [[[AppDelegate sharedAppDelegate] mainViewController] switchTabView:2];
    } else if(button.tag == 4) {//잡인터뷰 -> 커뮤니티 변경
        //[[[AppDelegate sharedAppDelegate] mainViewController] switchTabView:3];
    } else if(button.tag == 5) {//취업노하우
        /*
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = kKnowHowUrl;
        web.title = @"취업노하우";
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:web];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [web release];
        [navi release];
        */
        InterviewRecord2ViewController *record = [[InterviewRecord2ViewController alloc] initWithNibName:@"InterviewRecord2ViewController" bundle:nil];
        [self presentViewController:record animated:YES completion:nil];

    } else if(button.tag == 6) {//공지사항
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = kNoticeUrl;
        web.title = @"공지사항";
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:web];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [web release];
        [navi release];
    } else if(button.tag == 7) {//커뮤니티
        CommunityViewController *web = [[CommunityViewController alloc] initWithNibName:@"CommunityViewController" bundle:nil];
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:web];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [web release];
        [navi release];
    } else if(button.tag == 8) {//면접설정
        [[[AppDelegate sharedAppDelegate] mainViewController] switchTabView:4];
    } else if(button.tag == 9) {//이용안내
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = kManualUrl;
        web.title = @"이용안내";
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:web];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [web release];
        [navi release];
    } else if(button.tag == 10) {//설문조사
        SurveyViewController *survey = [[SurveyViewController alloc] initWithNibName:@"SurveyViewController" bundle:nil];
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:survey];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [survey release];
        [navi release];
    } else if(button.tag == 11) {
        JobKoreaCategoryViewController *jobKorea = [[JobKoreaCategoryViewController alloc] initWithNibName:@"JobKoreaCategoryViewController" bundle:nil];
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:jobKorea];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [jobKorea release];
        [navi release];
    } else if(button.tag == 12) {
        WebViewController *webview = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        webview.title = @"공공기관 채용정보";
        webview.urlString = @"http://m.job.alio.go.kr/mobile/mo01.jsp";
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webview];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [webview release];
        [navi release];
    } else if(button.tag == 12) {
        [self goJobCategory:@"49999" categoryName:button.titleLabel.text];
    } else if(button.tag == 13) {
        [self goJobCategory:@"59999" categoryName:button.titleLabel.text];
    } else if(button.tag == 14) {
        [self goJobCategory:@"19999" categoryName:button.titleLabel.text];
    } else if(button.tag == 15) {
        [self goJobCategory:@"b9999" categoryName:button.titleLabel.text];
    } else if(button.tag == 16) {
        [self goJobCategory:@"29999" categoryName:button.titleLabel.text];
    } else if(button.tag == 17) {
        [self goJobCategory:@"39999" categoryName:button.titleLabel.text];
    } else if(button.tag == 18) {
        [self goJobCategory:@"d9999" categoryName:button.titleLabel.text];
    } else if(button.tag == 19) {
        [self goJobCategory:@"69999" categoryName:button.titleLabel.text];
    } else if(button.tag == 20) {
        [self goJobCategory:@"a9999" categoryName:button.titleLabel.text];
    } else if(button.tag == 21) {
        [self goJobCategory:@"37777" categoryName:button.titleLabel.text];
    } else if(button.tag == 22) {
        [self goJobCategory:@"49999" categoryName:button.titleLabel.text];
    } else if(button.tag == 25) {//인크루트
        [self goJobRssList:@"scale=3&at=scale" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"incruit"];//대기업
    } else if(button.tag == 26) {//중견기업
        [self goJobRssList:@"scale=5&at=scale" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"incruit"];
    } else if(button.tag == 27) {//외국계기업
        [self goJobRssList:@"compty=3&at=compty" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"incruit"];
    } else if(button.tag == 28) {//30대그룹사
        [self goJobRssList:@"ct=6&ty=1&cd=3" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"incruit"];
    } else if(button.tag == 29) {//코스피상장
        [self goJobRssList:@"ct=6&ty=1&cd=4" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"incruit"];
    } else if(button.tag == 30) {//병역특례
        [self goJobRssList:@"ct=14&ty=1&cd=3" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"incruit"];
    } else if(button.tag == 31) {//인턴
        [self goJobRssList:@"ct=14&ty=1&cd=4" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"incruit"];
    } else if(button.tag == 37) {//지역별
        [self goJobRssList:@"" subCategoryID:@"I000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//서울인천
    } else if(button.tag == 38) {//지역별
        [self goJobRssList:@"" subCategoryID:@"B000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//경기도
    } else if(button.tag == 39) {//지역별
        [self goJobRssList:@"" subCategoryID:@"H000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//부산경남
    } else if(button.tag == 40) {//지역별
        [self goJobRssList:@"" subCategoryID:@"F000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//대구경북
    } else if(button.tag == 41) {//지역별
        [self goJobRssList:@"" subCategoryID:@"G000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//대전충남
    } else if(button.tag == 42) {//지역별
        [self goJobRssList:@"" subCategoryID:@"P000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//충북
    } else if(button.tag == 43) {//지역별
        [self goJobRssList:@"" subCategoryID:@"E000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//광주전남
    } else if(button.tag == 44) {//지역별
        [self goJobRssList:@"" subCategoryID:@"M000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//전북
    } else if(button.tag == 45) {//지역별
        [self goJobRssList:@"" subCategoryID:@"J000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//울산
    } else if(button.tag == 46) {//지역별
        [self goJobRssList:@"" subCategoryID:@"A000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//강원
    } else if(button.tag == 47) {//지역별
        [self goJobRssList:@"" subCategoryID:@"N000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//제주
    } else if(button.tag == 48) {//지역별
        [self goJobRssList:@"" subCategoryID:@"1000" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//세종시
    } else if(button.tag == 49) {//공공기관
        [self goJobRssList:@"" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"nara"];//최신
    } else if(button.tag == 50) {//공공기관
        [self goJobRssList:@"2" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"nara"];//특별채용
    } else if(button.tag == 51) {//공공기관
        [self goJobRssList:@"4" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"nara"];////행정지원인력
    } else if(button.tag == 52) {//공공기관
        [self goJobRssList:@"8" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"nara"];//공공기관공모
    } else if(button.tag == 53) {//공공기관
        [self goJobRssList:@"1" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"nara"];//공개경쟁채용
    } else if(button.tag == 54) {//공공기관
        WebViewController *webview = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        webview.title = @"공공기관 채용정보";
        webview.urlString = @"http://m.job.alio.go.kr/mobile/mo01.jsp";
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webview];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [webview release];
        [navi release];
    } else if(button.tag == 55) {//공공기관
        WebViewController *webview = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        webview.title = @"워크넷";
        webview.urlString = @"http://m.work.go.kr/main.do";
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webview];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [webview release];
        [navi release];
    } else if(button.tag == 56) {//공공기관
        [self goJobRssList:@"10100" subCategoryID:@"" categoryName:button.titleLabel.text rssSource:@"jobkorea"];//공개경쟁채용
    }
    
}

- (void)goJobCategory:(NSString*)categoryID categoryName:(NSString *)categoryName {
    JobCategoryViewController *jobCategory = [[JobCategoryViewController alloc] initWithNibName:@"JobCategoryViewController" bundle:nil];
    jobCategory.categoryID = categoryID;
    jobCategory.categoryName = categoryName;
    UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:jobCategory];
    if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
    }
    [self presentModalViewController:navi animated:YES];
    [naviBg release];
    [jobCategory release];
    [navi release];
}

- (void)goJobRssList:(NSString *)categoryID subCategoryID:(NSString*)subCategoryID categoryName:(NSString*)categoryName rssSource:(NSString*)rssSource {
    JobRssViewController *jobRSS = [[JobRssViewController alloc] initWithNibName:@"JobRssViewController" bundle:nil];
    jobRSS.categoryID = categoryID;
    jobRSS.subCategoryID = subCategoryID;
    jobRSS.title = categoryName;
    jobRSS.rssSource = rssSource;
    //[self.navigationController pushViewController:jobRSS animated:YES];
    UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:jobRSS];
    if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
    }
    [self presentModalViewController:navi animated:YES];
    [naviBg release];
    [navi release];
    [jobRSS release];

}

- (void)deleteAll {
    NSLog(@"DeleteAll");
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entiryDescription = [NSEntityDescription entityForName:@"InterviewQuestion" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entiryDescription];
    
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for(NSManagedObject *item in items) {
        
        NSLog(@"delete interviewQuestion=%@", item);
        [self.managedObjectContext deleteObject:item];
    }
    
    entiryDescription = [NSEntityDescription entityForName:@"Interview" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entiryDescription];
    
    items = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    [request release];
    
    for(NSManagedObject *item in items) {
        
        NSLog(@"delete interview=%@", item);
        [self.managedObjectContext deleteObject:item];
        
    }
    
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Problem deleting destination: %@", [error localizedDescription]);
    }
    
    
}


@end
