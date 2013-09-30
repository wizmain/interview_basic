//
//  InterviewRecordViewController.h
//  interview
//
//  Created by 김규완 on 13. 2. 28..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioStreamer;
@class AVCamCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer, MPMoviePlayerController;

@interface InterviewRecordViewController : UIViewController


@property (nonatomic, retain) NSArray *questionList;

@property (nonatomic, retain) NSString *categoryID;


- (IBAction)toggleRecording:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)nextQuestion:(id)sender;

@end
