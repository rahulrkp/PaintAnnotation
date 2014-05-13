//
//  MainViewController.h
//  PaintAnnotation
//
//  Created by Rahul Patel on 5/7/14.
//  Copyright (c) 2014 cloudeeva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MainViewController : UIViewController<UITextFieldDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    UIToolbar *toolbar;
}
@property(nonatomic, strong)UIImage *backgroundImage;

@end
