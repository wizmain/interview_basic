//
//  JobKoreaCategoryViewController.m
//  interview
//
//  Created by 김규완 on 13. 7. 10..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "JobKoreaCategoryViewController.h"
#import "JobKoreaRSSViewController.h"
#import "Category.h"
#import "HttpManager.h"
#import "Utils.h"

#define kCategoryID         @"CATEGORY_ID"
#define kCategoryName       @"CATEGORY_NAME"
#define kAreaCategoryID     @"area"
#define kJobsCategoryID     @"rbcd"

@interface JobKoreaCategoryViewController () <UITableViewDataSource, UITableViewDelegate, HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *categoryList;
@property (nonatomic, retain) HttpManager *httpManager;

@end

@implementation JobKoreaCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _subCount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)] autorelease];
    
    self.httpManager = [HttpManager sharedManager];
    
    if(self.title) {
        
    } else {
        self.navigationItem.title = @"잡코리아 카테고리";
    }
    NSLog(@"subCount=%d", self.subCount);
    if(self.subCount == 0) {
        [self bindRootCategory];
    } else if(self.subCount == 1) {
        
        [self requestCategory:self.rootCategory categoryID:@""];
        
    } else {
    
        if (self.categoryID) {
            if (![Utils isNullString:self.categoryID]) {
                [self requestCategory:self.rootCategory categoryID:self.categoryID];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.table = nil;
    self.categoryList = nil;
}

#pragma mark -
#pragma mark Custom Method
- (void) bindRootCategory {
    self.subCount = 0;
    /*
    Category *category1 = [[Category alloc] init];
    category1.cid = @"area";
    category1.name = @"지역별";
    Category *category2 = [[Category alloc] init];
    category2.cid = @"rbcd";
    category2.name = @"업직종별";
    */
    NSDictionary *category1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"area", kCategoryID, @"지역별", kCategoryName, nil];
    NSDictionary *category2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"rbcd", kCategoryID, @"업직종별", kCategoryName, nil];
    self.categoryList = [NSArray arrayWithObjects:category1, category2, nil];
    
    [category1 release];
    [category2 release];
}

- (void)requestCategory:(NSString*)catType categoryID:(NSString*)categoryID{
    NSLog(@"requestCategory catType=%@ categoryID=%@", catType, categoryID);
    [self.httpManager setDelegate:self];
    [self.httpManager requestJobKoreaCategory:catType category:categoryID];
}

#pragma mark -
#pragma mark HTTPRequest delegate
- (void)bindJobKoreaCategory:(NSMutableArray *)categoryData {
	self.categoryList = categoryData;
    NSLog(@"didReceiveFinished jobKoreaCategoryList count %d", [self.categoryList count]);
    [self.table reloadData];
    
}

- (void)close:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.categoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"CategoryCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		UIImage *img = [UIImage imageNamed:@"15-tags"];
		cell.imageView.image = img;
        [img release];
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.categoryList != nil) {
		
		if(_categoryList.count > 0){
			NSDictionary *category = [self.categoryList objectAtIndex:row];
            if(category) {
                cell.textLabel.text = [category objectForKey:kCategoryName];
            }
		}
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    NSLog(@"tableView row = %d", row);
	//Category *category = [self.categoryList objectAtIndex:row];
    
    NSDictionary *category = [self.categoryList objectAtIndex:row];
    
    
    
    if (self.subCount == 0) {
        JobKoreaCategoryViewController *jobKorea = [[JobKoreaCategoryViewController alloc] initWithNibName:@"JobKoreaCategoryViewController" bundle:nil];
        jobKorea.rootCategory = [category objectForKey:kCategoryID];
        jobKorea.title = [category objectForKey:kCategoryName];
        jobKorea.subCount = 1;
        [self.navigationController pushViewController:jobKorea animated:YES];
        [jobKorea release];
    } else if(self.subCount == 1) {
        if([self.rootCategory isEqualToString:kJobsCategoryID]) {
            JobKoreaCategoryViewController *jobKorea = [[JobKoreaCategoryViewController alloc] initWithNibName:@"JobKoreaCategoryViewController" bundle:nil];
            jobKorea.rootCategory = kJobsCategoryID;
            jobKorea.subCount = 2;
            jobKorea.categoryID = [category objectForKey:kCategoryID];
            [self.navigationController pushViewController:jobKorea animated:YES];
            [jobKorea release];
        } else {//area지역
            JobKoreaRSSViewController *jobRSS = [[JobKoreaRSSViewController alloc] initWithNibName:@"JobKoreaRSSViewController" bundle:nil];
            jobRSS.rbcd = @"0";
            jobRSS.rpcd = @"0";
            jobRSS.area = [category objectForKey:kCategoryID];
            jobRSS.title = [category objectForKey:kCategoryName];
            [self.navigationController pushViewController:jobRSS animated:YES];
            [jobRSS release];
        }
    } else if(self.subCount == 2) {
        JobKoreaRSSViewController *jobRSS = [[JobKoreaRSSViewController alloc] initWithNibName:@"JobKoreaRSSViewController" bundle:nil];
        jobRSS.rbcd = self.categoryID;
        jobRSS.rpcd = [category objectForKey:kCategoryID];
        jobRSS.area = @"0";
        jobRSS.title = [category objectForKey:kCategoryName];
        [self.navigationController pushViewController:jobRSS animated:YES];
        [jobRSS release];
    }
    
}

@end
