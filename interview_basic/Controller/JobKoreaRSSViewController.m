//
//  JobKoreaRSSViewController.m
//  interview
//
//  Created by 김규완 on 13. 7. 10..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "JobKoreaRSSViewController.h"
#import "Constant.h"
#import "TouchXML.h"
#import "JobKoreaRSSCell.h"
#import "WebViewController.h"

@interface JobKoreaRSSViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *rssList;
@property (nonatomic, retain) IBOutlet UITableView *table;


@end

@implementation JobKoreaRSSViewController

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
    
    [self requestRSSList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
    self.table = nil;
    self.rssList = nil;
}

- (void)dealloc {
    
    
    [super dealloc];
    
}


- (void)requestRSSList {
    
    NSLog(@"requestRSSList");
    
    /*
     if(selectedTab == 1){
     url = "http://www.jobkorea.co.kr/rss/GI_Search_List.asp?rbcd="+categoryID+"&rpcd="+subCategoryID+"&area=/0/0/0/0/0/0/&edu1=-1&edu2=0&edu3=0&car1=&car2=&car_chk=0";
     } else {
     url = "http://www.jobkorea.co.kr/rss/GI_Search_List.asp?rbcd=0&rpcd=0&area=/"+subCategoryID+"/0/0/0/0/0/&edu1=-1&edu2=0&edu3=0&car1=&car2=&car_chk=0";
     }
    */
    
    _rssList = [[NSMutableArray alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@?rbcd=%@&rpcd=%@&area=/%@/0/0/0/0/0/", kJobKoreaRSSUrl, self.rbcd, self.rpcd, self.area];
    NSLog(@"urlString=%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    
    
    //CXMLDocument *theXMLDocument = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error] autorelease];
    CXMLDocument *theXMLDocument = [[[CXMLDocument alloc] initWithContentsOfURL:url encoding:0x80000003 options:0 error:&error] autorelease];
    NSArray *resultNodes = nil;
    
    if(error){
        NSLog(@"fail with = %@", error);
    }
    
    resultNodes = [theXMLDocument nodesForXPath:@"//item" error:nil];
    
    for(CXMLElement *item in resultNodes) {
        NSMutableDictionary *rss = [[NSMutableDictionary alloc] init];
        int i=0;
        for(i=0;i<[item childCount];i++){
            [rss setObject:[[item childAtIndex:i] stringValue] forKey:[[item childAtIndex:i] name]];
        }
        [_rssList addObject:[rss copy]];
    }
    
}


- (void)close:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source


#define PADDING 10.0f

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.rssList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"RSSCell1212";
    
    JobKoreaRSSCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [JobKoreaRSSCell cellWithNib];
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.rssList != nil) {
		
		if(self.rssList.count > 0){
			NSDictionary *rss = [self.rssList objectAtIndex:row];
            if(rss) {
                
                
                
                //cell.titleView.text = [rss objectForKey:@"title"];
            
                /*
                NSString *aText = [NSString stringWithFormat:@"%@",[rss valueForKey:@"title"]];
                CGSize textSize = [aText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 20) - PADDING * 3, 1000.0f)];
                
                CGRect frame1 = cell.titleText.frame;
                frame1.size.height = textSize.height;
                
                cell.titleText.frame = frame1;
                
                CGRect frame2 = cell.contentView.frame;
                frame2.origin.y = 100;
                cell.contentView.frame = frame2;
                cell.contentView.textColor = [UIColor redColor];
                cell.contentView.backgroundColor = [UIColor grayColor];
                */
                //UITextView *a = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
                //a.text
                //NSLog(@"title=%@", [rss objectForKey:@"title"]);
                //cell.textLabel.text = [rss objectForKey:@"title"];
                /*
                NSString *dateString = [rss objectForKey:@"pubDate"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
                NSDate *date = [formatter dateFromString:dateString];
                [formatter setDateFormat:@"yyyy.MM.dd"];
                NSString *dateStringResult = [formatter stringFromDate:date];
                //if([rss objectForKey:@"pubDate"] != (id)[NSNull null]){
                //    cell.detailTextLabel.text = dateStringResult;
                //}
                */
                //cell.detailTextLabel.text = dateStringResult;
                
                NSString *description = [rss objectForKey:@"description"];
                description = [description stringByReplacingOccurrencesOfString:@"<br><br>" withString:@"<br>"];
                //[cell.contentView loadHTMLString:description baseURL:nil];
                //[cell.contentView setValue:description forKey:@"contentToHTMLString"];
                //cell.contentView.text = @"test";
                
                [cell.contentView loadHTMLString:description baseURL:nil];
                
            }
		}
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    //NSLog(@"tableView row = %d", row);
	//Category *category = [self.categoryList objectAtIndex:row];
    
    NSDictionary *rss = [self.rssList objectAtIndex:row];
    
    WebViewController *webview = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    NSLog(@"urlString = %@",[rss objectForKey:@"link"]);
    webview.urlString = [rss objectForKey:@"link"];
    webview.title = [rss objectForKey:@"title"];
    [self.navigationController pushViewController:webview  animated:YES];
    [webview release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeight:[indexPath row]];
    //return 216;
}



- (CGFloat)cellHeight:(int)row {
    
    NSDictionary *rss = [self.rssList objectAtIndex:row];
    
    //NSString *aText = [NSString stringWithFormat:@"%@",[rss valueForKey:@"title"]];
    //CGSize textSize = [aText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 20) - PADDING * 3, 1000.0f)];
    
    //NSString *description = [rss objectForKey:@"description"];
    NSString *description = [NSString stringWithFormat:@"%@", [rss valueForKey:@"description"]];
    description = [description stringByReplacingOccurrencesOfString:@"<br><br>" withString:@"\n"];
    NSLog(@"title=%@", [rss objectForKey:@"title"]);
    //㈜
    //description = [description stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"];
    
    NSString *eText = description;
    //CGSize textSize2 = [eText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 20) - PADDING * 3, 1000.0f)];
    CGSize textSize2 = [eText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 10) - PADDING, 1000.0f)];
    /*
    if(textSize.height + textSize2.height > 60) {
        return textSize.height + PADDING * 3 - 10 + textSize2.height;
    } else {
        return textSize.height + PADDING * 3 - 3 + textSize2.height;
    }
    */
    return textSize2.height;
}

@end
