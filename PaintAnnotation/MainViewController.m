//
//  MainViewController.m
//  PaintAnnotation
//
//  Created by Rahul Patel on 5/7/14.
//  Copyright (c) 2014 cloudeeva. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
}
@end

@implementation MainViewController

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
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(ShareImage)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Share" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 10, 160.0, 40.0);
    UIBarButtonItem *barButtonR = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = barButtonR;

    
    UIButton *playbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [playbtn addTarget:self action:@selector(PlayViewShow:) forControlEvents:UIControlEventTouchUpInside];
    [playbtn setTitle:@"Play" forState:UIControlStateNormal];
    playbtn.frame = CGRectMake(0, 0, 100, 40);
    
    
    
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
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width-45, 45);
    NSArray *toolbarItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithCustomView:playbtn],flexibleItem,barButtonR,nil];
    
    [toolbar setItems:toolbarItems animated:NO];
    [self.view addSubview:toolbar];
    
//    //    playView.frame=CGRectMake(100, 100, 400, 300);
//    playView.layer.borderWidth=10;
//    playView.layer.borderColor = [UIColor greenColor].CGColor;
//    playView.layer.cornerRadius = 10;
//    [playView.layer setMasksToBounds:YES];
//    [self.view addSubview:playView];

}

-(void)ShareImage
{
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];

    
    NSArray *activityItems =@[outputFileURL,self.backgroundImage];
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation currentOrientation = device.orientation;
    
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-45, self.view.frame.size.width, 45);
    
    if ((currentOrientation == UIInterfaceOrientationPortrait) || (currentOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
    }
    if ((currentOrientation == UIInterfaceOrientationLandscapeLeft) || (currentOrientation == UIInterfaceOrientationLandscapeRight))
    {
    }
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
