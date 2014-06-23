//
//  BaseViewController.m
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-19.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import "AssetsBaseViewController.h"

@interface AssetsBaseViewController ()

@end


@implementation AssetsBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView
{
    UIInterfaceOrientation ori= self.interfaceOrientation;

    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (UIInterfaceOrientationIsLandscape(ori))
        rect.size = CGSizeMake(rect.size.height, rect.size.width);
    
    UIView* tempView = [[UIView alloc] initWithFrame:rect];
    self.view = tempView;
    [tempView release];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (CGRect)getLandscapeBounds
{
    CGRect rect = self.view.bounds;
    if (rect.size.height>= rect.size.width)
        rect.size = CGSizeMake(rect.size.height, rect.size.width);
    return rect;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)InterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(InterfaceOrientation);
}
#ifdef __IPHONE_6_0
// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}
#endif
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
