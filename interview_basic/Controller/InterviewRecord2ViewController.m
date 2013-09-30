//
//  InterviewRecord2ViewController.m
//  interview
//
//  Created by 김규완 on 13. 3. 6..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "InterviewRecord2ViewController.h"
#import "AnimatedGif.h"
#import "AVCamCaptureManager.h"

static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;

@interface InterviewRecord2ViewController () <AVCamCaptureManagerDelegate>

@property (nonatomic, retain) AVCamCaptureManager *captureManager;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, retain) IBOutlet UIView *videoPreviewView;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;


- (IBAction)close:(id)sender;

@end

@interface InterviewRecord2ViewController (InternalMethods)
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)updateButtonStates;
@end

@interface InterviewRecord2ViewController () <UIGestureRecognizerDelegate>
@end

@implementation InterviewRecord2ViewController


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
    //GIF테스트
    //NSURL *interviewerUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"interviewer1_small" ofType:@"gif"]];
    //UIImageView *gifImage = [AnimatedGif getAnimationForGifAtUrl: interviewerUrl];
    //interviewerGif = [AnimatedGif getAnimationForGifAtUrl: interviewerUrl];
    //[self.view addSubview:gifImage];

    //CGRect frame = gifImage.frame;
    //frame.size.width = 320;
    //frame.size.height = 480;
    //gifImage.frame = frame;
    
    //[interviewerGif addSubview:gifImage];
    //[interviewerGif setHidden:YES];
    
    
    //녹화화면준비
    [self setupAVCam];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    self.videoPreviewView = nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if(UIInterfaceOrientationIsLandscape((toInterfaceOrientation))){
        self.videoPreviewView.frame = CGRectMake(0, 0, 480, 300);
        self.closeButton.frame = CGRectMake(488, 20, 73, 44);
        [self.captureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationLandscapeRight];
        self.captureVideoPreviewLayer.frame = CGRectMake(0, 0, 480, 300);
        
    } else if(UIInterfaceOrientationIsPortrait((toInterfaceOrientation))) {
        self.videoPreviewView.frame = CGRectMake(0, 0, 320, 490);
        self.closeButton.frame = CGRectMake(227, 498, 73, 44);
        [self.captureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
        self.captureVideoPreviewLayer.frame = CGRectMake(0, 0, 320, 490);
    }
}

//레코더 셋업
- (void)setupAVCam {
    
    //오디오 세션 오디오 녹음도 가능하게
    /*
     AVAudioSession* audio = [[AVAudioSession alloc] init];
     [audio setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
     [audio setActive: YES error: nil];
     
     UInt32 allowMixing = true;
     //AudioSessionSetProperty( kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(allowMixing), &allowMixing);
     AudioSessionSetProperty( kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof( allowMixing ), &allowMixing );
     AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
     audioRouteChangeListenerCallback,
     self);
     */
    if ([self captureManager] == nil) {
		AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
		[self setCaptureManager:manager];
		[manager release];
		
		[[self captureManager] setDelegate:self];
        
        NSLog(@"captureManger %@", self.captureManager);
        if(self.captureManager == nil){
            NSLog(@"captureManger nil");
        }
        
		if ([[self captureManager] setupSession]) {
            // Create video preview layer and add it to the UI
			AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
			UIView *view = [self videoPreviewView];
			CALayer *viewLayer = [view layer];
			[viewLayer setMasksToBounds:YES];
			
			CGRect bounds = [view bounds];
			[newCaptureVideoPreviewLayer setFrame:bounds];
			
            
			if ([newCaptureVideoPreviewLayer isOrientationSupported]) {
				[newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
			}
            //[newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationLandscapeRight];
			
			[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
			[self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
            [newCaptureVideoPreviewLayer release];
			
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[[[self captureManager] session] startRunning];
			});
			
            //녹화버튼 상태 업데이트 이부분은 면접질문이 완료되면 셋팅되는걸로 이동
            //[self updateButtonStates];
			
            // Create the focus mode UI overlay
			//AVCaptureFocusMode initialFocusMode = [[[captureManager videoInput] device] focusMode];
			
			[self addObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode" options:NSKeyValueObservingOptionNew context:AVCamFocusModeObserverContext];
            
            
            
            // Add a single tap gesture to focus on the point tapped, then lock focus
			UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
			[singleTap setDelegate:self];
			[singleTap setNumberOfTapsRequired:1];
			[view addGestureRecognizer:singleTap];
			
            // Add a double tap gesture to reset the focus mode to continuous auto focus
			UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToContinouslyAutoFocus:)];
			[doubleTap setDelegate:self];
			[doubleTap setNumberOfTapsRequired:2];
			[singleTap requireGestureRecognizerToFail:doubleTap];
			[view addGestureRecognizer:doubleTap];
			
			[doubleTap release];
			[singleTap release];
            
            /*
             AVURLAsset *interviewer = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"[video]interviewer1" ofType:@"mp4"]] options:nil];
             AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
             */
		}
	}
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation InterviewRecord2ViewController (InternalMethods)

// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [[self videoPreviewView] frame].size;
    
    if ([_captureVideoPreviewLayer isMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }
    
    if ( [[_captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[[self captureManager] videoInput] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[_captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[_captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[_captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:[self videoPreviewView]];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [_captureManager autoFocusAtPoint:convertedFocusPoint];
    }
}

// Change to continuous auto focus. The camera will constantly focus at the point choosen.
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[_captureManager videoInput] device] isFocusPointOfInterestSupported])
        [_captureManager continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

// Update button states based on the number of available cameras and mics
- (void)updateButtonStates
{
	NSUInteger cameraCount = [[self captureManager] cameraCount];
	//NSUInteger micCount = [[self captureManager] micCount];
    
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        if (cameraCount < 2) {
            //[[self cameraToggleButton] setEnabled:NO];
            
            if (cameraCount < 1) {
                //[[self stillButton] setEnabled:NO];
                
                
            } else {
                //[[self stillButton] setEnabled:YES];
                
            }
        } else {
            //[[self cameraToggleButton] setEnabled:YES];
            //[[self stillButton] setEnabled:YES];

        }
    });
}

@end

@implementation InterviewRecord2ViewController (AVCamCaptureManagerDelegate)

- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
    });
}

- (void)captureManagerRecordingFinished:(AVCamCaptureManager *)cm
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        
        
    });

    
}

- (void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        //[[self stillButton] setEnabled:YES];
    });
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
	
}

@end
