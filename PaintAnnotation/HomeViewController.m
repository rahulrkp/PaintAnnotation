//
//  HomeViewController.m
//  PaintAnnotation
//
//  Created by Rahul Patel on 5/12/14.
//  Copyright (c) 2014 cloudeeva. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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

    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"img.png"]];
    UIButton *buttonScreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonScreen addTarget:self action:@selector(GoScreenView) forControlEvents:UIControlEventTouchUpInside];
    [buttonScreen setTitle:@"Take a Screen Shot" forState:UIControlStateNormal];
    buttonScreen.frame = CGRectMake(200, 200, 160.0, 140.0);
    [self.view addSubview:buttonScreen];
}
-(void)GoScreenView
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *postImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.paintVC=[[PaintViewController alloc]init];
    self.paintVC.imageBG=postImage;
    [self.navigationController pushViewController:self.paintVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
