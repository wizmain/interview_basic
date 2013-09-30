//
//  JobRssViewController.h
//  interview
//
//  Created by 김규완 on 13. 8. 8..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobRssViewController : UIViewController

@property (nonatomic, retain) NSString *categoryID;//업종1차
@property (nonatomic, retain) NSString *subCategoryID;//업종2차
@property (nonatomic, retain) NSString *rssSource;//잡코리아, 인쿠르트..

@end
