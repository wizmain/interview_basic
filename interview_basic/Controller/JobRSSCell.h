//
//  JobRSSCell.h
//  interview
//
//  Created by 김규완 on 13. 8. 9..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobRSSCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UITextView *titleView;
@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UILabel *label3;
@property (nonatomic, retain) IBOutlet UILabel *label4;
@property (nonatomic, retain) IBOutlet UILabel *label5;
@property (nonatomic, retain) IBOutlet UILabel *label6;


+ (id)cellWithNib;

@end
