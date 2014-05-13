//
//  PaintViewController.m
//  PaintAnnotation
//
//  Created by Rahul Patel on 5/7/14.
//  Copyright (c) 2014 cloudeeva. All rights reserved.
//

#import "PaintViewController.h"

@interface PaintViewController ()
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;

}
@end

@implementation PaintViewController
@synthesize stopButton, playButton, recordPauseButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
//    UIDevice *device = [UIDevice currentDevice];
//    UIDeviceOrientation currentOrientation = device.orientation;
    [self didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=TRUE;
    self.mainView=[[MainView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height-100)];
    self.mainView.backgroundColor=[UIColor colorWithPatternImage:self.imageBG];
    [self.view addSubview:self.mainView];
    // Do any additional setup after loading the view.
    buttonTextF = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonTextF addTarget:self action:@selector(iSCreateTextField) forControlEvents:UIControlEventTouchUpInside];
    [buttonTextF setTitle:@"New Text Field" forState:UIControlStateNormal];
    buttonTextF.frame = CGRectMake(0, 0, 100, 40);
    //[self.view addSubview:buttonTextF];
    
    UIButton *buttonScreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonScreen addTarget:self action:@selector(screenShot) forControlEvents:UIControlEventTouchUpInside];
    [buttonScreen setTitle:@"Preview" forState:UIControlStateNormal];
    buttonScreen.frame = CGRectMake(0, 0, 100, 40);

    
    UIBarButtonItem *barButtonL = [[UIBarButtonItem alloc]initWithCustomView:buttonTextF];
    //self.navigationItem.leftBarButtonItem = barButtonL;
    
    UIBarButtonItem *barButtonR = [[UIBarButtonItem alloc]initWithCustomView:buttonScreen];
//    self.navigationItem.rightBarButtonItem = barButtonR;
    
    
    UIButton *playbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playbtn addTarget:self action:@selector(PlayViewShow:) forControlEvents:UIControlEventTouchUpInside];
    [playbtn setTitle:@"Play" forState:UIControlStateNormal];
    playbtn.frame = CGRectMake(0, 0, 100, 40);
    

    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [recordBtn addTarget:self action:@selector(RecordViewShow:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn setTitle:@"Record" forState:UIControlStateNormal];
    recordBtn.frame = CGRectMake(0, 0, 100, 40);

    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];

    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];


    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width-45, 45);
    NSArray *toolbarItems = [NSArray arrayWithObjects:barButtonL,[[UIBarButtonItem alloc]initWithCustomView:playbtn],[[UIBarButtonItem alloc]initWithCustomView:recordBtn],flexibleItem,barButtonR,nil];

    [toolbar setItems:toolbarItems animated:NO];
    [self.view addSubview:toolbar];
    
//    playView.frame=CGRectMake(100, 100, 400, 300);
    playView.layer.borderWidth=10;
    playView.layer.borderColor = [UIColor greenColor].CGColor;
    playView.layer.cornerRadius = 10;
    [playView.layer setMasksToBounds:YES];
    [self.view addSubview:playView];

    viewRecording.layer.borderWidth=10;
    viewRecording.layer.borderColor = [UIColor redColor].CGColor;
    viewRecording.layer.cornerRadius = 10;
    [viewRecording.layer setMasksToBounds:YES];
    [self.view addSubview:viewRecording];

    playView.hidden=TRUE;
    viewRecording.hidden=TRUE;

}
-(void)screenShot
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.mainView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *postImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (self.mainViewController == nil) {
        self.mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    }
    self.mainViewController.backgroundImage = postImage;
    
//    [self presentViewController:self.mainViewController animated:YES completion:nil];
    [self.navigationController pushViewController:self.mainViewController animated:YES];
}
-(IBAction)CloseAction:(UIButton*)sender
{
    NSLog(@"CloseAction");
    [sender superview].hidden=TRUE;
    [timerRecord invalidate];
    [timerPlay invalidate];

}
-(void)iSCreateTextField
{
    if (!istextF) {
        [buttonTextF setTitle:@"Paint" forState:UIControlStateNormal];
        istextF=1;
        self.mainView.userInteractionEnabled=FALSE;
        self.view.userInteractionEnabled=TRUE;
        NSLog(@"if istextF=%d",istextF);
        
    }
    else
    {
        [buttonTextF setTitle:@"New Text Field" forState:UIControlStateNormal];
        istextF=0;
        self.mainView.userInteractionEnabled=TRUE;
        self.view.userInteractionEnabled=TRUE;
        NSLog(@"else istextF=%d",istextF);
        for(UIView *view in [self.view subviews]) {
            if([view isKindOfClass:[UITextField class]])
            {
                [view removeFromSuperview];
            }
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:textField.frame];
    lbl1.backgroundColor=[UIColor greenColor];
    lbl1.textColor=[UIColor blueColor];
    lbl1.userInteractionEnabled=NO;
    lbl1.text= textField.text;
    
    
    CGSize constraint = CGSizeMake(lbl1.frame.size.width, 2000.0f);
    CGSize lblsize;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [textField.text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:lbl1.font}
                                            context:context].size;
    
    lblsize = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    [lbl1 setFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y, lblsize.width, lblsize.height)];
    [self.mainView addSubview:lbl1];
    [textField removeFromSuperview];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan paint view");
    if (self.mainView.userInteractionEnabled) {
        self.view.userInteractionEnabled=FALSE;
        return;
    }
    for(UIView *view in [self.view subviews]) {
        if([view isKindOfClass:[UITextField class]])
        {
            [self textFieldShouldReturn:(UITextField*)view];
            [self iSCreateTextField];
            return;
        }
    }

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    NSLog(@"Touch x : %f y : %f", touchPoint.x, touchPoint.y);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(touchPoint.x, touchPoint.y, 300, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"enter text";
    textField.tag=10;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [self.view addSubview:textField];
    [textField becomeFirstResponder];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
//    if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationLandscapeLeft))
        return YES;
    
//    return NO;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation currentOrientation = device.orientation;
    
    self.mainView.frame=CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-45, self.view.frame.size.width, 45);

    if ((currentOrientation == UIInterfaceOrientationPortrait) || (currentOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
    }
    if ((currentOrientation == UIInterfaceOrientationLandscapeLeft) || (currentOrientation == UIInterfaceOrientationLandscapeRight))
    {
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        timerRecord=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeRecord:) userInfo:nil repeats:YES];

        
    } else {
        
        // Pause recording
        [recorder pause];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
    
    sliderRecord.maximumValue = [recorder currentTime];
    int min=sliderRecord.maximumValue/60;
    int sec = lroundf(sliderRecord.maximumValue) % 60;
    lableRecMax.text = [NSString stringWithFormat:@"%d:%d", min,sec];
    
    
    sliderRecord.value = [recorder currentTime];

}

- (IBAction)stopTapped:(id)sender {
    [timerRecord invalidate];
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}
-(void)PlayViewShow:(id)sender
{
    NSLog(@"PlayViewShow");
    if (playView.hidden) {
        [self.mainView bringSubviewToFront:playView];
        playView.alpha = 0;
        playView.frame = CGRectMake(50, self.view.frame.size.height, 360, 110);

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        [UIView setAnimationDelegate:self];
        
        [UIView setAnimationDuration:1];
        playView.alpha = 1;
        playView.hidden=FALSE;
        playView.frame = CGRectMake(50, self.view.frame.size.height-200, 360, 110);

        [UIView commitAnimations];

    }
    else
    playView.hidden=TRUE;
    

}
-(void)RecordViewShow:(id)sender
{
    NSLog(@"PlayViewShow");
    if (viewRecording.hidden) {
       // viewRecording.hidden=FALSE;
        viewRecording.frame = CGRectMake(50, self.view.frame.size.height, 360, 110);

        [self.mainView bringSubviewToFront:viewRecording];
        viewRecording.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        [UIView setAnimationDelegate:self];
        
        [UIView setAnimationDuration:1];
        viewRecording.alpha = 1;
        viewRecording.hidden=FALSE;
        viewRecording.frame = CGRectMake(50, self.view.frame.size.height-200, 360, 110);

        //    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];

    }
    else
        viewRecording.hidden=TRUE;

}
- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
        sliderPlay.maximumValue = [player duration];
        
        int min=sliderPlay.maximumValue/60;
        
        int sec = lroundf(sliderPlay.maximumValue) % 60;
        
        lableMax.text = [NSString stringWithFormat:@"%d:%d", min,sec];


        sliderPlay.value = 0.0;
        
        timerPlay=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];

        NSLog(@"%f",player.currentTime);
    }
}
- (IBAction)slidePlay {
    player.currentTime = sliderPlay.value;
}

- (void)updateTime:(NSTimer *)timer {
    sliderPlay.value = player.currentTime;
    
    int min=player.currentTime/60;
    
    int sec = lroundf(player.currentTime) % 60;
    
    // update your UI with timeLeft
    lableMidle.text = [NSString stringWithFormat:@"%d:%d", min,sec];
    if (playView.hidden) {
        [timerPlay invalidate];
    }
}
- (void)updateTimeRecord:(NSTimer *)timer {
    sliderRecord.value = recorder.currentTime;
    sliderRecord.maximumValue = recorder.currentTime;
    
    int min=recorder.currentTime/60;
    
    int sec = lroundf(recorder.currentTime) % 60;
    
    // update your UI with timeLeft
    lableRecMax.text = [NSString stringWithFormat:@"%d:%d", min,sec];
    NSLog(@"updateTimeRecord=%f",sliderRecord.value);
    if (viewRecording.hidden) {
        [timerRecord invalidate];
    }

}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
    [timerRecord invalidate];

}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [timerPlay invalidate];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
