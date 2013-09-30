//
//  JobRssViewController.m
//  interview
//
//  Created by 김규완 on 13. 8. 8..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "JobRssViewController.h"
#import "Constant.h"
#import "TouchXML.h"
#import "JobRSSCell.h"
#import "WebViewController.h"
#import "HttpManager.h"
#import "NSString+HTML.h"
#import "JobKoreaRSSCell.h"

@interface JobRssViewController () <UITableViewDelegate, UITableViewDataSource, HttpManagerDelegate>

@property (nonatomic, retain) NSMutableArray *rssList;
@property (nonatomic, retain) IBOutlet UITableView *table;


@end

@implementation JobRssViewController

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
    NSString *urlString = nil;
    if([self.rssSource isEqualToString:@"incruit"]){
        urlString = [NSString stringWithFormat:@"%@?%@", kJobIncruitRSSUrl, self.categoryID];
    } else if([self.rssSource isEqualToString:@"nara"]){
        urlString = [NSString stringWithFormat:@"%@?bbs_id=%@", kJobNaraRSSUrl, self.categoryID];
    } else {
        urlString = [NSString stringWithFormat:@"%@?rbcd=%@&rpcd=%@&area=/0/0/0/0/0/0/&edu1=-1&edu2=0&edu3=0&car1=&car2=&car_chk=0", kJobKoreaRSSUrl, self.categoryID, self.subCategoryID];
    }
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
	
    static NSString *jobRSSIdentifier = @"RSSCell1";
    static NSString *jobRSSIdentifier2 = @"RSSCell2";
    
    JobRSSCell *cell = nil;
    JobKoreaRSSCell *cell2 = nil;
    if ([self.rssSource isEqualToString:@"jobkorea"]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:jobRSSIdentifier];
        if (cell == nil) {
            cell = [JobRSSCell cellWithNib];
        }
    } else {
        cell2 = [tableView dequeueReusableCellWithIdentifier:jobRSSIdentifier2];
        if (cell2 == nil) {
            cell2 = [JobKoreaRSSCell cellWithNib];
        }
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
                description = [description stringByReplacingOccurrencesOfString:@"<br><br>" withString:@"<br/>"];
                //[cell.contentView loadHTMLString:description baseURL:nil];
                //[cell.contentView setValue:description forKey:@"contentToHTMLString"];
                //cell.contentView.text = @"test";
                
                NSArray *arr = [description componentsSeparatedByString:@"<br/>"];
                if(arr.count > 6) {
                    NSString *companyName = [arr objectAtIndex:0];
                    NSString *title = [arr objectAtIndex:1];
                    NSString *enrollPeriod = [arr objectAtIndex:2];
                    NSString *manageWork = [arr objectAtIndex:3];
                    NSString *employType = [arr objectAtIndex:4];
                    NSString *qulifications = [arr objectAtIndex:5];
                    NSString *workArea = [arr objectAtIndex:6];
                    
                    NSArray *item1 = [companyName componentsSeparatedByString:@":"];
                    NSArray *item2 = [title componentsSeparatedByString:@":"];
                    NSArray *item3 = [enrollPeriod componentsSeparatedByString:@":"];
                    NSArray *item4 = [manageWork componentsSeparatedByString:@":"];
                    NSArray *item5 = [employType componentsSeparatedByString:@":"];
                    NSArray *item6 = [qulifications componentsSeparatedByString:@":"];
                    NSArray *item7 = [workArea componentsSeparatedByString:@":"];
                    
                    if (item1.count == 2) {
                        NSString *str = [item1 objectAtIndex:1];
                        cell.label1.text = [str stringByConvertingHTMLToPlainText];
                    }
                    if (item2.count == 2) {
                        NSString *str = [item2 objectAtIndex:1];
                        cell.titleView.text = [str stringByConvertingHTMLToPlainText];
                    }
                    if (item3.count == 2) {
                        NSString *str = [item3 objectAtIndex:1];
                        cell.label2.text = [str stringByConvertingHTMLToPlainText];
                    }
                    if (item4.count == 2) {
                        NSString *str = [item4 objectAtIndex:1];
                        cell.label3.text = [str stringByConvertingHTMLToPlainText];
                    }
                    if (item5.count == 2) {
                        NSString *str = [item5 objectAtIndex:1];
                        cell.label4.text = [str stringByConvertingHTMLToPlainText];
                    }
                    if (item6.count == 2) {
                        NSString *str = [item6 objectAtIndex:1];
                        cell.label5.text = [str stringByConvertingHTMLToPlainText];
                    }
                    if (item7.count == 2) {
                        NSString *str = [item7 objectAtIndex:1];
                        cell.label6.text = [str stringByConvertingHTMLToPlainText];
                    }
                    
                } else {
                    [cell2.contentView loadHTMLString:description baseURL:nil];
                }
                
                //[cell.contentView loadHTMLString:description baseURL:nil];
                
            }
		}
	}
	
    if ([self.rssSource isEqualToString:@"jobkorea"]) {
        return cell;
    } else {
        return cell2;
    }
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
    //return [self cellHeight:[indexPath row]];
    return 173;
}



- (CGFloat)cellHeight:(int)row {
    
    NSDictionary *rss = [self.rssList objectAtIndex:row];
    //Original
    //NSString *aText = [NSString stringWithFormat:@"%@",[rss valueForKey:@"title"]];
    //CGSize textSize = [aText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 20) - PADDING * 3, 1000.0f)];
    
    
    NSString *aText = [NSString stringWithFormat:@"%@", [rss valueForKey:@"title"]];
    CGSize textSize = [aText sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 20) - PADDING * 3, 1000.0f)];
    
    
    //NSString *description = [rss objectForKey:@"description"];
    //NSString *description = [NSString stringWithFormat:@"%@", [rss valueForKey:@"description"]];
    //description = [description stringByReplacingOccurrencesOfString:@"<br><br>" withString:@"\n"];
    //NSLog(@"title=%@", [rss objectForKey:@"title"]);
    //㈜
    //description = [description stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"];
    
    
    /*
    NSString *eText = description;
    //CGSize textSize2 = [eText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 20) - PADDING * 3, 1000.0f)];
    CGSize textSize2 = [eText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 10) - PADDING, 1000.0f)];
    */
    return textSize.height + 200;
}


@end
