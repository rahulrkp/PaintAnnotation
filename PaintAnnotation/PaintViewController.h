//
//  PaintViewController.h
//  PaintAnnotation
//
//  Created by Rahul Patel on 5/7/14.
//  Copyright (c) 2014 cloudeeva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PaintViewController : UIViewController<UITextFieldDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    BOOL istextF;
    UIButton *buttonTextF;
    UIToolbar *toolbar;
    IBOutlet UIView *playView,*viewRecording;
    IBOutlet UISlider *sliderPlay,*sliderRecord;
    IBOutlet UILabel *lableMin,*lableMax,*lableMidle,*lableRecMax;
    NSTimer *timerPlay,*timerRecord;
}
@property (strong, nonatomic) MainView *mainView;
@property (strong, nonatomic) UIImage *imageBG;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
-(IBAction)CloseAction:(UIButton*)sender;

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;

@end
