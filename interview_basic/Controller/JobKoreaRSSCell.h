//
//  JobKoreaRSSCell.h
//  interview
//
//  Created by 김규완 on 13. 7. 12..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface JobKoreaRSSCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIWebView *contentView;

+ (id)cellWithNib;

@end

