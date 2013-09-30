//
//  JobCategoryViewController.m
//  interview
//
//  Created by 김규완 on 13. 8. 8..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "JobCategoryViewController.h"
#import "HttpManager.h"
#import "JobRssViewController.h"

#define kCategoryID         @"CATEGORY_ID"
#define kCategoryName       @"CATEGORY_NAME"


@interface JobCategoryViewController () <UITableViewDataSource, UITableViewDelegate, HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *categoryList;
@property (nonatomic, retain) HttpManager *httpManager;

@end

@implementation JobCategoryViewController

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
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)] autorelease];
    
    self.httpManager = [HttpManager sharedManager];

    self.navigationItem.title = self.categoryName;
    
    //서브 카테고리 조회
    [self requestCategory:@"rbcd" categoryID:self.categoryID];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    
    JobRssViewController *jobRSS = [[JobRssViewController alloc] initWithNibName:@"JobRssViewController" bundle:nil];
    jobRSS.categoryID = self.categoryID;
    jobRSS.subCategoryID = [category objectForKey:kCategoryID];
    jobRSS.rssSource = @"jobkorea";
    jobRSS.title = [category objectForKey:kCategoryName];
    [self.navigationController pushViewController:jobRSS animated:YES];
    [jobRSS release];
    
    
}

@end
