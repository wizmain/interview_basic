//
//  JobRSSCell.m
//  interview
//
//  Created by 김규완 on 13. 8. 9..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "JobRSSCell.h"

@implementation JobRSSCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)cellWithNib
{
    
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"JobRSSCell" bundle:nil];
    JobRSSCell *cell = (JobRSSCell *)controller.view;
    
    
    //[cell.titleView addObserver:cell forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    [controller release];
    
    return cell;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    //Center vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
}


@end
